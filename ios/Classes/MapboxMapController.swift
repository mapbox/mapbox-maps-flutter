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

class MapboxMapController: NSObject, FlutterPlatformView {
    private var registrar: FlutterPluginRegistrar
    private var mapView: MapView
    private var mapboxMap: MapboxMap
    private var channel: FlutterMethodChannel
    private var annotationController: AnnotationController?
    private var gesturesController: GesturesController?
    private var proxyBinaryMessenger: ProxyBinaryMessenger
    private var cancelables = Set<AnyCancelable>()
    private var snapshotController: SnapshotController?

    func view() -> UIView {
        return mapView
    }

    init(
        withFrame frame: CGRect,
        mapInitOptions: MapInitOptions,
        channelSuffix: Int,
        eventTypes: [Int],
        arguments args: Any?,
        registrar: FlutterPluginRegistrar,
        pluginVersion: String
    ) {
        self.proxyBinaryMessenger = ProxyBinaryMessenger(with: registrar.messenger(), channelSuffix: "/map_\(channelSuffix)")

        HttpServiceFactory.setHttpServiceInterceptorForInterceptor(HttpUseragentInterceptor(pluginVersion: pluginVersion))

        mapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        mapboxMap = mapView.mapboxMap

        self.registrar = registrar

        channel = FlutterMethodChannel(
            name: "plugins.flutter.io",
            binaryMessenger: proxyBinaryMessenger
        )

        super.init()

        channel.setMethodCallHandler { [weak self] in self?.onMethodCall(methodCall: $0, result: $1) }

        let styleController = StyleController(styleManager: mapboxMap)
        SetUpFLTStyleManager(proxyBinaryMessenger, styleController)

        let cameraController = CameraController(withMapboxMap: mapboxMap)
        SetUpFLT_CameraManager(proxyBinaryMessenger, cameraController)

        let mapInterfaceController = MapInterfaceController(withMapboxMap: mapboxMap)
        SetUpFLT_MapInterface(proxyBinaryMessenger, mapInterfaceController)

        let mapProjectionController = MapProjectionController()
        SetUpFLTProjection(proxyBinaryMessenger, mapProjectionController)

        let animationController = AnimationController(withMapView: mapView)
        SetUpFLT_AnimationManager(proxyBinaryMessenger, animationController)

        let locationController = LocationController(withMapView: mapView)
        SetUpFLT_SETTINGS_LocationComponentSettingsInterface(proxyBinaryMessenger, locationController)

        gesturesController = GesturesController(withMapView: mapView)
        SetUpFLT_SETTINGSGesturesSettingsInterface(proxyBinaryMessenger, gesturesController)

        let logoController = LogoController(withMapView: mapView)
        SetUpFLT_SETTINGSLogoSettingsInterface(proxyBinaryMessenger, logoController)

        let attributionController = AttributionController(withMapView: mapView)
        SetUpFLT_SETTINGSAttributionSettingsInterface(proxyBinaryMessenger, attributionController)

        let compassController = CompassController(withMapView: mapView)
        SetUpFLT_SETTINGSCompassSettingsInterface(proxyBinaryMessenger, compassController)

        let scaleBarController = ScaleBarController(withMapView: mapView)
        SetUpFLT_SETTINGSScaleBarSettingsInterface(proxyBinaryMessenger, scaleBarController)

        annotationController = AnnotationController(withMapView: mapView)
        annotationController!.setup(messenger: proxyBinaryMessenger)
        
        snapshotController = SnapshotController(mapView: mapView)
        snapshotController!.setup(messager: proxyBinaryMessenger)

        for eventType in eventTypes.compactMap({ FLT_MapEvent(rawValue: UInt($0)) }) {
            subscribeToEvent(eventType)
        }
    }

    private func subscribeToEvent(_ event: FLT_MapEvent) {
        switch event {
        case .mapLoaded:
            mapboxMap.onMapLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .mapLoadingError:
            mapboxMap.onMapLoadingError.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleLoaded:
            mapboxMap.onStyleLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleDataLoaded:
            mapboxMap.onStyleDataLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .cameraChanged:
            mapboxMap.onCameraChanged.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .mapIdle:
            mapboxMap.onMapIdle.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceAdded:
            mapboxMap.onSourceAdded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceRemoved:
            mapboxMap.onSourceRemoved.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceDataLoaded:
            mapboxMap.onSourceDataLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleImageMissing:
            mapboxMap.onStyleImageMissing.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleImageRemoveUnused:
            mapboxMap.onStyleImageRemoveUnused.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .renderFrameStarted:
            mapboxMap.onRenderFrameStarted.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .renderFrameFinished:
            mapboxMap.onRenderFrameFinished.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .resourceRequest:
            mapboxMap.onResourceRequest.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        @unknown default:
            fatalError("Event \(event) is not supported.")
        }
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    final class HttpUseragentInterceptor: HttpServiceInterceptorInterface {

        private var pluginVersion: String

        init(pluginVersion: String) {
            self.pluginVersion = pluginVersion
        }

        func onRequest(for request: HttpRequest, continuation: @escaping HttpServiceInterceptorRequestContinuation) {
            if let oldUseragent = request.headers["userAgent"] {
                request.headers["userAgent"] = "\(oldUseragent) FlutterPlugin/\(self.pluginVersion)"
            }

            continuation(.fromHttpRequest(request))
        }

        func onResponse(for response: HttpResponse, continuation: @escaping HttpServiceInterceptorResponseContinuation) {
            continuation(response)
        }
    }
}

private extension FLT_MapEvent {
    var methodName: String { "event#\(rawValue)" }
}
