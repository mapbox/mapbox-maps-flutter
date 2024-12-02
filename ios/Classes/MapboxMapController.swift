import Flutter
@_spi(Experimental) import MapboxMaps
import UIKit

struct SuffixBinaryMessenger {
    let messenger: FlutterBinaryMessenger
    let suffix: String
}

final class MapboxMapController: NSObject, FlutterPlatformView {
    private let mapView: MapView
    private let mapboxMap: MapboxMap
    private let channel: FlutterMethodChannel
    private let annotationController: AnnotationController?
    private let gesturesController: GesturesController?
    private let eventHandler: MapboxEventHandler
    private let binaryMessenger: SuffixBinaryMessenger

    func view() -> UIView {
        return mapView
    }

    init(
        withFrame frame: CGRect,
        mapInitOptions: MapInitOptions,
        channelSuffix: Int,
        registrar: FlutterPluginRegistrar,
        pluginVersion: String,
        eventTypes: [Int]
    ) {
        binaryMessenger = SuffixBinaryMessenger(messenger: registrar.messenger(), suffix: String(channelSuffix))
        _ = SettingsServiceFactory.getInstanceFor(.nonPersistent)
            .set(key: "com.mapbox.common.telemetry.internal.custom_user_agent_fragment", value: "FlutterPlugin/\(pluginVersion)")

        mapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        mapboxMap = mapView.mapboxMap

        channel = FlutterMethodChannel(
            name: "plugins.flutter.io.\(channelSuffix)",
            binaryMessenger: binaryMessenger.messenger
        )
        self.eventHandler = MapboxEventHandler(
            eventProvider: mapboxMap,
            binaryMessenger: binaryMessenger.messenger,
            eventTypes: eventTypes,
            channelSuffix: String(channelSuffix)
        )

        let styleController = StyleController(styleManager: mapboxMap)
        StyleManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: styleController, messageChannelSuffix: binaryMessenger.suffix)

        let cameraController = CameraController(withMapboxMap: mapboxMap)
        _CameraManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: cameraController, messageChannelSuffix: binaryMessenger.suffix)

        let mapInterfaceController = MapInterfaceController(withMapboxMap: mapboxMap, mapView: mapView)
        _MapInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: mapInterfaceController, messageChannelSuffix: binaryMessenger.suffix)

        let mapProjectionController = MapProjectionController()
        ProjectionSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: mapProjectionController, messageChannelSuffix: binaryMessenger.suffix)

        let animationController = AnimationController(withMapView: mapView)
        _AnimationManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: animationController, messageChannelSuffix: binaryMessenger.suffix)

        let locationController = LocationController(withMapView: mapView)
        _LocationComponentSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: locationController, messageChannelSuffix: binaryMessenger.suffix)

        gesturesController = GesturesController(withMapView: mapView)
        GesturesSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: gesturesController, messageChannelSuffix: binaryMessenger.suffix)

        let logoController = LogoController(withMapView: mapView)
        LogoSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: logoController, messageChannelSuffix: binaryMessenger.suffix)

        let attributionController = AttributionController(withMapView: mapView)
        AttributionSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: attributionController, messageChannelSuffix: binaryMessenger.suffix)

        let compassController = CompassController(withMapView: mapView)
        CompassSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: compassController, messageChannelSuffix: binaryMessenger.suffix)

        let scaleBarController = ScaleBarController(withMapView: mapView)
        ScaleBarSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: scaleBarController, messageChannelSuffix: binaryMessenger.suffix)

        annotationController = AnnotationController(withMapView: mapView)
        annotationController!.setup(binaryMessenger: binaryMessenger)

        let viewportController = ViewportController(
            viewportManager: mapView.viewport,
            cameraManager: mapView.camera,
            mapboxMap: mapboxMap
        )
        _ViewportMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: viewportController, messageChannelSuffix: binaryMessenger.suffix)

        super.init()

        channel.setMethodCallHandler { [weak self] in self?.onMethodCall(methodCall: $0, result: $1) }
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "annotation#create_manager":
            annotationController!.handleCreateManager(methodCall: methodCall, result: result)
        case "annotation#remove_manager":
            annotationController!.handleRemoveManager(methodCall: methodCall, result: result)
        case "gesture#add_listeners":
            gesturesController!.addListeners(messenger: binaryMessenger)
            result(nil)
        case "gesture#remove_listeners":
            gesturesController!.removeListeners()
            result(nil)
        case "platform#releaseMethodChannels":
            releaseMethodChannels()
            result(nil)
        case "map#snapshot":
            do {
                let snapshot = try mapView.snapshot()
                result(snapshot.pngData())
            } catch {
                result(FlutterError(code: "2342345", message: error.localizedDescription, details: nil))
            }
        case "mapView#submitViewSizeHint":
            if let arguments = methodCall.arguments as? [String: Double],
               let width = arguments["width"], let height = arguments["height"] {
                let size = CGSize(width: width, height: height)
                guard size != .zero else { return }

                // This is a bit of a hack to size the map view as early as possible,
                // Flutter is quite slow with it
                mapView.superview?.frame = CGRect(origin: .zero, size: size)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func releaseMethodChannels() {
        channel.setMethodCallHandler(nil)

        StyleManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _CameraManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _MapInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        ProjectionSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _AnimationManagerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _LocationComponentSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        GesturesSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        LogoSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        AttributionSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        CompassSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        ScaleBarSettingsInterfaceSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        annotationController?.tearDown(messenger: binaryMessenger)
        _ViewportMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
    }
}
