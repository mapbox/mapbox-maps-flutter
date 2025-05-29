// swiftlint:disable file_length
// This file is generated.
@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

extension MapboxMaps.CircleAnnotation: InteractableAnnotation {}

final class CircleAnnotationController: BaseAnnotationMessenger<CircleAnnotationManager>, _CircleAnnotationMessenger {
    private static let errorCode = "0"
    private typealias AnnotationManager = CircleAnnotationManager

    func create(managerId: String, annotationOption: CircleAnnotationOptions, completion: @escaping (Result<CircleAnnotation, Error>) -> Void) {
        try createMulti(managerId: managerId, annotationOptions: [annotationOption]) { result in
            completion(result.flatMap {
                guard let createdAnnotation = $0.first else {
                    return .failure(FlutterError(code: CircleAnnotationController.errorCode, message: "Fail to appen annotation", details: nil))
                }
                return .success(createdAnnotation)
            })
        }
    }

    func createMulti(managerId: String, annotationOptions: [CircleAnnotationOptions], completion: @escaping (Result<[CircleAnnotation], Error>) -> Void) {
        do {
            let annotations = annotationOptions.map({ options in
                var annotation = options.toCircleAnnotation()
                annotation.dragBeginHandler = { [weak self] (annotation, context) in
                    let context = CircleAnnotationInteractionContext(
                        annotation: annotation.toFLTCircleAnnotation(),
                        gestureState: .started)
                    self?.sendGestureEvent(context, managerId: managerId)
                    return true
                }
                annotation.dragChangeHandler = { [weak self] (annotation, context) in
                    let context = CircleAnnotationInteractionContext(
                        annotation: annotation.toFLTCircleAnnotation(),
                        gestureState: .changed)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
				annotation.dragEndHandler = { [weak self] (annotation, context) in
              	    let context = CircleAnnotationInteractionContext(
                	    annotation: annotation.toFLTCircleAnnotation(),
                        gestureState: .ended)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
                return annotation
            })
            try append(annotations, managerId: managerId)
            completion(.success((annotations.map { $0.toFLTCircleAnnotation() })))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: CircleAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let updatedAnnotation = annotation.toCircleAnnotation()
            try update(annotation: updatedAnnotation, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: CircleAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        delete(annotation: annotation.id, managerId: managerId)
        completion(.success(()))
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteAllAnnotations(from: managerId)
        completion(.success(()))
    }

    // MARK: Properties

    func getCircleElevationReference(managerId: String, completion: @escaping (Result<CircleElevationReference?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleElevationReference, managerId: managerId)?.toFLTCircleElevationReference()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleElevationReference(managerId: String, circleElevationReference: CircleElevationReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.CircleElevationReference(circleElevationReference)
            try set(\.circleElevationReference, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleSortKey, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleSortKey(managerId: String, circleSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleSortKey
            try set(\.circleSortKey, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleBlur, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleBlur(managerId: String, circleBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleBlur
            try set(\.circleBlur, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleColor(managerId: String, circleColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: circleColor)
            try set(\.circleColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleEmissiveStrength, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleEmissiveStrength(managerId: String, circleEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleEmissiveStrength
            try set(\.circleEmissiveStrength, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleOpacity(managerId: String, circleOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleOpacity
            try set(\.circleOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCirclePitchAlignment(managerId: String, completion: @escaping (Result<CirclePitchAlignment?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circlePitchAlignment, managerId: managerId)?.toFLTCirclePitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCirclePitchAlignment(managerId: String, circlePitchAlignment: CirclePitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.CirclePitchAlignment(circlePitchAlignment)
            try set(\.circlePitchAlignment, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCirclePitchScale(managerId: String, completion: @escaping (Result<CirclePitchScale?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circlePitchScale, managerId: managerId)?.toFLTCirclePitchScale()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCirclePitchScale(managerId: String, circlePitchScale: CirclePitchScale, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.CirclePitchScale(circlePitchScale)
            try set(\.circlePitchScale, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleRadius(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleRadius, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleRadius(managerId: String, circleRadius: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleRadius
            try set(\.circleRadius, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleStrokeColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeColor(managerId: String, circleStrokeColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: circleStrokeColor)
            try set(\.circleStrokeColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleStrokeOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeOpacity(managerId: String, circleStrokeOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleStrokeOpacity
            try set(\.circleStrokeOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleStrokeWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeWidth(managerId: String, circleStrokeWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleStrokeWidth
            try set(\.circleStrokeWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleTranslate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleTranslate(managerId: String, circleTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = circleTranslate.compactMap { $0 }
            try set(\.circleTranslate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleTranslateAnchor(managerId: String, completion: @escaping (Result<CircleTranslateAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.circleTranslateAnchor, managerId: managerId)?.toFLTCircleTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleTranslateAnchor(managerId: String, circleTranslateAnchor: CircleTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.CircleTranslateAnchor(circleTranslateAnchor)
            try set(\.circleTranslateAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension CircleAnnotationOptions {

    func toCircleAnnotation() -> MapboxMaps.CircleAnnotation {
        var annotation = MapboxMaps.CircleAnnotation(point: geometry)
        if let circleSortKey {
            annotation.circleSortKey = circleSortKey
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur
        }
        if let circleColor {
            annotation.circleColor = StyleColor(rgb: circleColor)
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor(rgb: circleStrokeColor)
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension CircleAnnotation {

    func toCircleAnnotation() -> MapboxMaps.CircleAnnotation {
        var annotation = MapboxMaps.CircleAnnotation(id: self.id, point: geometry)
        if let circleSortKey {
            annotation.circleSortKey = circleSortKey
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur
        }
        if let circleColor {
            annotation.circleColor = StyleColor(rgb: circleColor)
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor(rgb: circleStrokeColor)
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension MapboxMaps.CircleAnnotation {
    func toFLTCircleAnnotation() -> CircleAnnotation {
        CircleAnnotation(
            id: id,
            geometry: point,
            circleSortKey: circleSortKey,
            circleBlur: circleBlur,
            circleColor: circleColor?.intValue,
            circleOpacity: circleOpacity,
            circleRadius: circleRadius,
            circleStrokeColor: circleStrokeColor?.intValue,
            circleStrokeOpacity: circleStrokeOpacity,
            circleStrokeWidth: circleStrokeWidth,
            isDraggable: isDraggable
        )
    }
}
// End of generated file.
// swiftlint:enable file_length
