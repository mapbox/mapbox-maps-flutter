// This file is generated.
import Foundation
import MapboxMaps
import UIKit

class CircleAnnotationController: NSObject, FLT_CircleAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

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

func setCirclePitchAlignmentManagerId(_ managerId: String, circlePitchAlignment: FLTCirclePitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.circlePitchAlignment = CirclePitchAlignment.allCases[Int(circlePitchAlignment.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getCirclePitchAlignmentManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
               if let circlePitchAlignment = manager.circlePitchAlignment {
                let index = CirclePitchAlignment.allCases.firstIndex(of: circlePitchAlignment)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setCirclePitchScaleManagerId(_ managerId: String, circlePitchScale: FLTCirclePitchScale, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.circlePitchScale = CirclePitchScale.allCases[Int(circlePitchScale.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getCirclePitchScaleManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
               if let circlePitchScale = manager.circlePitchScale {
                let index = CirclePitchScale.allCases.firstIndex(of: circlePitchScale)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setCircleTranslateManagerId(_ managerId: String, circleTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.circleTranslate = circleTranslate.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getCircleTranslateManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
               if let circleTranslate = manager.circleTranslate {
                completion(circleTranslate.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setCircleTranslateAnchorManagerId(_ managerId: String, circleTranslateAnchor: FLTCircleTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.circleTranslateAnchor = CircleTranslateAnchor.allCases[Int(circleTranslateAnchor.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getCircleTranslateAnchorManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
               if let circleTranslateAnchor = manager.circleTranslateAnchor {
                let index = CircleTranslateAnchor.allCases.firstIndex(of: circleTranslateAnchor)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }
}

extension FLTCircleAnnotationOptions {
    func toCircleAnnotation() -> CircleAnnotation {
    var annotation = CircleAnnotation(centerCoordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
        if let circleSortKey = self.circleSortKey {
           annotation.circleSortKey = circleSortKey.doubleValue
        }
        if let circleBlur = self.circleBlur {
           annotation.circleBlur = circleBlur.doubleValue
        }
        if let circleColor = self.circleColor {
           annotation.circleColor = StyleColor.init(uiColorFromHex(rgbValue: circleColor.intValue))
        }
        if let circleOpacity = self.circleOpacity {
           annotation.circleOpacity = circleOpacity.doubleValue
        }
        if let circleRadius = self.circleRadius {
           annotation.circleRadius = circleRadius.doubleValue
        }
        if let circleStrokeColor = self.circleStrokeColor {
           annotation.circleStrokeColor = StyleColor.init(uiColorFromHex(rgbValue: circleStrokeColor.intValue))
        }
        if let circleStrokeOpacity = self.circleStrokeOpacity {
           annotation.circleStrokeOpacity = circleStrokeOpacity.doubleValue
        }
        if let circleStrokeWidth = self.circleStrokeWidth {
           annotation.circleStrokeWidth = circleStrokeWidth.doubleValue
        }
        return annotation
    }
}

extension FLTCircleAnnotation {
    func toCircleAnnotation() -> CircleAnnotation {
    var annotation = CircleAnnotation(id: self.id, centerCoordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
    if let circleSortKey = self.circleSortKey {
       annotation.circleSortKey = circleSortKey.doubleValue
    }
    if let circleBlur = self.circleBlur {
       annotation.circleBlur = circleBlur.doubleValue
    }
    if let circleColor = self.circleColor {
       annotation.circleColor = StyleColor.init(uiColorFromHex(rgbValue: circleColor.intValue))
    }
    if let circleOpacity = self.circleOpacity {
       annotation.circleOpacity = circleOpacity.doubleValue
    }
    if let circleRadius = self.circleRadius {
       annotation.circleRadius = circleRadius.doubleValue
    }
    if let circleStrokeColor = self.circleStrokeColor {
       annotation.circleStrokeColor = StyleColor.init(uiColorFromHex(rgbValue: circleStrokeColor.intValue))
    }
    if let circleStrokeOpacity = self.circleStrokeOpacity {
       annotation.circleStrokeOpacity = circleStrokeOpacity.doubleValue
    }
    if let circleStrokeWidth = self.circleStrokeWidth {
       annotation.circleStrokeWidth = circleStrokeWidth.doubleValue
    }
        return annotation
    }
}
extension CircleAnnotation {
    func toFLTCircleAnnotation() -> FLTCircleAnnotation {
        var circleSortKey: NSNumber?
        if self.circleSortKey != nil {
            circleSortKey = NSNumber(value: self.circleSortKey!)
        }
        var circleBlur: NSNumber?
        if self.circleBlur != nil {
            circleBlur = NSNumber(value: self.circleBlur!)
        }
        var circleColor: NSNumber?
        if self.circleColor != nil {
            circleColor = NSNumber(value: self.circleColor!.rgb())
        }
        var circleOpacity: NSNumber?
        if self.circleOpacity != nil {
            circleOpacity = NSNumber(value: self.circleOpacity!)
        }
        var circleRadius: NSNumber?
        if self.circleRadius != nil {
            circleRadius = NSNumber(value: self.circleRadius!)
        }
        var circleStrokeColor: NSNumber?
        if self.circleStrokeColor != nil {
            circleStrokeColor = NSNumber(value: self.circleStrokeColor!.rgb())
        }
        var circleStrokeOpacity: NSNumber?
        if self.circleStrokeOpacity != nil {
            circleStrokeOpacity = NSNumber(value: self.circleStrokeOpacity!)
        }
        var circleStrokeWidth: NSNumber?
        if self.circleStrokeWidth != nil {
            circleStrokeWidth = NSNumber(value: self.circleStrokeWidth!)
        }

        return FLTCircleAnnotation.make(withId: self.id, geometry: self.point.toMap(), circleSortKey: circleSortKey, circleBlur: circleBlur, circleColor: circleColor, circleOpacity: circleOpacity, circleRadius: circleRadius, circleStrokeColor: circleStrokeColor, circleStrokeOpacity: circleStrokeOpacity, circleStrokeWidth: circleStrokeWidth)
    }
}
// End of generated file.
