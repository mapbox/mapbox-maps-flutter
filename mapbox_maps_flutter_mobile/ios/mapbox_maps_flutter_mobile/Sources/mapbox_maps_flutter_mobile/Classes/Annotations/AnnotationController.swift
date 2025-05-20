import Foundation
import MapboxMaps
import Flutter

enum AnnotationControllerError: Error {
    case noManagerFound
    case noAnnotationFound
    case wrongManagerType
}

extension AnnotationController: AnnotationInteractionDelegate {
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        let annotation = annotations.first
        switch annotation {
        case let annotation as MapboxMaps.PointAnnotation:
            self.onPointAnnotationClickListener?.onPointAnnotationClick(
                annotation: annotation.toFLTPointAnnotation(),
                completion: {_ in }
            )
        case let annotation as MapboxMaps.CircleAnnotation:
            self.onCircleAnnotationClickListener?.onCircleAnnotationClick(
                annotation: annotation.toFLTCircleAnnotation(),
                completion: {_ in }
            )
        case let annotation as MapboxMaps.PolygonAnnotation:
            self.onPolygonAnnotationClickListener?.onPolygonAnnotationClick(
                annotation: annotation.toFLTPolygonAnnotation(),
                completion: {_ in }
            )
        case let annotation as MapboxMaps.PolylineAnnotation:
            self.onPolylineAnnotationClickListener?.onPolylineAnnotationClick(
                annotation: annotation.toFLTPolylineAnnotation(),
                completion: {_ in }
            )
        default:
            print("Can't detemine the type of annotation: \(String(describing: annotation))")
        }
    }
}

private class AnyAnnotationDragEventsStreamHandler: AnnotationDragEventsStreamHandler {
    private var sink: PigeonEventSink<AnnotationInteractionContext>?

    override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<AnnotationInteractionContext>) {
        self.sink = sink
    }

    override func onCancel(withArguments arguments: Any?) {
        sink = nil
    }

    func send(event: AnnotationInteractionContext) {
        sink?.success(event)
    }

    func send(error: FlutterError) {
        sink?.error(code: error.code, message: error.message, details: error.details)
    }

    func endOfStream() {
        sink?.endOfStream()
    }
}

class AnnotationController {
    private let mapView: MapView
    private let binaryMessenger: SuffixBinaryMessenger
    private var disposal: [String: (String) -> Void] = [:]

    private let circleAnnotationController: CircleAnnotationController
    private let pointAnnotationController: PointAnnotationController
    private let polygonAnnotationController: PolygonAnnotationController
    private let polylineAnnotationController: PolylineAnnotationController
    private var onPointAnnotationClickListener: OnPointAnnotationClickListener?
    private var onCircleAnnotationClickListener: OnCircleAnnotationClickListener?
    private var onPolygonAnnotationClickListener: OnPolygonAnnotationClickListener?
    private var onPolylineAnnotationClickListener: OnPolylineAnnotationClickListener?

    init(withMapView mapView: MapView, messenger: SuffixBinaryMessenger) {
        self.mapView = mapView
        self.binaryMessenger = messenger
        circleAnnotationController = CircleAnnotationController()
        pointAnnotationController = PointAnnotationController()
        polygonAnnotationController = PolygonAnnotationController()
        polylineAnnotationController = PolylineAnnotationController()
    }

    func handleCreateManager(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = methodCall.arguments as? [String: Any] else { return }
        guard let type = arguments["type"] as? String else { return }
        let id = (arguments["id"] as? String) ?? String(UUID().uuidString.prefix(5))
        let belowLayerId: String?
        if let layerId = arguments["belowLayerId"] as? String, mapView.mapboxMap.layerExists(withId: layerId) {
            belowLayerId = layerId
        } else {
            belowLayerId = nil
        }

        let streamHandler = AnyAnnotationDragEventsStreamHandler()
        if let manager: AnnotationManager = {
            switch type {
            case "circle":
                let circleManager = mapView.annotations.makeCircleAnnotationManager(
                    id: id,
                    layerPosition: belowLayerId.map(MapboxMaps.LayerPosition.below)
                )
                circleManager.delegate = self
                    circleAnnotationController.add(controller: circleManager, sendGestureEvents: streamHandler.send(event:))
                disposal[id] = circleAnnotationController.removeController(id:)
                return circleManager
            case "point":
                let pointManager = mapView.annotations.makePointAnnotationManager(
                    id: id,
                    layerPosition: belowLayerId.map(MapboxMaps.LayerPosition.below)
                )
                pointManager.delegate = self
                    pointAnnotationController.add(controller: pointManager, sendGestureEvents: streamHandler.send(event:))
                disposal[id] = pointAnnotationController.removeController(id:)
                return pointManager
            case "polygon":
                let polygonManager: PolygonAnnotationManager = mapView.annotations.makePolygonAnnotationManager(
                    id: id,
                    layerPosition: belowLayerId.map(MapboxMaps.LayerPosition.below)
                )
                polygonManager.delegate = self
                    polygonAnnotationController.add(controller: polygonManager, sendGestureEvents: streamHandler.send(event:))
                disposal[id] = polygonAnnotationController.removeController(id:)
                return polygonManager
            case "polyline":
                let polylineManager: PolylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager(
                    id: id,
                    layerPosition: belowLayerId.map(MapboxMaps.LayerPosition.below)
                )
                polylineManager.delegate = self
                    polylineAnnotationController.add(controller: polylineManager, sendGestureEvents: streamHandler.send(event:))
                disposal[id] = polylineAnnotationController.removeController(id:)
                return polylineManager
            default:
                return nil
            }
        }() {
            AnnotationDragEventsStreamHandler.register(
                with: binaryMessenger.messenger,
                instanceName: binaryMessenger.suffix + "/" + id,
                streamHandler: streamHandler)
            result(manager.id)
        } else {
            result(AnnotationControllerError.wrongManagerType)
        }
    }

    func handleRemoveManager(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = methodCall.arguments as? [String: Any] else { return }
        guard let id = arguments["id"] as? String else { return }

        disposal[id]?(id)

        mapView.annotations.removeAnnotationManager(withId: id)
        result(nil)
    }

    func setup() {
        _CircleAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: circleAnnotationController, messageChannelSuffix: binaryMessenger.suffix)
        _PointAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: pointAnnotationController, messageChannelSuffix: binaryMessenger.suffix)
        _PolygonAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: polygonAnnotationController, messageChannelSuffix: binaryMessenger.suffix)
        _PolylineAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: polylineAnnotationController, messageChannelSuffix: binaryMessenger.suffix)
        onPointAnnotationClickListener = OnPointAnnotationClickListener(binaryMessenger: binaryMessenger.messenger, messageChannelSuffix: binaryMessenger.suffix)
        onCircleAnnotationClickListener = OnCircleAnnotationClickListener(binaryMessenger: binaryMessenger.messenger, messageChannelSuffix: binaryMessenger.suffix)
        onPolygonAnnotationClickListener = OnPolygonAnnotationClickListener(binaryMessenger: binaryMessenger.messenger, messageChannelSuffix: binaryMessenger.suffix)
        onPolylineAnnotationClickListener = OnPolylineAnnotationClickListener(binaryMessenger: binaryMessenger.messenger, messageChannelSuffix: binaryMessenger.suffix)
    }

    func tearDown() {
        _CircleAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _PointAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _PolygonAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        _PolylineAnnotationMessengerSetup.setUp(binaryMessenger: binaryMessenger.messenger, api: nil, messageChannelSuffix: binaryMessenger.suffix)
        onPointAnnotationClickListener = nil
        onCircleAnnotationClickListener = nil
        onPolygonAnnotationClickListener = nil
        onPolylineAnnotationClickListener = nil
    }
}
