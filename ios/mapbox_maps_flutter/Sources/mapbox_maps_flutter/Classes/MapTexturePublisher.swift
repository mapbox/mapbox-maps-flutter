import Flutter
import MetalKit
import ObjectiveC.runtime

/// Publishes an `MTKView`'s frames as a flutter texture.
///
/// The map draws into its own drawable as usual. Each finished frame is
/// blitted into an IOSurface-backed `CVPixelBuffer` and handed to
/// `FlutterTextureRegistry`, so flutter can composite the map like any other
/// widget rather than as a platform view.
///
/// Two details are load-bearing:
///
/// `framebufferOnly = false` on the view, or the drawable's texture cannot be
/// used as a blit source and every copy fails.
///
/// The frame that is copied is the PREVIOUS one, not the one just handed over.
/// There is no completion callback for a drawable on this sdk, and the current
/// frame has not finished rendering when the draw call returns, while the one
/// before it provably has. The cost is one frame of latency.
final class MapTexturePublisher: NSObject, FlutterTexture {
    private struct Entry {
        let buffer: CVPixelBuffer
        let cvTexture: CVMetalTexture
        let texture: MTLTexture
    }

    private static var swizzled = Set<ObjectIdentifier>()
    private static let registry = NSMapTable<CAMetalLayer, MapTexturePublisher>
        .weakToWeakObjects()
    private static var presentHooked = false

    private let textures: FlutterTextureRegistry
    private weak var mapView: UIView?
    private weak var mtkView: MTKView?

    private var textureId: Int64 = -1
    private var queue: MTLCommandQueue?
    private var textureCache: CVMetalTextureCache?
    private var ring: [Entry] = []
    private var ringIndex = 0
    private var ringWidth = 0
    private var ringHeight = 0
    private let lock = NSLock()
    private var latest: CVPixelBuffer?

    init(mapView: UIView, textures: FlutterTextureRegistry) {
        self.mapView = mapView
        self.textures = textures
        super.init()
    }

    func start() -> Int64 {
        if textureId >= 0 { return textureId }
        guard let mapView, let mtk = Self.findMTKView(in: mapView) else { return -1 }
        mtkView = mtk
        mtk.framebufferOnly = false
        queue = mtk.device?.makeCommandQueue()
        guard let layer = mtk.layer as? CAMetalLayer else { return -1 }
        Self.registry.setObject(self, forKey: layer)
        Self.hookPresentIfNeeded(device: mtk.device)
        textureId = textures.register(self)
        return textureId
    }

    func stop() {
        if let layer = mtkView?.layer as? CAMetalLayer {
            Self.registry.removeObject(forKey: layer)
        }
        if textureId >= 0 { textures.unregisterTexture(textureId) }
        textureId = -1
        ring.removeAll()
        latest = nil
    }

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        lock.lock()
        defer { lock.unlock() }
        guard let latest else { return nil }
        return Unmanaged.passRetained(latest)
    }

    // MARK: - Frame capture

    /// Frames are caught at `-[MTLCommandBuffer presentDrawable:]`.
    ///
    /// `UIView.draw(_:)` is the obvious hook and it never runs: an MTKView
    /// renders through Metal, not Core Graphics, so the method is simply not
    /// called. Every frame does pass through presentDrawable, and hooking
    /// there also means the copy can be encoded onto the SAME command buffer
    /// that presents it, so the blit is ordered after the render with no
    /// waiting and no guessing.
    private static func hookPresentIfNeeded(device: MTLDevice?) {
        guard !presentHooked, let device,
              let queue = device.makeCommandQueue(),
              let probe = queue.makeCommandBuffer() else { return }
        presentHooked = true
        let cls: AnyClass = type(of: probe)
        let sel = NSSelectorFromString("presentDrawable:")
        guard let method = class_getInstanceMethod(cls, sel) else { return }
        typealias PresentIMP = @convention(c) (AnyObject, Selector, AnyObject) -> Void
        let original = unsafeBitCast(method_getImplementation(method), to: PresentIMP.self)
        let block: @convention(block) (AnyObject, AnyObject) -> Void = { buffer, drawable in
            if let metalDrawable = drawable as? CAMetalDrawable,
               let publisher = MapTexturePublisher.registry.object(forKey: metalDrawable.layer),
               let commandBuffer = buffer as? MTLCommandBuffer {
                publisher.encodeCopy(of: metalDrawable.texture, on: commandBuffer)
            }
            original(buffer, sel, drawable)
        }
        method_setImplementation(method, imp_implementationWithBlock(block))
    }

    private func encodeCopy(of source: MTLTexture, on commandBuffer: MTLCommandBuffer) {
        guard textureId >= 0, !source.isFramebufferOnly else { return }
        guard source.pixelFormat == .bgra8Unorm
                || source.pixelFormat == .bgra8Unorm_srgb else { return }
        guard let device = mtkView?.device,
              let entry = nextEntry(width: source.width, height: source.height,
                                    format: source.pixelFormat, device: device),
              let blit = commandBuffer.makeBlitCommandEncoder() else { return }
        blit.copy(from: source, sourceSlice: 0, sourceLevel: 0,
                  sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                  sourceSize: MTLSize(width: source.width,
                                      height: source.height, depth: 1),
                  to: entry.texture, destinationSlice: 0, destinationLevel: 0,
                  destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
        blit.endEncoding()
        commandBuffer.addCompletedHandler { [weak self] _ in
            guard let self, self.textureId >= 0 else { return }
            self.lock.lock()
            self.latest = entry.buffer
            self.lock.unlock()
            self.textures.textureFrameAvailable(self.textureId)
        }
    }

    // MARK: - Buffers

    /// Three buffers, so the one flutter is reading is never the one being
    /// written. Fewer and the texture tears under a fast camera.
    private func nextEntry(width: Int, height: Int, format: MTLPixelFormat,
                           device: MTLDevice) -> Entry? {
        if width != ringWidth || height != ringHeight {
            ring.removeAll()
            ringWidth = width
            ringHeight = height
        }
        if ring.count < 3 {
            guard let entry = makeEntry(width: width, height: height,
                                        format: format, device: device) else { return nil }
            ring.append(entry)
            return entry
        }
        ringIndex = (ringIndex + 1) % ring.count
        let candidate = ring[ringIndex]
        lock.lock()
        let inUse = candidate.buffer === latest
        lock.unlock()
        if inUse {
            ringIndex = (ringIndex + 1) % ring.count
            return ring[ringIndex]
        }
        return candidate
    }

    private func makeEntry(width: Int, height: Int, format: MTLPixelFormat,
                           device: MTLDevice) -> Entry? {
        if textureCache == nil {
            CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
        }
        guard let cache = textureCache else { return nil }
        let attributes: [CFString: Any] = [
            kCVPixelBufferMetalCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
        ]
        var pixelBuffer: CVPixelBuffer?
        guard CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                  kCVPixelFormatType_32BGRA,
                                  attributes as CFDictionary,
                                  &pixelBuffer) == kCVReturnSuccess,
              let buffer = pixelBuffer else { return nil }
        var metalTexture: CVMetalTexture?
        guard CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault, cache, buffer, nil, format,
            width, height, 0, &metalTexture) == kCVReturnSuccess,
              let cvTexture = metalTexture,
              let texture = CVMetalTextureGetTexture(cvTexture) else { return nil }
        return Entry(buffer: buffer, cvTexture: cvTexture, texture: texture)
    }

    private static func findMTKView(in view: UIView) -> MTKView? {
        if let mtk = view as? MTKView { return mtk }
        for subview in view.subviews {
            if let found = findMTKView(in: subview) { return found }
        }
        return nil
    }
}
