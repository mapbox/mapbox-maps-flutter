// This file is generated.
import Foundation
import MapboxMaps
import UIKit

class PointAnnotationController: NSObject, FLT_PointAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func createManagerId(_ managerId: String, annotationOption: FLTPointAnnotationOptions, completion: @escaping (FLTPointAnnotation?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let createdAnnotation = annotationOption.toPointAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(createdAnnotation.toFLTPointAnnotation(), nil)
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func createMultiManagerId(_ managerId: String, annotationOptions: [FLTPointAnnotationOptions], completion: @escaping ([FLTPointAnnotation]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPointAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPointAnnotation()
                }
                completion(createdAnnotations, nil)
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func updateManagerId(_ managerId: String, annotation: FLTPointAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let index = manager.annotations.firstIndex(where: { pointAnnotation in
                    pointAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }

                let updatedAnnotation = annotation.toPointAnnotation()

                manager.annotations[index!] = updatedAnnotation
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteManagerId(_ managerId: String, annotation: FLTPointAnnotation, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let index = manager.annotations.firstIndex(where: { pointAnnotation in
                    pointAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil))
        }
    }

    func deleteAllManagerId(_ managerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.annotations = []
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil))
        }
        completion(nil)
    }

func setIconAllowOverlapManagerId(_ managerId: String, iconAllowOverlap: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconAllowOverlap = iconAllowOverlap.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconAllowOverlapManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconAllowOverlap = manager.iconAllowOverlap {
                completion(NSNumber(value: iconAllowOverlap), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconIgnorePlacementManagerId(_ managerId: String, iconIgnorePlacement: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconIgnorePlacement = iconIgnorePlacement.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconIgnorePlacementManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconIgnorePlacement = manager.iconIgnorePlacement {
                completion(NSNumber(value: iconIgnorePlacement), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconKeepUprightManagerId(_ managerId: String, iconKeepUpright: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconKeepUpright = iconKeepUpright.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconKeepUprightManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconKeepUpright = manager.iconKeepUpright {
                completion(NSNumber(value: iconKeepUpright), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconOptionalManagerId(_ managerId: String, iconOptional: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconOptional = iconOptional.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconOptionalManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconOptional = manager.iconOptional {
                completion(NSNumber(value: iconOptional), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconPaddingManagerId(_ managerId: String, iconPadding: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconPadding = iconPadding.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconPaddingManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconPadding = manager.iconPadding {
                completion(NSNumber(value: iconPadding), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconPitchAlignmentManagerId(_ managerId: String, iconPitchAlignment: FLTIconPitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconPitchAlignment = IconPitchAlignment.allCases[Int(iconPitchAlignment.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconPitchAlignmentManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconPitchAlignment = manager.iconPitchAlignment {
                let index = IconPitchAlignment.allCases.firstIndex(of: iconPitchAlignment)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconRotationAlignmentManagerId(_ managerId: String, iconRotationAlignment: FLTIconRotationAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconRotationAlignment = IconRotationAlignment.allCases[Int(iconRotationAlignment.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconRotationAlignmentManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconRotationAlignment = manager.iconRotationAlignment {
                let index = IconRotationAlignment.allCases.firstIndex(of: iconRotationAlignment)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconTextFitManagerId(_ managerId: String, iconTextFit: FLTIconTextFit, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconTextFit = IconTextFit.allCases[Int(iconTextFit.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconTextFitManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconTextFit = manager.iconTextFit {
                let index = IconTextFit.allCases.firstIndex(of: iconTextFit)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconTextFitPaddingManagerId(_ managerId: String, iconTextFitPadding: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconTextFitPadding = iconTextFitPadding.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconTextFitPaddingManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconTextFitPadding = manager.iconTextFitPadding {
                completion(iconTextFitPadding.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setSymbolAvoidEdgesManagerId(_ managerId: String, symbolAvoidEdges: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.symbolAvoidEdges = symbolAvoidEdges.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getSymbolAvoidEdgesManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let symbolAvoidEdges = manager.symbolAvoidEdges {
                completion(NSNumber(value: symbolAvoidEdges), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setSymbolPlacementManagerId(_ managerId: String, symbolPlacement: FLTSymbolPlacement, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.symbolPlacement = SymbolPlacement.allCases[Int(symbolPlacement.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getSymbolPlacementManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let symbolPlacement = manager.symbolPlacement {
                let index = SymbolPlacement.allCases.firstIndex(of: symbolPlacement)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setSymbolSpacingManagerId(_ managerId: String, symbolSpacing: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.symbolSpacing = symbolSpacing.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getSymbolSpacingManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let symbolSpacing = manager.symbolSpacing {
                completion(NSNumber(value: symbolSpacing), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setSymbolZOrderManagerId(_ managerId: String, symbolZOrder: FLTSymbolZOrder, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.symbolZOrder = SymbolZOrder.allCases[Int(symbolZOrder.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getSymbolZOrderManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let symbolZOrder = manager.symbolZOrder {
                let index = SymbolZOrder.allCases.firstIndex(of: symbolZOrder)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextAllowOverlapManagerId(_ managerId: String, textAllowOverlap: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textAllowOverlap = textAllowOverlap.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextAllowOverlapManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textAllowOverlap = manager.textAllowOverlap {
                completion(NSNumber(value: textAllowOverlap), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextFontManagerId(_ managerId: String, textFont: [String], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textFont = textFont.map({$0})
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextFontManagerId(_ managerId: String, completion: @escaping ( [String]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textFont = manager.textFont {
                completion(textFont, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextIgnorePlacementManagerId(_ managerId: String, textIgnorePlacement: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textIgnorePlacement = textIgnorePlacement.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextIgnorePlacementManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textIgnorePlacement = manager.textIgnorePlacement {
                completion(NSNumber(value: textIgnorePlacement), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextKeepUprightManagerId(_ managerId: String, textKeepUpright: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textKeepUpright = textKeepUpright.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextKeepUprightManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textKeepUpright = manager.textKeepUpright {
                completion(NSNumber(value: textKeepUpright), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextLineHeightManagerId(_ managerId: String, textLineHeight: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textLineHeight = textLineHeight.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextLineHeightManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textLineHeight = manager.textLineHeight {
                completion(NSNumber(value: textLineHeight), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextMaxAngleManagerId(_ managerId: String, textMaxAngle: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textMaxAngle = textMaxAngle.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextMaxAngleManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textMaxAngle = manager.textMaxAngle {
                completion(NSNumber(value: textMaxAngle), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextOptionalManagerId(_ managerId: String, textOptional: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textOptional = textOptional.boolValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextOptionalManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textOptional = manager.textOptional {
                completion(NSNumber(value: textOptional), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextPaddingManagerId(_ managerId: String, textPadding: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textPadding = textPadding.doubleValue
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextPaddingManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textPadding = manager.textPadding {
                completion(NSNumber(value: textPadding), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextPitchAlignmentManagerId(_ managerId: String, textPitchAlignment: FLTTextPitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textPitchAlignment = TextPitchAlignment.allCases[Int(textPitchAlignment.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextPitchAlignmentManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textPitchAlignment = manager.textPitchAlignment {
                let index = TextPitchAlignment.allCases.firstIndex(of: textPitchAlignment)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextRotationAlignmentManagerId(_ managerId: String, textRotationAlignment: FLTTextRotationAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textRotationAlignment = TextRotationAlignment.allCases[Int(textRotationAlignment.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextRotationAlignmentManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textRotationAlignment = manager.textRotationAlignment {
                let index = TextRotationAlignment.allCases.firstIndex(of: textRotationAlignment)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconTranslateManagerId(_ managerId: String, iconTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconTranslate = iconTranslate.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconTranslateManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconTranslate = manager.iconTranslate {
                completion(iconTranslate.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setIconTranslateAnchorManagerId(_ managerId: String, iconTranslateAnchor: FLTIconTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.iconTranslateAnchor = IconTranslateAnchor.allCases[Int(iconTranslateAnchor.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getIconTranslateAnchorManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let iconTranslateAnchor = manager.iconTranslateAnchor {
                let index = IconTranslateAnchor.allCases.firstIndex(of: iconTranslateAnchor)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextTranslateManagerId(_ managerId: String, textTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textTranslate = textTranslate.map({$0.doubleValue})
                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextTranslateManagerId(_ managerId: String, completion: @escaping ( [NSNumber]?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textTranslate = manager.textTranslate {
                completion(textTranslate.map {NSNumber(value: $0)}, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func setTextTranslateAnchorManagerId(_ managerId: String, textTranslateAnchor: FLTTextTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.textTranslateAnchor = TextTranslateAnchor.allCases[Int(textTranslateAnchor.rawValue)]

                completion(nil)
            } else {
                completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }

func getTextTranslateAnchorManagerId(_ managerId: String, completion: @escaping ( NSNumber?, FlutterError?) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
               if let textTranslateAnchor = manager.textTranslateAnchor {
                let index = TextTranslateAnchor.allCases.firstIndex(of: textTranslateAnchor)!
                completion(NSNumber(value: index), nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
            }
        } catch {
              completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
  }
}

extension FLTPointAnnotationOptions {
    func toPointAnnotation() -> PointAnnotation {
    var annotation = PointAnnotation(coordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
    if let image = self.image {
        annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: UUID().uuidString)
    }
        annotation.iconAnchor = IconAnchor.allCases[Int(self.iconAnchor.rawValue)]
        if let iconImage = self.iconImage {
           annotation.iconImage = iconImage
        }
        if let iconOffset = self.iconOffset {
           annotation.iconOffset = iconOffset.map({$0.doubleValue})
        }
        if let iconRotate = self.iconRotate {
           annotation.iconRotate = iconRotate.doubleValue
        }
        if let iconSize = self.iconSize {
           annotation.iconSize = iconSize.doubleValue
        }
        if let symbolSortKey = self.symbolSortKey {
           annotation.symbolSortKey = symbolSortKey.doubleValue
        }
        annotation.textAnchor = TextAnchor.allCases[Int(self.textAnchor.rawValue)]
        if let textField = self.textField {
           annotation.textField = textField
        }
        annotation.textJustify = TextJustify.allCases[Int(self.textJustify.rawValue)]
        if let textLetterSpacing = self.textLetterSpacing {
           annotation.textLetterSpacing = textLetterSpacing.doubleValue
        }
        if let textMaxWidth = self.textMaxWidth {
           annotation.textMaxWidth = textMaxWidth.doubleValue
        }
        if let textOffset = self.textOffset {
           annotation.textOffset = textOffset.map({$0.doubleValue})
        }
        if let textRadialOffset = self.textRadialOffset {
           annotation.textRadialOffset = textRadialOffset.doubleValue
        }
        if let textRotate = self.textRotate {
           annotation.textRotate = textRotate.doubleValue
        }
        if let textSize = self.textSize {
           annotation.textSize = textSize.doubleValue
        }
        annotation.textTransform = TextTransform.allCases[Int(self.textTransform.rawValue)]
        if let iconColor = self.iconColor {
           annotation.iconColor = StyleColor.init(uiColorFromHex(rgbValue: iconColor.intValue))
        }
        if let iconHaloBlur = self.iconHaloBlur {
           annotation.iconHaloBlur = iconHaloBlur.doubleValue
        }
        if let iconHaloColor = self.iconHaloColor {
           annotation.iconHaloColor = StyleColor.init(uiColorFromHex(rgbValue: iconHaloColor.intValue))
        }
        if let iconHaloWidth = self.iconHaloWidth {
           annotation.iconHaloWidth = iconHaloWidth.doubleValue
        }
        if let iconOpacity = self.iconOpacity {
           annotation.iconOpacity = iconOpacity.doubleValue
        }
        if let textColor = self.textColor {
           annotation.textColor = StyleColor.init(uiColorFromHex(rgbValue: textColor.intValue))
        }
        if let textHaloBlur = self.textHaloBlur {
           annotation.textHaloBlur = textHaloBlur.doubleValue
        }
        if let textHaloColor = self.textHaloColor {
           annotation.textHaloColor = StyleColor.init(uiColorFromHex(rgbValue: textHaloColor.intValue))
        }
        if let textHaloWidth = self.textHaloWidth {
           annotation.textHaloWidth = textHaloWidth.doubleValue
        }
        if let textOpacity = self.textOpacity {
           annotation.textOpacity = textOpacity.doubleValue
        }
        return annotation
    }
}

extension FLTPointAnnotation {
    func toPointAnnotation() -> PointAnnotation {
    var annotation = PointAnnotation(id: self.id, coordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
    if let image = self.image {
        annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: UUID().uuidString)
    }
    annotation.iconAnchor = IconAnchor.allCases[Int(self.iconAnchor.rawValue)]
    if let iconImage = self.iconImage {
       annotation.iconImage = iconImage
    }
    if let iconOffset = self.iconOffset {
       annotation.iconOffset = iconOffset.map({$0.doubleValue})
    }
    if let iconRotate = self.iconRotate {
       annotation.iconRotate = iconRotate.doubleValue
    }
    if let iconSize = self.iconSize {
       annotation.iconSize = iconSize.doubleValue
    }
    if let symbolSortKey = self.symbolSortKey {
       annotation.symbolSortKey = symbolSortKey.doubleValue
    }
    annotation.textAnchor = TextAnchor.allCases[Int(self.textAnchor.rawValue)]
    if let textField = self.textField {
       annotation.textField = textField
    }
    annotation.textJustify = TextJustify.allCases[Int(self.textJustify.rawValue)]
    if let textLetterSpacing = self.textLetterSpacing {
       annotation.textLetterSpacing = textLetterSpacing.doubleValue
    }
    if let textMaxWidth = self.textMaxWidth {
       annotation.textMaxWidth = textMaxWidth.doubleValue
    }
    if let textOffset = self.textOffset {
       annotation.textOffset = textOffset.map({$0.doubleValue})
    }
    if let textRadialOffset = self.textRadialOffset {
       annotation.textRadialOffset = textRadialOffset.doubleValue
    }
    if let textRotate = self.textRotate {
       annotation.textRotate = textRotate.doubleValue
    }
    if let textSize = self.textSize {
       annotation.textSize = textSize.doubleValue
    }
    annotation.textTransform = TextTransform.allCases[Int(self.textTransform.rawValue)]
    if let iconColor = self.iconColor {
       annotation.iconColor = StyleColor.init(uiColorFromHex(rgbValue: iconColor.intValue))
    }
    if let iconHaloBlur = self.iconHaloBlur {
       annotation.iconHaloBlur = iconHaloBlur.doubleValue
    }
    if let iconHaloColor = self.iconHaloColor {
       annotation.iconHaloColor = StyleColor.init(uiColorFromHex(rgbValue: iconHaloColor.intValue))
    }
    if let iconHaloWidth = self.iconHaloWidth {
       annotation.iconHaloWidth = iconHaloWidth.doubleValue
    }
    if let iconOpacity = self.iconOpacity {
       annotation.iconOpacity = iconOpacity.doubleValue
    }
    if let textColor = self.textColor {
       annotation.textColor = StyleColor.init(uiColorFromHex(rgbValue: textColor.intValue))
    }
    if let textHaloBlur = self.textHaloBlur {
       annotation.textHaloBlur = textHaloBlur.doubleValue
    }
    if let textHaloColor = self.textHaloColor {
       annotation.textHaloColor = StyleColor.init(uiColorFromHex(rgbValue: textHaloColor.intValue))
    }
    if let textHaloWidth = self.textHaloWidth {
       annotation.textHaloWidth = textHaloWidth.doubleValue
    }
    if let textOpacity = self.textOpacity {
       annotation.textOpacity = textOpacity.doubleValue
    }
        return annotation
    }
}
extension PointAnnotation {
    func toFLTPointAnnotation() -> FLTPointAnnotation {
        var iconAnchor: FLTIconAnchor?
        if self.iconAnchor != nil {
            iconAnchor = FLTIconAnchor.init(rawValue: UInt(IconAnchor.allCases.firstIndex(of: self.iconAnchor!)!))
        }
        var iconImage: String?
        if self.iconImage != nil {
            iconImage =  self.iconImage!
        }
        var iconOffset: [NSNumber]?
        if self.iconOffset != nil {
            iconOffset = self.iconOffset!.map({NSNumber(value: $0)})
        }
        var iconRotate: NSNumber?
        if self.iconRotate != nil {
            iconRotate = NSNumber(value: self.iconRotate!)
        }
        var iconSize: NSNumber?
        if self.iconSize != nil {
            iconSize = NSNumber(value: self.iconSize!)
        }
        var symbolSortKey: NSNumber?
        if self.symbolSortKey != nil {
            symbolSortKey = NSNumber(value: self.symbolSortKey!)
        }
        var textAnchor: FLTTextAnchor?
        if self.textAnchor != nil {
            textAnchor = FLTTextAnchor.init(rawValue: UInt(TextAnchor.allCases.firstIndex(of: self.textAnchor!)!))
        }
        var textField: String?
        if self.textField != nil {
            textField =  self.textField!
        }
        var textJustify: FLTTextJustify?
        if self.textJustify != nil {
            textJustify = FLTTextJustify.init(rawValue: UInt(TextJustify.allCases.firstIndex(of: self.textJustify!)!))
        }
        var textLetterSpacing: NSNumber?
        if self.textLetterSpacing != nil {
            textLetterSpacing = NSNumber(value: self.textLetterSpacing!)
        }
        var textMaxWidth: NSNumber?
        if self.textMaxWidth != nil {
            textMaxWidth = NSNumber(value: self.textMaxWidth!)
        }
        var textOffset: [NSNumber]?
        if self.textOffset != nil {
            textOffset = self.textOffset!.map({NSNumber(value: $0)})
        }
        var textRadialOffset: NSNumber?
        if self.textRadialOffset != nil {
            textRadialOffset = NSNumber(value: self.textRadialOffset!)
        }
        var textRotate: NSNumber?
        if self.textRotate != nil {
            textRotate = NSNumber(value: self.textRotate!)
        }
        var textSize: NSNumber?
        if self.textSize != nil {
            textSize = NSNumber(value: self.textSize!)
        }
        var textTransform: FLTTextTransform?
        if self.textTransform != nil {
            textTransform = FLTTextTransform.init(rawValue: UInt(TextTransform.allCases.firstIndex(of: self.textTransform!)!))
        }
        var iconColor: NSNumber?
        if self.iconColor != nil {
            iconColor = NSNumber(value: self.iconColor!.rgb())
        }
        var iconHaloBlur: NSNumber?
        if self.iconHaloBlur != nil {
            iconHaloBlur = NSNumber(value: self.iconHaloBlur!)
        }
        var iconHaloColor: NSNumber?
        if self.iconHaloColor != nil {
            iconHaloColor = NSNumber(value: self.iconHaloColor!.rgb())
        }
        var iconHaloWidth: NSNumber?
        if self.iconHaloWidth != nil {
            iconHaloWidth = NSNumber(value: self.iconHaloWidth!)
        }
        var iconOpacity: NSNumber?
        if self.iconOpacity != nil {
            iconOpacity = NSNumber(value: self.iconOpacity!)
        }
        var textColor: NSNumber?
        if self.textColor != nil {
            textColor = NSNumber(value: self.textColor!.rgb())
        }
        var textHaloBlur: NSNumber?
        if self.textHaloBlur != nil {
            textHaloBlur = NSNumber(value: self.textHaloBlur!)
        }
        var textHaloColor: NSNumber?
        if self.textHaloColor != nil {
            textHaloColor = NSNumber(value: self.textHaloColor!.rgb())
        }
        var textHaloWidth: NSNumber?
        if self.textHaloWidth != nil {
            textHaloWidth = NSNumber(value: self.textHaloWidth!)
        }
        var textOpacity: NSNumber?
        if self.textOpacity != nil {
            textOpacity = NSNumber(value: self.textOpacity!)
        }

        return FLTPointAnnotation.make(withId: self.id, geometry: self.point.toMap(), image: nil, iconAnchor: iconAnchor!, iconImage: iconImage, iconOffset: iconOffset, iconRotate: iconRotate, iconSize: iconSize, symbolSortKey: symbolSortKey, textAnchor: textAnchor!, textField: textField, textJustify: textJustify!, textLetterSpacing: textLetterSpacing, textMaxWidth: textMaxWidth, textOffset: textOffset, textRadialOffset: textRadialOffset, textRotate: textRotate, textSize: textSize, textTransform: textTransform!, iconColor: iconColor, iconHaloBlur: iconHaloBlur, iconHaloColor: iconHaloColor, iconHaloWidth: iconHaloWidth, iconOpacity: iconOpacity, textColor: textColor, textHaloBlur: textHaloBlur, textHaloColor: textHaloColor, textHaloWidth: textHaloWidth, textOpacity: textOpacity)
    }
}
// End of generated file.
