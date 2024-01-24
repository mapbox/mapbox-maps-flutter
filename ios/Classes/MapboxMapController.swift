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

    func view() -> UIView {
        return mapView
    }

    deinit {
        channel.setMethodCallHandler(nil)
        SetUpFLTStyleManager(proxyBinaryMessenger, nil)
        SetUpFLT_CameraManager(proxyBinaryMessenger, nil)
        SetUpFLT_MapInterface(proxyBinaryMessenger, nil)
        SetUpFLTProjection(proxyBinaryMessenger, nil)
        SetUpFLT_AnimationManager(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGS_LocationComponentSettingsInterface(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGSGesturesSettingsInterface(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGSLogoSettingsInterface(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGSAttributionSettingsInterface(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGSCompassSettingsInterface(proxyBinaryMessenger, nil)
        SetUpFLT_SETTINGSScaleBarSettingsInterface(proxyBinaryMessenger, nil)
        annotationController?.tearDown(messenger: proxyBinaryMessenger)
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

        for eventType in eventTypes.compactMap({ _MapEvent(rawValue: $0) }) {
            subscribeToEvent(eventType)
        }
    }

    private func subscribeToEvent(_ event: _MapEvent) {
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

private extension _MapEvent {
    var methodName: String { "event#\(rawValue)" }
}
