import Flutter
@_spi(Experimental) import MapboxMaps
import UIKit

class ProxyBinaryMessenger: NSObject, FlutterBinaryMessenger {

    let channelSuffix: String
    let messenger: FlutterBinaryMessenger

    init(with messenger: FlutterBinaryMessenger, channelSuffix: String) {
        self.messenger = messenger
        self.channelSuffix = channelSuffix
    }

    func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {
        messenger.send(onChannel: "\(channel)\(channelSuffix)", message: message, binaryReply: callback)
    }

    func send(onChannel channel: String, message: Data?) {
        messenger.send(onChannel: "\(channel)\(channelSuffix)", message: message)
    }

    func setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil) -> FlutterBinaryMessengerConnection {
        messenger.setMessageHandlerOnChannel("\(channel)\(channelSuffix)", binaryMessageHandler: handler)
    }

    func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {
        messenger.cleanUpConnection(connection)
    }
}

final class MapboxMapController: NSObject, FlutterPlatformView {
    private let registrar: FlutterPluginRegistrar
    private let mapView: MapView
    private let mapboxMap: MapboxMap
    private let channel: FlutterMethodChannel
    private let annotationController: AnnotationController?
    private let gesturesController: GesturesController?
    private let proxyBinaryMessenger: ProxyBinaryMessenger
    private let eventHandler: MapboxEventHandler

    func view() -> UIView {
        return mapView
    }

    init(
        withFrame frame: CGRect,
        mapInitOptions: MapInitOptions,
        channelSuffix: Int,
        arguments args: Any?,
        registrar: FlutterPluginRegistrar,
        pluginVersion: String,
        eventTypes: [Int]
    ) {
        self.proxyBinaryMessenger = ProxyBinaryMessenger(with: registrar.messenger(), channelSuffix: "\(channelSuffix)")
        _ = SettingsServiceFactory.getInstanceFor(.nonPersistent)
            .set(key: "com.mapbox.common.telemetry.internal.custom_user_agent_fragment", value: "FlutterPlugin/\(pluginVersion)")

        mapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        mapView.debugOptions = [.camera]
        mapboxMap = mapView.mapboxMap

        self.registrar = registrar

        channel = FlutterMethodChannel(
            name: "plugins.flutter.io",
            binaryMessenger: proxyBinaryMessenger
        )
        self.eventHandler = MapboxEventHandler(
            eventProvider: mapboxMap,
            binaryMessenger: proxyBinaryMessenger,
            eventTypes: eventTypes
        )

        let styleController = StyleController(styleManager: mapboxMap)
        StyleManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: styleController)

        let cameraController = CameraController(withMapboxMap: mapboxMap)
        _CameraManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: cameraController)

        let mapInterfaceController = MapInterfaceController(withMapboxMap: mapboxMap)
        _MapInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: mapInterfaceController)

        let mapProjectionController = MapProjectionController()
        ProjectionSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: mapProjectionController)

        let animationController = AnimationController(withMapView: mapView)
        _AnimationManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: animationController)

        let locationController = LocationController(withMapView: mapView)
        _LocationComponentSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: locationController)

        gesturesController = GesturesController(withMapView: mapView)
        GesturesSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: gesturesController)

        let logoController = LogoController(withMapView: mapView)
        LogoSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: logoController)

        let attributionController = AttributionController(withMapView: mapView)
        AttributionSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: attributionController)

        let compassController = CompassController(withMapView: mapView)
        CompassSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: compassController)

        let scaleBarController = ScaleBarController(withMapView: mapView)
        ScaleBarSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: scaleBarController)

        annotationController = AnnotationController(withMapView: mapView)
        annotationController!.setup(messenger: proxyBinaryMessenger)

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
            gesturesController!.addListeners(messenger: proxyBinaryMessenger)
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func releaseMethodChannels() {
        channel.setMethodCallHandler(nil)
        StyleManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        _CameraManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        _MapInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        ProjectionSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        _AnimationManagerSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        _LocationComponentSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        GesturesSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        LogoSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        AttributionSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        CompassSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        ScaleBarSettingsInterfaceSetup.setUp(binaryMessenger: proxyBinaryMessenger, api: nil)
        annotationController?.tearDown(messenger: proxyBinaryMessenger)
    }
}
