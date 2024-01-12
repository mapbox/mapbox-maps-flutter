// This file is generated.
import MapboxMaps
import UIKit

final class CircleAnnotationController: NSObject, FLT_CircleAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = CircleAnnotationManager
    private enum `Error`: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func createManagerId(_ managerId: String, annotationOption: FLTCircleAnnotationOptions, completion: @escaping (FLTCircleAnnotation?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let createdAnnotation = annotationOption.toCircleAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(createdAnnotation.toFLTCircleAnnotation(), nil)
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func createMultiManagerId(_ managerId: String, annotationOptions: [FLTCircleAnnotationOptions], completion: @escaping ([FLTCircleAnnotation]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toCircleAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTCircleAnnotation()
                }
                completion(createdAnnotations, nil)
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func updateManagerId(_ managerId: String, annotation: FLTCircleAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let index = manager.annotations.firstIndex(where: { circleAnnotation in
                    circleAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }

                let updatedAnnotation = annotation.toCircleAnnotation()

                manager.annotations[index!] = updatedAnnotation
                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteManagerId(_ managerId: String, annotation: FLTCircleAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let index = manager.annotations.firstIndex(where: { circleAnnotation in
                    circleAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteAllManagerId(_ managerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.annotations = []
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil))
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

    func setCircleEmissiveStrengthManagerId(_ managerId: String, circleEmissiveStrength: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleEmissiveStrength = circleEmissiveStrength

            completion(nil)
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getCircleEmissiveStrengthManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let circleEmissiveStrength = manager.circleEmissiveStrength else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: circleEmissiveStrength), nil)
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setCirclePitchAlignmentManagerId(_ managerId: String, circlePitchAlignment: FLTCirclePitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circlePitchAlignment = CirclePitchAlignment(circlePitchAlignment)

            completion(nil)
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getCirclePitchAlignmentManagerId(_ managerId: String, completion: @escaping (FLTCirclePitchAlignmentBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let circlePitchAlignment = manager.circlePitchAlignment else {
                completion(nil, nil)
                return
            }

            completion(circlePitchAlignment.toFLTCirclePitchAlignmentBox(), nil)
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setCirclePitchScaleManagerId(_ managerId: String, circlePitchScale: FLTCirclePitchScale, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circlePitchScale = CirclePitchScale(circlePitchScale)

            completion(nil)
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getCirclePitchScaleManagerId(_ managerId: String, completion: @escaping (FLTCirclePitchScaleBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let circlePitchScale = manager.circlePitchScale else {
                completion(nil, nil)
                return
            }

            completion(circlePitchScale.toFLTCirclePitchScaleBox(), nil)
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setCircleTranslateManagerId(_ managerId: String, circleTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleTranslate = circleTranslate.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getCircleTranslateManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let circleTranslate = manager.circleTranslate else {
                completion(nil, nil)
                return
            }

            completion(circleTranslate.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setCircleTranslateAnchorManagerId(_ managerId: String, circleTranslateAnchor: FLTCircleTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleTranslateAnchor = CircleTranslateAnchor(circleTranslateAnchor)

            completion(nil)
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getCircleTranslateAnchorManagerId(_ managerId: String, completion: @escaping (FLTCircleTranslateAnchorBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let circleTranslateAnchor = manager.circleTranslateAnchor else {
                completion(nil, nil)
                return
            }

            completion(circleTranslateAnchor.toFLTCircleTranslateAnchorBox(), nil)
        } catch {
            completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }
}

extension FLTCircleAnnotationOptions {

    func toCircleAnnotation() -> CircleAnnotation {
        var annotation = CircleAnnotation(centerCoordinate: convertDictionaryToCLLocationCoordinate2D(dict: geometry)!)
        if let circleSortKey {
            annotation.circleSortKey = circleSortKey.doubleValue
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur.doubleValue
        }
        if let circleColor {
            annotation.circleColor = StyleColor.init(uiColorFromHex(rgbValue: circleColor.intValue))
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity.doubleValue
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius.doubleValue
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor.init(uiColorFromHex(rgbValue: circleStrokeColor.intValue))
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity.doubleValue
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth.doubleValue
        }
        return annotation
    }
}

extension FLTCircleAnnotation {

    func toCircleAnnotation() -> CircleAnnotation {
                var annotation = CircleAnnotation(id: self.id, centerCoordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
                if let circleSortKey {
            annotation.circleSortKey = circleSortKey.doubleValue
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur.doubleValue
        }
        if let circleColor {
            annotation.circleColor = StyleColor.init(uiColorFromHex(rgbValue: circleColor.intValue))
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity.doubleValue
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius.doubleValue
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor.init(uiColorFromHex(rgbValue: circleStrokeColor.intValue))
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity.doubleValue
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth.doubleValue
        }
        return annotation
    }
}
extension CircleAnnotation {
    func toFLTCircleAnnotation() -> FLTCircleAnnotation {
        let circleSortKey = circleSortKey.map(NSNumber.init(value:))
        let circleBlur = circleBlur.map(NSNumber.init(value:))
        let circleColor = circleColor?.nsNumberValue
        let circleOpacity = circleOpacity.map(NSNumber.init(value:))
        let circleRadius = circleRadius.map(NSNumber.init(value:))
        let circleStrokeColor = circleStrokeColor?.nsNumberValue
        let circleStrokeOpacity = circleStrokeOpacity.map(NSNumber.init(value:))
        let circleStrokeWidth = circleStrokeWidth.map(NSNumber.init(value:))

        return FLTCircleAnnotation.make(
            withId: id,
            geometry: geometry.toMap(),
            circleSortKey: circleSortKey,
            circleBlur: circleBlur,
            circleColor: circleColor,
            circleOpacity: circleOpacity,
            circleRadius: circleRadius,
            circleStrokeColor: circleStrokeColor,
            circleStrokeOpacity: circleStrokeOpacity,
            circleStrokeWidth: circleStrokeWidth
        )
    }
}
// End of generated file.
