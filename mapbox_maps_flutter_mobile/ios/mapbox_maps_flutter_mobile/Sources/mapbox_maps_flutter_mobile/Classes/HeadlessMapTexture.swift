import Flutter
import MapboxMaps
import MetalKit
import UIKit

/// A map that is not a platform view.
///
/// The plugin's only way to show a map on ios is `MapboxMapController`, a
/// `FlutterPlatformView`. UIKit composites that view, not flutter, so nothing
/// drawn above it can read it: backdrop filters, shaders and captures all come
/// back empty. Android does not have this problem because it can render the
/// map into a `TextureView`.
///
/// This is that mode for ios. The same `MapboxMapController` is built, so every
/// pigeon api the normal map exposes is available on the same channel suffix,
/// but its view is parked offscreen and its frames go to
/// `FlutterTextureRegistry`. The widget tree gets a `Texture` and no platform
/// view at all.
final class HeadlessMapTexture: NSObject {
    private static var instances: [Int64: HeadlessMapTexture] = [:]

    private let host: UIView
    private let controller: MapboxMapController
    private let publisher: MapTexturePublisher
    private let textureId: Int64

    private init?(size: CGSize,
                  channelSuffix: Int,
                  options: MapInitOptions,
                  registrar: FlutterPluginRegistrar) {
        let frame = CGRect(origin: .zero, size: size)

        // The real controller, so style, camera, annotations, gestures and
        // every other pigeon api work exactly as they do for the platform
        // view. Only where its view lives is different.
        controller = MapboxMapController(
            withFrame: frame,
            mapInitOptions: options,
            channelSuffix: channelSuffix,
            registrar: registrar,
            pluginVersion: "",
            eventTypes: []
        )

        // Parked in the app's OWN key window, off to the side, rather than in
        // a window of our own. A second UIWindow steals the scene and the
        // flutter view goes to the background. Offscreen inside the existing
        // window keeps CoreAnimation compositing the layer, which is what
        // keeps the drawable pool recycling.
        guard let key = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return nil }
        host = UIView(frame: CGRect(x: -size.width * 4, y: 0,
                                    width: size.width, height: size.height))
        host.isUserInteractionEnabled = false
        host.addSubview(controller.view())
        key.addSubview(host)

        publisher = MapTexturePublisher(mapView: controller.view(),
                                        textures: registrar.textures())
        let id = publisher.start()
        guard id >= 0 else { return nil }
        textureId = id
        super.init()
    }

    static func create(size: CGSize,
                       channelSuffix: Int,
                       options: MapInitOptions,
                       registrar: FlutterPluginRegistrar) -> Int64 {
        guard let instance = HeadlessMapTexture(size: size,
                                                channelSuffix: channelSuffix,
                                                options: options,
                                                registrar: registrar) else {
            return -1
        }
        instances[instance.textureId] = instance
        return instance.textureId
    }

    static func dispose(textureId: Int64) {
        instances[textureId]?.publisher.stop()
        instances[textureId]?.host.removeFromSuperview()
        instances[textureId] = nil
    }

    /// The logo and attribution are UIKit subviews of the MapView, drawn with
    /// Core Graphics, so they are not in the Metal drawable and do not reach
    /// the texture. Mapbox's terms require them, so they are rasterised here
    /// and drawn by flutter over the texture at the same position.
    ///
    /// Returns a transparent image the size of the map with only the ornaments
    /// in it, so the caller can overlay it without covering the map.
    static func ornaments(textureId: Int64) -> FlutterStandardTypedData? {
        guard let instance = instances[textureId] else { return nil }
        let view = instance.controller.view()
        let ornaments = view.subviews.filter { !($0 is MTKView) && !$0.isHidden }
        guard !ornaments.isEmpty else { return nil }

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds, format: format)
        let image = renderer.image { _ in
            for ornament in ornaments {
                let frame = ornament.convert(ornament.bounds, to: view)
                ornament.drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        }
        guard let png = image.pngData() else { return nil }
        return FlutterStandardTypedData(bytes: png)
    }

    /// The map only draws on demand, so a still map stops vending frames.
    static func pump(textureId: Int64) {
        instances[textureId]?.controller.map.triggerRepaint()
    }

    /// Rotation, split view, a keyboard appearing: the texture has to follow
    /// the widget or the map renders at one size and is sampled at another.
    static func resize(textureId: Int64, size: CGSize) {
        guard let instance = instances[textureId] else { return }
        guard size.width > 0, size.height > 0 else { return }
        instance.host.frame = CGRect(x: -size.width * 4, y: 0,
                                     width: size.width, height: size.height)
        instance.controller.view().frame = CGRect(origin: .zero, size: size)
        instance.controller.view().layoutIfNeeded()
        instance.controller.map.triggerRepaint()
    }

    // MARK: - Gestures
    //
    // The map's view is offscreen, so UIKit will never deliver touches to it
    // and its own recognisers can never fire. Flutter owns the hit test now,
    // so it forwards the points and the camera is driven directly. Same maths
    // the sdk's own pan recogniser uses, via dragCameraOptions.

    private var lastDrag: CGPoint?

    static func panBegin(textureId: Int64, at point: CGPoint) {
        instances[textureId]?.lastDrag = point
    }

    static func panUpdate(textureId: Int64, to point: CGPoint) {
        guard let instance = instances[textureId],
              let from = instance.lastDrag else { return }
        let map = instance.controller.map
        map.setCamera(to: map.dragCameraOptions(from: from, to: point))
        instance.lastDrag = point
    }

    static func panEnd(textureId: Int64) {
        instances[textureId]?.lastDrag = nil
    }

    /// Two finger twist. Bearing is degrees clockwise from north, the gesture
    /// gives radians, and a clockwise twist should turn the map the other way,
    /// hence the negation.
    static func rotateBy(textureId: Int64, radians: Double, at point: CGPoint) {
        guard let instance = instances[textureId] else { return }
        let map = instance.controller.map
        map.setCamera(to: camera(map,
                                 anchor: point,
                                 bearing: map.cameraState.bearing - radians * 180 / .pi))
    }

    /// Two finger drag up tilts the camera over. Clamped to the sdk's own
    /// ceiling; past it the horizon enters the frame and the map is unusable.
    static func pitchBy(textureId: Int64, delta: Double) {
        guard let instance = instances[textureId] else { return }
        let map = instance.controller.map
        let pitch = max(0, min(85, map.cameraState.pitch + delta))
        map.setCamera(to: camera(map, pitch: pitch))
    }

    /// Every field, every time.
    ///
    /// `CameraOptions` is not a patch: a nil field is not "leave this alone",
    /// it is "no value", and the camera resolves it to a default. Setting only
    /// bearing therefore threw away the centre and the zoom and left a black
    /// map. Read the current state and change the one thing.
    ///
    /// MapboxMaps.CameraOptions, not the pigeon type of the same name that
    /// this module also declares. Unqualified it resolves to ours.
    private static func camera(_ map: MapboxMap,
                               anchor: CGPoint? = nil,
                               zoom: CGFloat? = nil,
                               bearing: CLLocationDirection? = nil,
                               pitch: CGFloat? = nil) -> MapboxMaps.CameraOptions {
        let state = map.cameraState
        return MapboxMaps.CameraOptions(
            center: state.center,
            padding: state.padding,
            anchor: anchor,
            zoom: zoom ?? state.zoom,
            bearing: bearing ?? state.bearing,
            pitch: pitch ?? state.pitch
        )
    }

    static func zoomBy(textureId: Int64, delta: Double, at point: CGPoint) {
        guard let instance = instances[textureId] else { return }
        let map = instance.controller.map
        let zoom = max(0, min(22, map.cameraState.zoom + delta))
        map.setCamera(to: camera(map, anchor: point, zoom: zoom))
    }
}
