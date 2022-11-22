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

class MapboxMapController: NSObject, FlutterPlatformView {
    private var registrar: FlutterPluginRegistrar
    private var mapView: MapView
    private var mapboxMap: MapboxMap
    private var channel: FlutterMethodChannel
    private var annotationController: AnnotationController?

    func view() -> UIView {
        return mapView
    }

    init(
        withFrame frame: CGRect,
        mapInitOptions: MapInitOptions,
        viewIdentifier viewId: Int64,
        eventTypes: [String],
        arguments args: Any?,
        registrar: FlutterPluginRegistrar,
        pluginVersion: String
    ) {
        HttpServiceFactory.getInstance().setInterceptorForInterceptor(HttpUseragentInterceptor(pluginVersion: pluginVersion))

        mapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        mapboxMap = mapView.mapboxMap
        self.registrar = registrar
        channel = FlutterMethodChannel(
            name: "plugins.flutter.io/mapbox_maps_\(viewId)",
            binaryMessenger: registrar.messenger()
        )
        super.init()
        channel.setMethodCallHandler { [weak self] in self?.onMethodCall(methodCall: $0, result: $1) }

        let styleController = StyleController(withMapboxMap: mapboxMap)
        FLTStyleManagerSetup(registrar.messenger(), styleController)

        let cameraController = CameraController(withMapboxMap: mapboxMap)
        FLT_CameraManagerSetup(registrar.messenger(), cameraController)

        let mapInterfaceController = MapInterfaceController(withMapboxMap: mapboxMap)
        FLT_MapInterfaceSetup(registrar.messenger(), mapInterfaceController)

        let mapProjectionController = MapProjectionController()
        FLTProjectionSetup(registrar.messenger(), mapProjectionController)

        let animationController = AnimationController(withMapView: mapView)
        FLT_AnimationManagerSetup(registrar.messenger(), animationController)

        let locationController = LocationController(withMapView: mapView)
        FLT_SETTINGSLocationComponentSettingsInterfaceSetup(registrar.messenger(), locationController)

        let gesturesController = GesturesController(withMapView: mapView)
        FLT_SETTINGSGesturesSettingsInterfaceSetup(registrar.messenger(), gesturesController)
        gesturesController.setup(messenger: registrar.messenger())

        let logoController = LogoController(withMapView: mapView)
        FLT_SETTINGSLogoSettingsInterfaceSetup(registrar.messenger(), logoController)

        annotationController = AnnotationController(withMapView: mapView)
        annotationController!.setup(messenger: registrar.messenger())

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
        case "annotation#create_manager":
            annotationController!.handleCreateManager(methodCall: methodCall, result: result)
        case "annotation#remove_manager":
            annotationController!.handleRemoveManager(methodCall: methodCall, result: result)
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
