// swiftlint:disable file_length
// This file is generated.
@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

extension MapboxMaps.PolygonAnnotation: InteractableAnnotation {}

final class PolygonAnnotationController: BaseAnnotationMessenger<PolygonAnnotationManager>, _PolygonAnnotationMessenger {
    private static let errorCode = "0"
    private typealias AnnotationManager = PolygonAnnotationManager

    func create(managerId: String, annotationOption: PolygonAnnotationOptions, completion: @escaping (Result<PolygonAnnotation, Error>) -> Void) {
        try createMulti(managerId: managerId, annotationOptions: [annotationOption]) { result in
            completion(result.flatMap {
                guard let createdAnnotation = $0.first else {
                    return .failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "Fail to appen annotation", details: nil))
                }
                return .success(createdAnnotation)
            })
        }
    }

    func createMulti(managerId: String, annotationOptions: [PolygonAnnotationOptions], completion: @escaping (Result<[PolygonAnnotation], Error>) -> Void) {
        do {
            let annotations = annotationOptions.map({ options in
                var annotation = options.toPolygonAnnotation()
                annotation.dragBeginHandler = { [weak self] (annotation, context) in
                    let context = PolygonAnnotationInteractionContext(
                        annotation: annotation.toFLTPolygonAnnotation(),
                        gestureState: .started)
                    self?.sendGestureEvent(context, managerId: managerId)
                    return true
                }
                annotation.dragChangeHandler = { [weak self] (annotation, context) in
                    let context = PolygonAnnotationInteractionContext(
                        annotation: annotation.toFLTPolygonAnnotation(),
                        gestureState: .changed)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
				annotation.dragEndHandler = { [weak self] (annotation, context) in
              	    let context = PolygonAnnotationInteractionContext(
                	    annotation: annotation.toFLTPolygonAnnotation(),
                        gestureState: .ended)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
                return annotation
            })
            try append(annotations, managerId: managerId)
            completion(.success((annotations.map { $0.toFLTPolygonAnnotation() })))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PolygonAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let updatedAnnotation = annotation.toPolygonAnnotation()
            try update(annotation: updatedAnnotation, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PolygonAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        delete(annotation: annotation.id, managerId: managerId)
        completion(.success(()))
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteAllAnnotations(from: managerId)
        completion(.success(()))
    }

    // MARK: Properties

    func getFillConstructBridgeGuardRail(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillConstructBridgeGuardRail, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillConstructBridgeGuardRail(managerId: String, fillConstructBridgeGuardRail: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillConstructBridgeGuardRail
            try set(\.fillConstructBridgeGuardRail, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillElevationReference(managerId: String, completion: @escaping (Result<FillElevationReference?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillElevationReference, managerId: managerId)?.toFLTFillElevationReference()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillElevationReference(managerId: String, fillElevationReference: FillElevationReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.FillElevationReference(fillElevationReference)
            try set(\.fillElevationReference, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillSortKey, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillSortKey(managerId: String, fillSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillSortKey
            try set(\.fillSortKey, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillAntialias(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillAntialias, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillAntialias(managerId: String, fillAntialias: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillAntialias
            try set(\.fillAntialias, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillBridgeGuardRailColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillBridgeGuardRailColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillBridgeGuardRailColor(managerId: String, fillBridgeGuardRailColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: fillBridgeGuardRailColor)
            try set(\.fillBridgeGuardRailColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillColor(managerId: String, fillColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: fillColor)
            try set(\.fillColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillEmissiveStrength, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillEmissiveStrength(managerId: String, fillEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillEmissiveStrength
            try set(\.fillEmissiveStrength, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillOpacity(managerId: String, fillOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillOpacity
            try set(\.fillOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillOutlineColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillOutlineColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillOutlineColor(managerId: String, fillOutlineColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: fillOutlineColor)
            try set(\.fillOutlineColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillPattern(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillPattern, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillPattern(managerId: String, fillPattern: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillPattern
            try set(\.fillPattern, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillTranslate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillTranslate(managerId: String, fillTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillTranslate.compactMap { $0 }
            try set(\.fillTranslate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillTranslateAnchor(managerId: String, completion: @escaping (Result<FillTranslateAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillTranslateAnchor, managerId: managerId)?.toFLTFillTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillTranslateAnchor(managerId: String, fillTranslateAnchor: FillTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.FillTranslateAnchor(fillTranslateAnchor)
            try set(\.fillTranslateAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillTunnelStructureColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillTunnelStructureColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillTunnelStructureColor(managerId: String, fillTunnelStructureColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: fillTunnelStructureColor)
            try set(\.fillTunnelStructureColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillZOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.fillZOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillZOffset(managerId: String, fillZOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = fillZOffset
            try set(\.fillZOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension PolygonAnnotationOptions {

    func toPolygonAnnotation() -> MapboxMaps.PolygonAnnotation {
        var annotation = MapboxMaps.PolygonAnnotation(polygon: geometry)
        if let fillConstructBridgeGuardRail {
            annotation.fillConstructBridgeGuardRail = fillConstructBridgeGuardRail
        }
        if let fillSortKey {
            annotation.fillSortKey = fillSortKey
        }
        if let fillBridgeGuardRailColor {
            annotation.fillBridgeGuardRailColor = StyleColor(rgb: fillBridgeGuardRailColor)
        }
        if let fillColor {
            annotation.fillColor = StyleColor(rgb: fillColor)
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor(rgb: fillOutlineColor)
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        if let fillTunnelStructureColor {
            annotation.fillTunnelStructureColor = StyleColor(rgb: fillTunnelStructureColor)
        }
        if let fillZOffset {
            annotation.fillZOffset = fillZOffset
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension PolygonAnnotation {

    func toPolygonAnnotation() -> MapboxMaps.PolygonAnnotation {
        var annotation = MapboxMaps.PolygonAnnotation(id: self.id, polygon: geometry)
        if let fillConstructBridgeGuardRail {
            annotation.fillConstructBridgeGuardRail = fillConstructBridgeGuardRail
        }
        if let fillSortKey {
            annotation.fillSortKey = fillSortKey
        }
        if let fillBridgeGuardRailColor {
            annotation.fillBridgeGuardRailColor = StyleColor(rgb: fillBridgeGuardRailColor)
        }
        if let fillColor {
            annotation.fillColor = StyleColor(rgb: fillColor)
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor(rgb: fillOutlineColor)
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        if let fillTunnelStructureColor {
            annotation.fillTunnelStructureColor = StyleColor(rgb: fillTunnelStructureColor)
        }
        if let fillZOffset {
            annotation.fillZOffset = fillZOffset
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension MapboxMaps.PolygonAnnotation {
    func toFLTPolygonAnnotation() -> PolygonAnnotation {
        PolygonAnnotation(
            id: id,
            geometry: polygon,
            fillConstructBridgeGuardRail: fillConstructBridgeGuardRail,
            fillSortKey: fillSortKey,
            fillBridgeGuardRailColor: fillBridgeGuardRailColor?.intValue,
            fillColor: fillColor?.intValue,
            fillOpacity: fillOpacity,
            fillOutlineColor: fillOutlineColor?.intValue,
            fillPattern: fillPattern,
            fillTunnelStructureColor: fillTunnelStructureColor?.intValue,
            fillZOffset: fillZOffset,
            isDraggable: isDraggable
        )
    }
}
// End of generated file.
// swiftlint:enable file_length
