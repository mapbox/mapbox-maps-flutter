// This file is generated.
import MapboxMaps
import UIKit

final class PolygonAnnotationController: NSObject, FLT_PolygonAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PolygonAnnotationManager
    private enum `Error`: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func createManagerId(_ managerId: String, annotationOption: FLTPolygonAnnotationOptions, completion: @escaping (FLTPolygonAnnotation?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let createdAnnotation = annotationOption.toPolygonAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(createdAnnotation.toFLTPolygonAnnotation(), nil)
            } else {
                completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func createMultiManagerId(_ managerId: String, annotationOptions: [FLTPolygonAnnotationOptions], completion: @escaping ([FLTPolygonAnnotation]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPolygonAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPolygonAnnotation()
                }
                completion(createdAnnotations, nil)
            } else {
                completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func updateManagerId(_ managerId: String, annotation: FLTPolygonAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polygonAnnotation in
                    polygonAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }

                let updatedAnnotation = annotation.toPolygonAnnotation()

                manager.annotations[index!] = updatedAnnotation
                completion(nil)
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteManagerId(_ managerId: String, annotation: FLTPolygonAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polygonAnnotation in
                    polygonAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(nil)
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteAllManagerId(_ managerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                manager.annotations = []
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil))
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

    func setFillAntialiasManagerId(_ managerId: String, fillAntialias: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillAntialias = fillAntialias

            completion(nil)
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getFillAntialiasManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let fillAntialias = manager.fillAntialias else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: fillAntialias), nil)
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setFillEmissiveStrengthManagerId(_ managerId: String, fillEmissiveStrength: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillEmissiveStrength = fillEmissiveStrength

            completion(nil)
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getFillEmissiveStrengthManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let fillEmissiveStrength = manager.fillEmissiveStrength else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: fillEmissiveStrength), nil)
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setFillTranslateManagerId(_ managerId: String, fillTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillTranslate = fillTranslate.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getFillTranslateManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let fillTranslate = manager.fillTranslate else {
                completion(nil, nil)
                return
            }

            completion(fillTranslate.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setFillTranslateAnchorManagerId(_ managerId: String, fillTranslateAnchor: FLTFillTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillTranslateAnchor = FillTranslateAnchor(fillTranslateAnchor)

            completion(nil)
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getFillTranslateAnchorManagerId(_ managerId: String, completion: @escaping (FLTFillTranslateAnchorBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let fillTranslateAnchor = manager.fillTranslateAnchor else {
                completion(nil, nil)
                return
            }

            completion(fillTranslateAnchor.toFLTFillTranslateAnchorBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }
}

extension FLTPolygonAnnotationOptions {

    func toPolygonAnnotation() -> PolygonAnnotation {
        var annotation = PolygonAnnotation(polygon: convertDictionaryToPolygon(dict: self.geometry!))
        if let fillSortKey {
            annotation.fillSortKey = fillSortKey.doubleValue
        }
        if let fillColor {
            annotation.fillColor = StyleColor.init(uiColorFromHex(rgbValue: fillColor.intValue))
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity.doubleValue
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor.init(uiColorFromHex(rgbValue: fillOutlineColor.intValue))
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        return annotation
    }
}

extension FLTPolygonAnnotation {

    func toPolygonAnnotation() -> PolygonAnnotation {
                var annotation = PolygonAnnotation(id: self.id, polygon: convertDictionaryToPolygon(dict: self.geometry!))
                if let fillSortKey {
            annotation.fillSortKey = fillSortKey.doubleValue
        }
        if let fillColor {
            annotation.fillColor = StyleColor.init(uiColorFromHex(rgbValue: fillColor.intValue))
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity.doubleValue
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor.init(uiColorFromHex(rgbValue: fillOutlineColor.intValue))
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        return annotation
    }
}
extension PolygonAnnotation {
    func toFLTPolygonAnnotation() -> FLTPolygonAnnotation {
        let fillSortKey = fillSortKey.map(NSNumber.init(value:))
        let fillColor = fillColor?.nsNumberValue
        let fillOpacity = fillOpacity.map(NSNumber.init(value:))
        let fillOutlineColor = fillOutlineColor?.nsNumberValue
        let fillPattern = fillPattern

        return FLTPolygonAnnotation.make(
            withId: id,
            geometry: geometry.toMap(),
            fillSortKey: fillSortKey,
            fillColor: fillColor,
            fillOpacity: fillOpacity,
            fillOutlineColor: fillOutlineColor,
            fillPattern: fillPattern
        )
    }
}
// End of generated file.
