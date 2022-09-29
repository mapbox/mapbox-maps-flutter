// This file is generated.
import Foundation
import MapboxMaps
import UIKit

class PolygonAnnotationController: NSObject, FLT_PolygonAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

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

func setFillAntialiasManagerId(_ managerId: String, fillAntialias: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                manager.fillAntialias = fillAntialias.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getFillAntialiasManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
               if let fillAntialias = manager.fillAntialias {
                completion(NSNumber(value: fillAntialias), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setFillTranslateManagerId(_ managerId: String, fillTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                manager.fillTranslate = fillTranslate.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getFillTranslateManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
               if let fillTranslate = manager.fillTranslate {
                completion(fillTranslate.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setFillTranslateAnchorManagerId(_ managerId: String, fillTranslateAnchor: FLTFillTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                manager.fillTranslateAnchor = FillTranslateAnchor.allCases[Int(fillTranslateAnchor.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getFillTranslateAnchorManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
               if let fillTranslateAnchor = manager.fillTranslateAnchor {
                let index = FillTranslateAnchor.allCases.firstIndex(of: fillTranslateAnchor)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }
}

extension FLTPolygonAnnotationOptions {
    func toPolygonAnnotation() -> PolygonAnnotation {
    var annotation = PolygonAnnotation(polygon: convertDictionaryToPolygon(dict: self.geometry!))
        if let fillSortKey = self.fillSortKey {
           annotation.fillSortKey = fillSortKey.doubleValue
        }
        if let fillColor = self.fillColor {
           annotation.fillColor = StyleColor.init(uiColorFromHex(rgbValue: fillColor.intValue))
        }
        if let fillOpacity = self.fillOpacity {
           annotation.fillOpacity = fillOpacity.doubleValue
        }
        if let fillOutlineColor = self.fillOutlineColor {
           annotation.fillOutlineColor = StyleColor.init(uiColorFromHex(rgbValue: fillOutlineColor.intValue))
        }
        if let fillPattern = self.fillPattern {
           annotation.fillPattern = fillPattern
        }
        return annotation
    }
}

extension FLTPolygonAnnotation {
    func toPolygonAnnotation() -> PolygonAnnotation {
    var annotation = PolygonAnnotation(id: self.id, polygon: convertDictionaryToPolygon(dict: self.geometry!))
    if let fillSortKey = self.fillSortKey {
       annotation.fillSortKey = fillSortKey.doubleValue
    }
    if let fillColor = self.fillColor {
       annotation.fillColor = StyleColor.init(uiColorFromHex(rgbValue: fillColor.intValue))
    }
    if let fillOpacity = self.fillOpacity {
       annotation.fillOpacity = fillOpacity.doubleValue
    }
    if let fillOutlineColor = self.fillOutlineColor {
       annotation.fillOutlineColor = StyleColor.init(uiColorFromHex(rgbValue: fillOutlineColor.intValue))
    }
    if let fillPattern = self.fillPattern {
       annotation.fillPattern = fillPattern
    }
        return annotation
    }
}
extension PolygonAnnotation {
    func toFLTPolygonAnnotation() -> FLTPolygonAnnotation {
        var fillSortKey: NSNumber?
        if self.fillSortKey != nil {
            fillSortKey = NSNumber(value: self.fillSortKey!)
        }
        var fillColor: NSNumber?
        if self.fillColor != nil {
            fillColor = NSNumber(value: self.fillColor!.rgb())
        }
        var fillOpacity: NSNumber?
        if self.fillOpacity != nil {
            fillOpacity = NSNumber(value: self.fillOpacity!)
        }
        var fillOutlineColor: NSNumber?
        if self.fillOutlineColor != nil {
            fillOutlineColor = NSNumber(value: self.fillOutlineColor!.rgb())
        }
        var fillPattern: String?
        if self.fillPattern != nil {
            fillPattern =  self.fillPattern!
        }

        return FLTPolygonAnnotation.make(withId: self.id, geometry: self.polygon.toMap(), fillSortKey: fillSortKey, fillColor: fillColor, fillOpacity: fillOpacity, fillOutlineColor: fillOutlineColor, fillPattern: fillPattern)
    }
}
// End of generated file.
