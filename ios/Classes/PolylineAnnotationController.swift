// This file is generated.
@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

final class PolylineAnnotationController: _PolylineAnnotationMessenger {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PolylineAnnotationManager
    private enum PolylineAnnotationControllerError: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func create(managerId: String, annotationOption: PolylineAnnotationOptions, completion: @escaping (Result<PolylineAnnotation, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let createdAnnotation = annotationOption.toPolylineAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(.success(createdAnnotation.toFLTPolylineAnnotation()))
            } else {
                completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func createMulti(managerId: String, annotationOptions: [PolylineAnnotationOptions], completion: @escaping (Result<[PolylineAnnotation], Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPolylineAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPolylineAnnotation()
                }
                completion(.success(createdAnnotations))
            } else {
                completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PolylineAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polylineAnnotation in
                    polylineAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }

                let updatedAnnotation = annotation.toPolylineAnnotation()

                manager.annotations[index!] = updatedAnnotation
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PolylineAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polylineAnnotation in
                    polylineAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.annotations = []
            } else {
                completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil)))
        }
        completion(.success(()))
    }

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw PolylineAnnotationControllerError.managerNotFound(id)
        }
    }

    // MARK: Properties

    func getLineCap(managerId: String, completion: @escaping (Result<LineCap?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineCap?.toFLTLineCap()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineCap(managerId: String, lineCap: LineCap, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineCap = MapboxMaps.LineCap(lineCap)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineJoin(managerId: String, completion: @escaping (Result<LineJoin?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineJoin?.toFLTLineJoin()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineJoin(managerId: String, lineJoin: LineJoin, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineJoin = MapboxMaps.LineJoin(lineJoin)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineMiterLimit(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineMiterLimit))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineMiterLimit(managerId: String, lineMiterLimit: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineMiterLimit = lineMiterLimit

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineRoundLimit(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineRoundLimit))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineRoundLimit(managerId: String, lineRoundLimit: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineRoundLimit = lineRoundLimit

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineSortKey))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineSortKey(managerId: String, lineSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineSortKey = lineSortKey

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineZOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineZOffset))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineZOffset(managerId: String, lineZOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineZOffset = lineZOffset

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineBlur))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBlur(managerId: String, lineBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineBlur = lineBlur

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBorderColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineBorderColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBorderColor(managerId: String, lineBorderColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineBorderColor = StyleColor(rgb: lineBorderColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineBorderWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineBorderWidth))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineBorderWidth(managerId: String, lineBorderWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineBorderWidth = lineBorderWidth

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineColor(managerId: String, lineColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineColor = StyleColor(rgb: lineColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineDasharray(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineDasharray))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineDasharray(managerId: String, lineDasharray: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineDasharray = lineDasharray.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineDepthOcclusionFactor(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineDepthOcclusionFactor))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineDepthOcclusionFactor(managerId: String, lineDepthOcclusionFactor: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineDepthOcclusionFactor = lineDepthOcclusionFactor

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineEmissiveStrength))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineEmissiveStrength(managerId: String, lineEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineEmissiveStrength = lineEmissiveStrength

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineGapWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineGapWidth))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineGapWidth(managerId: String, lineGapWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineGapWidth = lineGapWidth

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineOcclusionOpacity))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOcclusionOpacity(managerId: String, lineOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineOcclusionOpacity = lineOcclusionOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineOffset))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOffset(managerId: String, lineOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineOffset = lineOffset

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineOpacity))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineOpacity(managerId: String, lineOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineOpacity = lineOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLinePattern(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.linePattern))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLinePattern(managerId: String, linePattern: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.linePattern = linePattern

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineTranslate))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTranslate(managerId: String, lineTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTranslate = lineTranslate.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTranslateAnchor(managerId: String, completion: @escaping (Result<LineTranslateAnchor?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineTranslateAnchor?.toFLTLineTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTranslateAnchor(managerId: String, lineTranslateAnchor: LineTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTranslateAnchor = MapboxMaps.LineTranslateAnchor(lineTranslateAnchor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineTrimColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimColor(managerId: String, lineTrimColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTrimColor = StyleColor(rgb: lineTrimColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimFadeRange(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineTrimFadeRange))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimFadeRange(managerId: String, lineTrimFadeRange: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTrimFadeRange = lineTrimFadeRange.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineTrimOffset(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineTrimOffset))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineTrimOffset(managerId: String, lineTrimOffset: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTrimOffset = lineTrimOffset.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getLineWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.lineWidth))
        } catch {
            completion(.failure(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setLineWidth(managerId: String, lineWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineWidth = lineWidth

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
            lineWidth: lineWidth
        )
    }
}
// End of generated file.
