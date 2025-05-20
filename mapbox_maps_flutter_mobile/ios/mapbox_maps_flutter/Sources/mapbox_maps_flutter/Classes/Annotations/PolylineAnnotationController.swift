// swiftlint:disable file_length
// This file is generated.
@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

extension MapboxMaps.PolylineAnnotation: InteractableAnnotation {}

final class PolylineAnnotationController: BaseAnnotationMessenger<PolylineAnnotationManager>, _PolylineAnnotationMessenger {
    private static let errorCode = "0"
    private typealias AnnotationManager = PolylineAnnotationManager

    func create(managerId: String, annotationOption: PolylineAnnotationOptions, completion: @escaping (Result<PolylineAnnotation, Error>) -> Void) {
        try createMulti(managerId: managerId, annotationOptions: [annotationOption]) { result in
            completion(result.flatMap {
                guard let createdAnnotation = $0.first else {
                    return .failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "Fail to appen annotation", details: nil))
                }
                return .success(createdAnnotation)
            })
        }
    }

    func createMulti(managerId: String, annotationOptions: [PolylineAnnotationOptions], completion: @escaping (Result<[PolylineAnnotation], Error>) -> Void) {
        do {
            let annotations = annotationOptions.map({ options in
                var annotation = options.toPolylineAnnotation()
                annotation.dragBeginHandler = { [weak self] (annotation, context) in
                    let context = PolylineAnnotationInteractionContext(
                        annotation: annotation.toFLTPolylineAnnotation(),
                        gestureState: .started)
                    self?.sendGestureEvent(context, managerId: managerId)
                    return true
                }
                annotation.dragChangeHandler = { [weak self] (annotation, context) in
                    let context = PolylineAnnotationInteractionContext(
                        annotation: annotation.toFLTPolylineAnnotation(),
                        gestureState: .changed)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
				annotation.dragEndHandler = { [weak self] (annotation, context) in
              	    let context = PolylineAnnotationInteractionContext(
                	    annotation: annotation.toFLTPolylineAnnotation(),
                        gestureState: .ended)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
                return annotation
            })
            try append(annotations, managerId: managerId)
            completion(.success((annotations.map { $0.toFLTPolylineAnnotation() })))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PolylineAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let updatedAnnotation = annotation.toPolylineAnnotation()
            try update(annotation: updatedAnnotation, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PolylineAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        delete(annotation: annotation.id, managerId: managerId)
        completion(.success(()))
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteAllAnnotations(from: managerId)
        completion(.success(()))
    }

    // MARK: Properties

    func getLineCap(managerId: String, completion: @escaping (Result<LineCap?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineCap, managerId: managerId)?.toFLTLineCap()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineCap(managerId: String, lineCap: LineCap, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.LineCap(lineCap)
            try set(\.lineCap, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineCrossSlope(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineCrossSlope, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineCrossSlope(managerId: String, lineCrossSlope: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineCrossSlope
            try set(\.lineCrossSlope, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineElevationReference(managerId: String, completion: @escaping (Result<LineElevationReference?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineElevationReference, managerId: managerId)?.toFLTLineElevationReference()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineElevationReference(managerId: String, lineElevationReference: LineElevationReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.LineElevationReference(lineElevationReference)
            try set(\.lineElevationReference, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineJoin(managerId: String, completion: @escaping (Result<LineJoin?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineJoin, managerId: managerId)?.toFLTLineJoin()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineJoin(managerId: String, lineJoin: LineJoin, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.LineJoin(lineJoin)
            try set(\.lineJoin, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineMiterLimit(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineMiterLimit, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineMiterLimit(managerId: String, lineMiterLimit: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineMiterLimit
            try set(\.lineMiterLimit, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineRoundLimit(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineRoundLimit, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineRoundLimit(managerId: String, lineRoundLimit: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineRoundLimit
            try set(\.lineRoundLimit, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineSortKey, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineSortKey(managerId: String, lineSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineSortKey
            try set(\.lineSortKey, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineWidthUnit(managerId: String, completion: @escaping (Result<LineWidthUnit?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineWidthUnit, managerId: managerId)?.toFLTLineWidthUnit()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineWidthUnit(managerId: String, lineWidthUnit: LineWidthUnit, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.LineWidthUnit(lineWidthUnit)
            try set(\.lineWidthUnit, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineZOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineZOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineZOffset(managerId: String, lineZOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineZOffset
            try set(\.lineZOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineBlur, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBlur(managerId: String, lineBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineBlur
            try set(\.lineBlur, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBorderColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineBorderColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBorderColor(managerId: String, lineBorderColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: lineBorderColor)
            try set(\.lineBorderColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBorderWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineBorderWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBorderWidth(managerId: String, lineBorderWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineBorderWidth
            try set(\.lineBorderWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineColor(managerId: String, lineColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: lineColor)
            try set(\.lineColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineDasharray(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineDasharray, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineDasharray(managerId: String, lineDasharray: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineDasharray.compactMap { $0 }
            try set(\.lineDasharray, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineDepthOcclusionFactor(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineDepthOcclusionFactor, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineDepthOcclusionFactor(managerId: String, lineDepthOcclusionFactor: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineDepthOcclusionFactor
            try set(\.lineDepthOcclusionFactor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineEmissiveStrength, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineEmissiveStrength(managerId: String, lineEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineEmissiveStrength
            try set(\.lineEmissiveStrength, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineGapWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineGapWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineGapWidth(managerId: String, lineGapWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineGapWidth
            try set(\.lineGapWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineOcclusionOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOcclusionOpacity(managerId: String, lineOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineOcclusionOpacity
            try set(\.lineOcclusionOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOffset(managerId: String, lineOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineOffset
            try set(\.lineOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOpacity(managerId: String, lineOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineOpacity
            try set(\.lineOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLinePattern(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            completion(.success(try get(\.linePattern, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLinePattern(managerId: String, linePattern: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = linePattern
            try set(\.linePattern, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineTranslate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTranslate(managerId: String, lineTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineTranslate.compactMap { $0 }
            try set(\.lineTranslate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTranslateAnchor(managerId: String, completion: @escaping (Result<LineTranslateAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineTranslateAnchor, managerId: managerId)?.toFLTLineTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTranslateAnchor(managerId: String, lineTranslateAnchor: LineTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.LineTranslateAnchor(lineTranslateAnchor)
            try set(\.lineTranslateAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineTrimColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimColor(managerId: String, lineTrimColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: lineTrimColor)
            try set(\.lineTrimColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimFadeRange(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineTrimFadeRange, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimFadeRange(managerId: String, lineTrimFadeRange: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineTrimFadeRange.compactMap { $0 }
            try set(\.lineTrimFadeRange, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimOffset(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineTrimOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimOffset(managerId: String, lineTrimOffset: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineTrimOffset.compactMap { $0 }
            try set(\.lineTrimOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.lineWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineWidth(managerId: String, lineWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = lineWidth
            try set(\.lineWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension PolylineAnnotationOptions {

    func toPolylineAnnotation() -> MapboxMaps.PolylineAnnotation {
        var annotation = MapboxMaps.PolylineAnnotation(lineString: geometry)
        if let lineJoin {
            annotation.lineJoin = MapboxMaps.LineJoin(lineJoin)
        }
        if let lineSortKey {
            annotation.lineSortKey = lineSortKey
        }
        if let lineZOffset {
            annotation.lineZOffset = lineZOffset
        }
        if let lineBlur {
            annotation.lineBlur = lineBlur
        }
        if let lineBorderColor {
            annotation.lineBorderColor = StyleColor(rgb: lineBorderColor)
        }
        if let lineBorderWidth {
            annotation.lineBorderWidth = lineBorderWidth
        }
        if let lineColor {
            annotation.lineColor = StyleColor(rgb: lineColor)
        }
        if let lineGapWidth {
            annotation.lineGapWidth = lineGapWidth
        }
        if let lineOffset {
            annotation.lineOffset = lineOffset
        }
        if let lineOpacity {
            annotation.lineOpacity = lineOpacity
        }
        if let linePattern {
            annotation.linePattern = linePattern
        }
        if let lineWidth {
            annotation.lineWidth = lineWidth
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension PolylineAnnotation {

    func toPolylineAnnotation() -> MapboxMaps.PolylineAnnotation {
        var annotation = MapboxMaps.PolylineAnnotation(id: self.id, lineString: geometry)
        if let lineJoin {
            annotation.lineJoin = MapboxMaps.LineJoin(lineJoin)
        }
        if let lineSortKey {
            annotation.lineSortKey = lineSortKey
        }
        if let lineZOffset {
            annotation.lineZOffset = lineZOffset
        }
        if let lineBlur {
            annotation.lineBlur = lineBlur
        }
        if let lineBorderColor {
            annotation.lineBorderColor = StyleColor(rgb: lineBorderColor)
        }
        if let lineBorderWidth {
            annotation.lineBorderWidth = lineBorderWidth
        }
        if let lineColor {
            annotation.lineColor = StyleColor(rgb: lineColor)
        }
        if let lineGapWidth {
            annotation.lineGapWidth = lineGapWidth
        }
        if let lineOffset {
            annotation.lineOffset = lineOffset
        }
        if let lineOpacity {
            annotation.lineOpacity = lineOpacity
        }
        if let linePattern {
            annotation.linePattern = linePattern
        }
        if let lineWidth {
            annotation.lineWidth = lineWidth
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
        }
        return annotation
    }
}

extension MapboxMaps.PolylineAnnotation {
    func toFLTPolylineAnnotation() -> PolylineAnnotation {
        PolylineAnnotation(
            id: id,
            geometry: lineString,
            lineJoin: lineJoin?.toFLTLineJoin(),
            lineSortKey: lineSortKey,
            lineZOffset: lineZOffset,
            lineBlur: lineBlur,
            lineBorderColor: lineBorderColor?.intValue,
            lineBorderWidth: lineBorderWidth,
            lineColor: lineColor?.intValue,
            lineGapWidth: lineGapWidth,
            lineOffset: lineOffset,
            lineOpacity: lineOpacity,
            linePattern: linePattern,
            lineWidth: lineWidth,
            isDraggable: isDraggable
        )
    }
}
// End of generated file.
// swiftlint:enable file_length
