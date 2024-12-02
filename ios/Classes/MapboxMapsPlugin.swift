import Flutter
import UIKit
import MapboxMaps
import MapboxCoreMaps_Private
import Metal
import MetalKit
import CoreVideo

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    private static var textureMethodChannel: FlutterMethodChannel!
    private static var textureController: TextureController!

    public static func register(with registrar: FlutterPluginRegistrar) {

        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        setupStaticChannels(with: registrar)
    }

    private static func setupStaticChannels(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()

        textureMethodChannel = FlutterMethodChannel(name: "mapbox_maps/texture", binaryMessenger: binaryMessenger)
        textureMethodChannel.setMethodCallHandler { call, result in
            if call.method == "getTextureId" {
                let args = call.arguments as! [String: CGFloat]
                textureController = TextureController(
                    textureRegistry: registrar.textures(),
                    textureSize: CGSize(width: args["width"]!, height: args["height"]!)
                )
                result(textureController.textureId)
            }
        }

        let mapboxOptionsController = MapboxOptionsController(assetKeyLookup: registrar.lookupKey(forAsset:))
        let snapshotterInstanceManager = SnapshotterInstanceManager(binaryMessenger: binaryMessenger)
        let offlineMapInstanceManager = OfflineMapInstanceManager(binaryMessenger: binaryMessenger)

        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _SnapshotterInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: snapshotterInstanceManager)
        _OfflineMapInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _TileStoreInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _OfflineSwitchSetup.setUp(binaryMessenger: binaryMessenger, api: OfflineSwitch.shared)

        LoggingController.setup(binaryMessenger)
    }
}

final class TextureController {
    private let textureRegistry: FlutterTextureRegistry
    private let texture: MapTexture
    let textureId: Int64

    init(textureRegistry: FlutterTextureRegistry, textureSize: CGSize) {
        self.textureRegistry = textureRegistry
        self.texture = MapTexture(textureRegistry: textureRegistry, size: textureSize)

        let textureId = textureRegistry.register(texture)
        self.textureId = textureId
        texture.textureId = textureId
    }
}

final class MapTexture: NSObject, FlutterTexture {
    private let textureRegistry: FlutterTextureRegistry
    private var map: MapboxCoreMaps_Private.Map!
    private let device = MTLCreateSystemDefaultDevice()!
    private let size: CGSize
    private var needsRepaint = false
    private var iosSufraceRef: IOSurfaceRef?
    private var buffer: Unmanaged<CVPixelBuffer>?
    private var textureCache: CVMetalTextureCache?
    private var texture: MTLTexture?
    private var cvTexture: CVMetalTexture?
    var textureId: Int64!
    var thread: Thread?
    var needsRepaintUpdateQueue = DispatchQueue(
        label: "needsRepaintUpdateQueue",
        qos: .userInitiated
    )
    init(textureRegistry: FlutterTextureRegistry, size: CGSize) {
        self.size = size
        self.textureRegistry = textureRegistry
        super.init()
        setupMap()
        thread = Thread.init(target: self, selector: #selector(setupRendering), object: nil)
        thread?.start()
    }

    private func setupMap() {
        let clientProxy = MapClientProxy()
        self.map = Map(
            client: clientProxy,
            mapOptions: .init(size: size)
        )

        clientProxy.repaintClosure = { [unowned self] in
            self.needsRepaintUpdateQueue.sync {
                self.needsRepaint = true
            }
        }
        clientProxy.drawableProvider = { [unowned self] in
            return self.texture
        }

        map.setStyleURIForUri(StyleURI.standard.rawValue)
        let helsinki = CLLocationCoordinate2D(latitude: 60.170119, longitude: 24.938333)
        map.setCameraFor(
            MapboxCoreMaps_Private.CameraOptions(
                __center: .init(value: helsinki),
                padding: nil,
                anchor: nil,
                zoom: 3,
                bearing: 0,
                pitch: 0
            )
        )
    }

    @objc func setupRendering() {
        setupTextureBuffer()
        map.createRenderer()

        let link = CADisplayLink(target: self, selector: #selector(update))

        link.add(to: .current, forMode: .default)

        RunLoop.current.run()
    }
    private var renderFrameFinishedEventCancellable: MapboxCommon.Cancelable?
    private var isRendering = false

    @objc private func update(_ displayLink: CADisplayLink) {
        let needsRepaint = needsRepaintUpdateQueue.sync {
            return self.needsRepaint
        }

        guard needsRepaint else { return }
        print("\(Thread.current) pre render")

        needsRepaintUpdateQueue.sync {
            self.needsRepaint = false
        }
        map.render()
        print("\(Thread.current) post render")
        self.textureRegistry.textureFrameAvailable(self.textureId)
    }

    func setupTextureBuffer() {

        guard let ioSurfaceRef = IOSurfaceCreate(
            [
                kIOSurfaceWidth: size.width,
                kIOSurfaceHeight: size.height,
                kIOSurfaceBytesPerElement: 4,
                kIOSurfacePixelFormat: kCVPixelFormatType_32BGRA
            ] as CFDictionary
        ) else {
            fatalError()
        }

        guard CVPixelBufferCreateWithIOSurface(
            kCFAllocatorDefault,
            ioSurfaceRef,
            [kCVPixelBufferMetalCompatibilityKey: true] as CFDictionary,
            &buffer
        ) == kCVReturnSuccess else {
            fatalError()
        }

        guard CVMetalTextureCacheCreate(
            kCFAllocatorDefault,
            nil,
            device,
            nil,
            &textureCache
        ) == kCVReturnSuccess else {
            fatalError()
        }

        guard CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            textureCache!,
            buffer!.takeUnretainedValue(),
            nil,
            .bgra8Unorm,
            Int(size.width),
            Int(size.height),
            0,
            &cvTexture
        ) == kCVReturnSuccess else {
            fatalError()
        }

        texture = CVMetalTextureGetTexture(cvTexture!)
    }

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        print("MapTexture: copyPixelBuffer")
        guard let pixelBuffer = buffer?.takeUnretainedValue() else {
            return nil
        }

        return Unmanaged.passRetained(pixelBuffer)
    }
}

final class MapClientProxy: MapClient, MBMMetalViewProvider {
    var repaintClosure: () -> Void = {}
    var drawableProvider: (() -> (any MTLTexture)?)?

    func scheduleRepaint() {
        print("\(Thread.current) scheduleRepaint")
        repaintClosure()
    }

    func getDrawableTexture() -> (any MTLTexture)? {
        print("getDrawableTexture")
        return drawableProvider?()
    }
}
