// This file is generated.
import Foundation
import MapboxMaps
import UIKit

class PolylineAnnotationController: NSObject, FLT_PolylineAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

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

func setLineCapManagerId(_ managerId: String, lineCap: FLTLineCap, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineCap = LineCap.allCases[Int(lineCap.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineCapManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineCap = manager.lineCap {
                let index = LineCap.allCases.firstIndex(of: lineCap)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineMiterLimitManagerId(_ managerId: String, lineMiterLimit: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineMiterLimit = lineMiterLimit.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineMiterLimitManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineMiterLimit = manager.lineMiterLimit {
                completion(NSNumber(value: lineMiterLimit), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineRoundLimitManagerId(_ managerId: String, lineRoundLimit: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineRoundLimit = lineRoundLimit.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineRoundLimitManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineRoundLimit = manager.lineRoundLimit {
                completion(NSNumber(value: lineRoundLimit), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineDasharrayManagerId(_ managerId: String, lineDasharray: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineDasharray = lineDasharray.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineDasharrayManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineDasharray = manager.lineDasharray {
                completion(lineDasharray.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineTranslateManagerId(_ managerId: String, lineTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineTranslate = lineTranslate.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineTranslateManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineTranslate = manager.lineTranslate {
                completion(lineTranslate.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineTranslateAnchorManagerId(_ managerId: String, lineTranslateAnchor: FLTLineTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineTranslateAnchor = LineTranslateAnchor.allCases[Int(lineTranslateAnchor.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineTranslateAnchorManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineTranslateAnchor = manager.lineTranslateAnchor {
                let index = LineTranslateAnchor.allCases.firstIndex(of: lineTranslateAnchor)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setLineTrimOffsetManagerId(_ managerId: String, lineTrimOffset: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
                manager.lineTrimOffset = lineTrimOffset.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getLineTrimOffsetManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolylineAnnotationManager {
               if let lineTrimOffset = manager.lineTrimOffset {
                completion(lineTrimOffset.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PolylineAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }
}

extension FLTPolylineAnnotationOptions {
    func toPolylineAnnotation() -> PolylineAnnotation {
    var annotation = PolylineAnnotation(lineString: convertDictionaryToPolyline(dict: self.geometry!))
        annotation.lineJoin = LineJoin.allCases[Int(self.lineJoin.rawValue)]
        if let lineSortKey = self.lineSortKey {
           annotation.lineSortKey = lineSortKey.doubleValue
        }
        if let lineBlur = self.lineBlur {
           annotation.lineBlur = lineBlur.doubleValue
        }
        if let lineColor = self.lineColor {
           annotation.lineColor = StyleColor.init(uiColorFromHex(rgbValue: lineColor.intValue))
        }
        if let lineGapWidth = self.lineGapWidth {
           annotation.lineGapWidth = lineGapWidth.doubleValue
        }
        if let lineOffset = self.lineOffset {
           annotation.lineOffset = lineOffset.doubleValue
        }
        if let lineOpacity = self.lineOpacity {
           annotation.lineOpacity = lineOpacity.doubleValue
        }
        if let linePattern = self.linePattern {
           annotation.linePattern = linePattern
        }
        if let lineWidth = self.lineWidth {
           annotation.lineWidth = lineWidth.doubleValue
        }
        return annotation
    }
}

extension FLTPolylineAnnotation {
    func toPolylineAnnotation() -> PolylineAnnotation {
    var annotation = PolylineAnnotation(id: self.id, lineString: convertDictionaryToPolyline(dict: self.geometry!))
    annotation.lineJoin = LineJoin.allCases[Int(self.lineJoin.rawValue)]
    if let lineSortKey = self.lineSortKey {
       annotation.lineSortKey = lineSortKey.doubleValue
    }
    if let lineBlur = self.lineBlur {
       annotation.lineBlur = lineBlur.doubleValue
    }
    if let lineColor = self.lineColor {
       annotation.lineColor = StyleColor.init(uiColorFromHex(rgbValue: lineColor.intValue))
    }
    if let lineGapWidth = self.lineGapWidth {
       annotation.lineGapWidth = lineGapWidth.doubleValue
    }
    if let lineOffset = self.lineOffset {
       annotation.lineOffset = lineOffset.doubleValue
    }
    if let lineOpacity = self.lineOpacity {
       annotation.lineOpacity = lineOpacity.doubleValue
    }
    if let linePattern = self.linePattern {
       annotation.linePattern = linePattern
    }
    if let lineWidth = self.lineWidth {
       annotation.lineWidth = lineWidth.doubleValue
    }
        return annotation
    }
}
extension PolylineAnnotation {
    func toFLTPolylineAnnotation() -> FLTPolylineAnnotation {
        var lineJoin: FLTLineJoin?
        if self.lineJoin != nil {
            lineJoin = FLTLineJoin.init(rawValue: UInt(LineJoin.allCases.firstIndex(of: self.lineJoin!)!))
        }
        var lineSortKey: NSNumber?
        if self.lineSortKey != nil {
            lineSortKey = NSNumber(value: self.lineSortKey!)
        }
        var lineBlur: NSNumber?
        if self.lineBlur != nil {
            lineBlur = NSNumber(value: self.lineBlur!)
        }
        var lineColor: NSNumber?
        if self.lineColor != nil {
            lineColor = NSNumber(value: self.lineColor!.rgb())
        }
        var lineGapWidth: NSNumber?
        if self.lineGapWidth != nil {
            lineGapWidth = NSNumber(value: self.lineGapWidth!)
        }
        var lineOffset: NSNumber?
        if self.lineOffset != nil {
            lineOffset = NSNumber(value: self.lineOffset!)
        }
        var lineOpacity: NSNumber?
        if self.lineOpacity != nil {
            lineOpacity = NSNumber(value: self.lineOpacity!)
        }
        var linePattern: String?
        if self.linePattern != nil {
            linePattern =  self.linePattern!
        }
        var lineWidth: NSNumber?
        if self.lineWidth != nil {
            lineWidth = NSNumber(value: self.lineWidth!)
        }

        return FLTPolylineAnnotation.make(withId: self.id, geometry: self.lineString.toMap(), lineJoin: lineJoin!, lineSortKey: lineSortKey, lineBlur: lineBlur, lineColor: lineColor, lineGapWidth: lineGapWidth, lineOffset: lineOffset, lineOpacity: lineOpacity, linePattern: linePattern, lineWidth: lineWidth)
    }
}
// End of generated file.
