// This file is generated.
import MapboxMaps
import UIKit

final class PolylineAnnotationController: NSObject, FLT_PolylineAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PolylineAnnotationManager
    private enum `Error`: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func createManagerId(_ managerId: String, annotationOption: FLTPolylineAnnotationOptions, completion: @escaping (FLTPolylineAnnotation?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let createdAnnotation = annotationOption.toPolylineAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(createdAnnotation.toFLTPolylineAnnotation(), nil)
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func createMultiManagerId(_ managerId: String, annotationOptions: [FLTPolylineAnnotationOptions], completion: @escaping ([FLTPolylineAnnotation]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPolylineAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPolylineAnnotation()
                }
                completion(createdAnnotations, nil)
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func updateManagerId(_ managerId: String, annotation: FLTPolylineAnnotation, completion: @escaping (FlutterError?) -> Void) {
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
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteManagerId(_ managerId: String, annotation: FLTPolylineAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polylineAnnotation in
                    polylineAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteAllManagerId(_ managerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.annotations = []
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil))
        }
        completion(nil)
    }

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw Error.managerNotFound(id)
        }
    }

    // MARK: Properties

    func setLineCapManagerId(_ managerId: String, lineCap: FLTLineCap, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineCap = LineCap(lineCap)

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineCapManagerId(_ managerId: String, completion: @escaping (FLTLineCapBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineCap = manager.lineCap else {
                completion(nil, nil)
                return
            }

            completion(lineCap.toFLTLineCapBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineMiterLimitManagerId(_ managerId: String, lineMiterLimit: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineMiterLimit = lineMiterLimit

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineMiterLimitManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineMiterLimit = manager.lineMiterLimit else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: lineMiterLimit), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineRoundLimitManagerId(_ managerId: String, lineRoundLimit: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineRoundLimit = lineRoundLimit

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineRoundLimitManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineRoundLimit = manager.lineRoundLimit else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: lineRoundLimit), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineDasharrayManagerId(_ managerId: String, lineDasharray: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineDasharray = lineDasharray.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineDasharrayManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineDasharray = manager.lineDasharray else {
                completion(nil, nil)
                return
            }

            completion(lineDasharray.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineDepthOcclusionFactorManagerId(_ managerId: String, lineDepthOcclusionFactor: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineDepthOcclusionFactor = lineDepthOcclusionFactor

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineDepthOcclusionFactorManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineDepthOcclusionFactor = manager.lineDepthOcclusionFactor else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: lineDepthOcclusionFactor), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineEmissiveStrengthManagerId(_ managerId: String, lineEmissiveStrength: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineEmissiveStrength = lineEmissiveStrength

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineEmissiveStrengthManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineEmissiveStrength = manager.lineEmissiveStrength else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: lineEmissiveStrength), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineTranslateManagerId(_ managerId: String, lineTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTranslate = lineTranslate.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineTranslateManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineTranslate = manager.lineTranslate else {
                completion(nil, nil)
                return
            }

            completion(lineTranslate.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineTranslateAnchorManagerId(_ managerId: String, lineTranslateAnchor: FLTLineTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTranslateAnchor = LineTranslateAnchor(lineTranslateAnchor)

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineTranslateAnchorManagerId(_ managerId: String, completion: @escaping (FLTLineTranslateAnchorBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineTranslateAnchor = manager.lineTranslateAnchor else {
                completion(nil, nil)
                return
            }

            completion(lineTranslateAnchor.toFLTLineTranslateAnchorBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setLineTrimOffsetManagerId(_ managerId: String, lineTrimOffset: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.lineTrimOffset = lineTrimOffset.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getLineTrimOffsetManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let lineTrimOffset = manager.lineTrimOffset else {
                completion(nil, nil)
                return
            }

            completion(lineTrimOffset.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }
}

extension FLTPolylineAnnotationOptions {

    func toPolylineAnnotation() -> PolylineAnnotation {
        var annotation = PolylineAnnotation(lineString: convertDictionaryToPolyline(dict: self.geometry!))
        annotation.lineJoin = lineJoin.flatMap(LineJoin.init)
        if let lineSortKey {
            annotation.lineSortKey = lineSortKey.doubleValue
        }
        if let lineBlur {
            annotation.lineBlur = lineBlur.doubleValue
        }
        if let lineBorderColor {
            annotation.lineBorderColor = StyleColor.init(uiColorFromHex(rgbValue: lineBorderColor.intValue))
        }
        if let lineBorderWidth {
            annotation.lineBorderWidth = lineBorderWidth.doubleValue
        }
        if let lineColor {
            annotation.lineColor = StyleColor.init(uiColorFromHex(rgbValue: lineColor.intValue))
        }
        if let lineGapWidth {
            annotation.lineGapWidth = lineGapWidth.doubleValue
        }
        if let lineOffset {
            annotation.lineOffset = lineOffset.doubleValue
        }
        if let lineOpacity {
            annotation.lineOpacity = lineOpacity.doubleValue
        }
        if let linePattern {
            annotation.linePattern = linePattern
        }
        if let lineWidth {
            annotation.lineWidth = lineWidth.doubleValue
        }
        return annotation
    }
}

extension FLTPolylineAnnotation {

    func toPolylineAnnotation() -> PolylineAnnotation {
                var annotation = PolylineAnnotation(id: self.id, lineString: convertDictionaryToPolyline(dict: self.geometry!))
                annotation.lineJoin = lineJoin.flatMap(LineJoin.init)
        if let lineSortKey {
            annotation.lineSortKey = lineSortKey.doubleValue
        }
        if let lineBlur {
            annotation.lineBlur = lineBlur.doubleValue
        }
        if let lineBorderColor {
            annotation.lineBorderColor = StyleColor.init(uiColorFromHex(rgbValue: lineBorderColor.intValue))
        }
        if let lineBorderWidth {
            annotation.lineBorderWidth = lineBorderWidth.doubleValue
        }
        if let lineColor {
            annotation.lineColor = StyleColor.init(uiColorFromHex(rgbValue: lineColor.intValue))
        }
        if let lineGapWidth {
            annotation.lineGapWidth = lineGapWidth.doubleValue
        }
        if let lineOffset {
            annotation.lineOffset = lineOffset.doubleValue
        }
        if let lineOpacity {
            annotation.lineOpacity = lineOpacity.doubleValue
        }
        if let linePattern {
            annotation.linePattern = linePattern
        }
        if let lineWidth {
            annotation.lineWidth = lineWidth.doubleValue
        }
        return annotation
    }
}
extension PolylineAnnotation {
    func toFLTPolylineAnnotation() -> FLTPolylineAnnotation {
        let lineJoin = lineJoin?.toFLTLineJoinBox()
        let lineSortKey = lineSortKey.map(NSNumber.init(value:))
        let lineBlur = lineBlur.map(NSNumber.init(value:))
        let lineBorderColor = lineBorderColor?.nsNumberValue
        let lineBorderWidth = lineBorderWidth.map(NSNumber.init(value:))
        let lineColor = lineColor?.nsNumberValue
        let lineGapWidth = lineGapWidth.map(NSNumber.init(value:))
        let lineOffset = lineOffset.map(NSNumber.init(value:))
        let lineOpacity = lineOpacity.map(NSNumber.init(value:))
        let linePattern = linePattern
        let lineWidth = lineWidth.map(NSNumber.init(value:))

        return FLTPolylineAnnotation.make(
            withId: id,
            geometry: geometry.toMap(),
            lineJoin: lineJoin,
            lineSortKey: lineSortKey,
            lineBlur: lineBlur,
            lineBorderColor: lineBorderColor,
            lineBorderWidth: lineBorderWidth,
            lineColor: lineColor,
            lineGapWidth: lineGapWidth,
            lineOffset: lineOffset,
            lineOpacity: lineOpacity,
            linePattern: linePattern,
            lineWidth: lineWidth
        )
    }
}
// End of generated file.
