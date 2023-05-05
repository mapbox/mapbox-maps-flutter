import Flutter
import MapboxMaps
import UIKit

class EventsObserver: Observer {
    var notificationHandler: (MapboxCoreMaps.Event) -> Void

    init(with notificationHandler: @escaping (MapboxCoreMaps.Event) -> Void) {
        self.notificationHandler = notificationHandler
    }

    func notify(for event: MapboxCoreMaps.Event) {
        notificationHandler(event)
    }
}

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

    func view() -> UIView {
        return mapView
    }

    init(
        withFrame frame: CGRect,
        mapInitOptions: MapInitOptions,
        channelSuffix: Int,
        eventTypes: [String],
        arguments args: Any?,
        registrar: FlutterPluginRegistrar,
        pluginVersion: String
    ) {
        self.proxyBinaryMessenger = ProxyBinaryMessenger(with: registrar.messenger(), channelSuffix: "/map_\(channelSuffix)")

        HttpServiceFactory.getInstance().setInterceptorForInterceptor(HttpUseragentInterceptor(pluginVersion: pluginVersion))

        mapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        mapboxMap = mapView.mapboxMap

        self.registrar = registrar

        channel = FlutterMethodChannel(
            name: "plugins.flutter.io",
            binaryMessenger: proxyBinaryMessenger
        )

        super.init()

        channel.setMethodCallHandler { [weak self] in self?.onMethodCall(methodCall: $0, result: $1) }

        let styleController = StyleController(withMapboxMap: mapboxMap)
        FLTStyleManagerSetup(proxyBinaryMessenger, styleController)

        let cameraController = CameraController(withMapboxMap: mapboxMap)
        FLT_CameraManagerSetup(proxyBinaryMessenger, cameraController)

        let mapInterfaceController = MapInterfaceController(withMapboxMap: mapboxMap)
        FLT_MapInterfaceSetup(proxyBinaryMessenger, mapInterfaceController)

        let mapProjectionController = MapProjectionController()
        FLTProjectionSetup(proxyBinaryMessenger, mapProjectionController)

        let animationController = AnimationController(withMapView: mapView)
        FLT_AnimationManagerSetup(proxyBinaryMessenger, animationController)

        let locationController = LocationController(withMapView: mapView)
        FLT_SETTINGSLocationComponentSettingsInterfaceSetup(proxyBinaryMessenger, locationController)

        gesturesController = GesturesController(withMapView: mapView)
        FLT_SETTINGSGesturesSettingsInterfaceSetup(proxyBinaryMessenger, gesturesController)

        let logoController = LogoController(withMapView: mapView)
        FLT_SETTINGSLogoSettingsInterfaceSetup(proxyBinaryMessenger, logoController)

        let attributionController = AttributionController(withMapView: mapView)
        FLT_SETTINGSAttributionSettingsInterfaceSetup(proxyBinaryMessenger, attributionController)

        let compassController = CompassController(withMapView: mapView)
        FLT_SETTINGSCompassSettingsInterfaceSetup(proxyBinaryMessenger, compassController)

        let scaleBarController = ScaleBarController(withMapView: mapView)
        FLT_SETTINGSScaleBarSettingsInterfaceSetup(proxyBinaryMessenger, scaleBarController)

        annotationController = AnnotationController(withMapView: mapView)
        annotationController!.setup(messenger: proxyBinaryMessenger)

        let observer = EventsObserver(with: { [weak self] (resourceEvent) in
            guard let self = self else {
                return
            }
            guard let eventData = resourceEvent.data as? [String: Any] else {
                return
            }

            self.channel.invokeMethod(self.getEventMethodName(eventType: resourceEvent.type),
                                      arguments: self.convertDictionaryToString(dict: eventData))
        })
        mapboxMap.subscribe(observer, events: eventTypes)
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "map#subscribe":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let eventType = arguments["event"] as? String else { return }
            mapboxMap.onEvery(MapEvents.EventKind(rawValue: eventType)!) { (event) in
                guard let data = event.data as? [String: Any] else {return}
                self.channel.invokeMethod(self.getEventMethodName(eventType: eventType),
                                          arguments: self.convertDictionaryToString(dict: data))
            }
            result(nil)
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

    private func getEventMethodName(eventType: String) -> String {
        return "event#\(eventType)"
    }

    private func convertDictionaryToString(dict: [String: Any]) -> String {
        var result: String = ""
        do {
            let jsonData =
            try JSONSerialization.data(
                withJSONObject: dict,
                options: JSONSerialization.WritingOptions.init(rawValue: 0)
            )

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = ""
        }
        return result
    }

    final class HttpUseragentInterceptor: HttpServiceInterceptorInterface {

        private var pluginVersion: String

        init(pluginVersion: String) {
            self.pluginVersion = pluginVersion
        }

        func onRequest(for request: HttpRequest) -> HttpRequest {
            if let oldUseragent = request.headers[HttpHeaders.userAgent] {
                request.headers[HttpHeaders.userAgent] = "\(oldUseragent) FlutterPlugin/\(self.pluginVersion)"
            }

            return request
        }

        func onDownload(forDownload download: DownloadOptions) -> DownloadOptions {
            return download
        }

        func onResponse(for response: HttpResponse) -> HttpResponse {
            return response
        }
    }
}
