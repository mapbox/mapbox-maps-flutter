import Flutter
@_spi(Experimental) import MapboxMaps
import UIKit
import CoreLocation

/// Owns all `ViewAnnotationManager` instances attached to a single map.
///
/// Mirrors the Android controller: one top-level Swift instance handles the
/// `view_annotation#create_manager` method, and each resolved manager gets its
/// own `FlutterMethodChannel` for per-annotation operations
/// (`create`, `update`, `delete`, `deleteAll`, `dispose`).
final class ViewAnnotationController: NSObject {
    private let mapView: MapView
    private let messenger: SuffixBinaryMessenger
    private var managers: [String: ManagerHandle] = [:]
    private var autoManagerId = 0

    init(mapView: MapView, messenger: SuffixBinaryMessenger) {
        self.mapView = mapView
        self.messenger = messenger
        super.init()
    }

    func handleCreateManager(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments as? [String: Any]
        let requestedId = args?["id"] as? String
        let resolvedId: String
        if let requestedId = requestedId {
            resolvedId = requestedId
        } else {
            autoManagerId += 1
            resolvedId = "view_annotation_manager_\(autoManagerId)"
        }

        if managers[resolvedId] != nil {
            result(resolvedId)
            return
        }

        let channel = FlutterMethodChannel(
            name: "plugins.flutter.io.mapbox_maps.view_annotations.\(messenger.suffix).\(resolvedId)",
            binaryMessenger: messenger.messenger
        )
        let handle = ManagerHandle(managerId: resolvedId, mapView: mapView, channel: channel)
        handle.onDisposed = { [weak self] id in
            self?.managers.removeValue(forKey: id)
        }
        managers[resolvedId] = handle
        result(resolvedId)
    }

    func tearDown() {
        for handle in managers.values {
            handle.tearDown()
        }
        managers.removeAll()
    }
}

private final class InteractiveImageView: UIImageView {
    var annotationId: String?
    weak var host: ManagerHandle?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let id = annotationId {
            host?.dispatchTap(annotationId: id)
        }
    }
}

final class ManagerHandle: NSObject {
    private let managerId: String
    private let mapView: MapView
    private let channel: FlutterMethodChannel
    private var annotations: [String: ViewAnnotation] = [:]
    private var views: [String: InteractiveImageView] = [:]
    var onDisposed: ((String) -> Void)?

    init(managerId: String, mapView: MapView, channel: FlutterMethodChannel) {
        self.managerId = managerId
        self.mapView = mapView
        self.channel = channel
        super.init()
        channel.setMethodCallHandler { [weak self] call, result in
            self?.onMethodCall(methodCall: call, result: result)
        }
    }

    func tearDown() {
        clearAll()
        channel.setMethodCallHandler(nil)
    }

    fileprivate func dispatchTap(annotationId: String) {
        channel.invokeMethod("onTap", arguments: ["id": annotationId])
    }

    private func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "create":
            handleUpsert(methodCall: methodCall, result: result, isCreate: true)
        case "update":
            handleUpsert(methodCall: methodCall, result: result, isCreate: false)
        case "delete":
            handleDelete(methodCall: methodCall, result: result)
        case "deleteAll":
            clearAll()
            result(nil)
        case "dispose":
            tearDown()
            onDisposed?(managerId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleDelete(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = methodCall.arguments as? [String: Any],
              let id = args["id"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "delete requires an id.", details: nil))
            return
        }
        remove(id: id)
        result(nil)
    }

    private func handleUpsert(methodCall: FlutterMethodCall, result: @escaping FlutterResult, isCreate: Bool) {
        guard let args = methodCall.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments map.", details: nil))
            return
        }
        guard let id = args["id"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing annotation id.", details: nil))
            return
        }

        let imageData: Data
        if let typed = args["image"] as? FlutterStandardTypedData {
            imageData = typed.data
        } else if let raw = args["image"] as? Data {
            imageData = raw
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing image bytes.", details: nil))
            return
        }
        guard let image = UIImage(data: imageData) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Unable to decode annotation image.", details: nil))
            return
        }

        guard let coordinates = args["coordinates"] as? [NSNumber], coordinates.count >= 2 else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or malformed coordinates.", details: nil))
            return
        }
        let longitude = coordinates[0].doubleValue
        let latitude = coordinates[1].doubleValue

        let width = CGFloat((args["width"] as? NSNumber)?.doubleValue ?? Double(image.size.width))
        let height = CGFloat((args["height"] as? NSNumber)?.doubleValue ?? Double(image.size.height))
        let visible = (args["visible"] as? NSNumber)?.boolValue ?? true
        let allowOverlap = (args["allowOverlap"] as? NSNumber)?.boolValue ?? true
        let offsetX = CGFloat((args["offsetX"] as? NSNumber)?.doubleValue ?? 0)
        let offsetY = CGFloat((args["offsetY"] as? NSNumber)?.doubleValue ?? 0)
        let anchor = decodeAnchor((args["anchor"] as? NSNumber)?.intValue ?? 0)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        if let existingAnnotation = annotations[id], let existingView = views[id] {
            existingView.image = image
            existingView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            existingAnnotation.annotatedFeature = .geometry(Point(coordinate))
            existingAnnotation.allowOverlap = allowOverlap
            existingAnnotation.visible = visible
            existingAnnotation.variableAnchors = [
                ViewAnnotationAnchorConfig(anchor: anchor, offsetX: offsetX, offsetY: offsetY)
            ]
            existingAnnotation.setNeedsUpdateSize()
            result(nil)
            return
        }

        if !isCreate {
            result(FlutterError(code: "NOT_FOUND", message: "No view annotation with id=\(id).", details: nil))
            return
        }

        let imageView = InteractiveImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        imageView.annotationId = id
        imageView.host = self

        let annotation = ViewAnnotation(coordinate: coordinate, view: imageView)
        annotation.allowOverlap = allowOverlap
        annotation.visible = visible
        annotation.variableAnchors = [
            ViewAnnotationAnchorConfig(anchor: anchor, offsetX: offsetX, offsetY: offsetY)
        ]
        mapView.viewAnnotations.add(annotation)
        annotations[id] = annotation
        views[id] = imageView
        result(nil)
    }

    private func clearAll() {
        for id in Array(annotations.keys) {
            remove(id: id)
        }
    }

    private func remove(id: String) {
        annotations.removeValue(forKey: id)?.remove()
        views.removeValue(forKey: id)
    }

    private func decodeAnchor(_ rawValue: Int) -> MapboxMaps.ViewAnnotationAnchor {
        // Wire ordinals mirror lib/src/pigeons/map_interfaces.dart::ViewAnnotationAnchor.
        switch rawValue {
        case 0: return .top
        case 1: return .left
        case 2: return .bottom
        case 3: return .right
        case 4: return .topLeft
        case 5: return .bottomRight
        case 6: return .topRight
        case 7: return .bottomLeft
        case 8: return .center
        default: return .center
        }
    }
}
