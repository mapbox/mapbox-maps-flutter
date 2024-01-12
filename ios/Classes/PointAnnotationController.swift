// This file is generated.
import MapboxMaps
import UIKit

final class PointAnnotationController: NSObject, FLT_PointAnnotationMessager {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PointAnnotationManager
    private enum `Error`: Swift.Error {
        case managerNotFound(String)
    }

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

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw Error.managerNotFound(id)
        }
    }

    // MARK: Properties

    func setIconAllowOverlapManagerId(_ managerId: String, iconAllowOverlap: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconAllowOverlap = iconAllowOverlap

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconAllowOverlapManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconAllowOverlap = manager.iconAllowOverlap else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: iconAllowOverlap), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconIgnorePlacementManagerId(_ managerId: String, iconIgnorePlacement: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconIgnorePlacement = iconIgnorePlacement

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconIgnorePlacementManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconIgnorePlacement = manager.iconIgnorePlacement else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: iconIgnorePlacement), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconKeepUprightManagerId(_ managerId: String, iconKeepUpright: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconKeepUpright = iconKeepUpright

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconKeepUprightManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconKeepUpright = manager.iconKeepUpright else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: iconKeepUpright), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconOptionalManagerId(_ managerId: String, iconOptional: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconOptional = iconOptional

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconOptionalManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconOptional = manager.iconOptional else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: iconOptional), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconPaddingManagerId(_ managerId: String, iconPadding: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconPadding = iconPadding

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconPaddingManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconPadding = manager.iconPadding else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: iconPadding), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconPitchAlignmentManagerId(_ managerId: String, iconPitchAlignment: FLTIconPitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconPitchAlignment = IconPitchAlignment(iconPitchAlignment)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconPitchAlignmentManagerId(_ managerId: String, completion: @escaping (FLTIconPitchAlignmentBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconPitchAlignment = manager.iconPitchAlignment else {
                completion(nil, nil)
                return
            }

            completion(iconPitchAlignment.toFLTIconPitchAlignmentBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconRotationAlignmentManagerId(_ managerId: String, iconRotationAlignment: FLTIconRotationAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconRotationAlignment = IconRotationAlignment(iconRotationAlignment)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconRotationAlignmentManagerId(_ managerId: String, completion: @escaping (FLTIconRotationAlignmentBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconRotationAlignment = manager.iconRotationAlignment else {
                completion(nil, nil)
                return
            }

            completion(iconRotationAlignment.toFLTIconRotationAlignmentBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setSymbolAvoidEdgesManagerId(_ managerId: String, symbolAvoidEdges: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolAvoidEdges = symbolAvoidEdges

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getSymbolAvoidEdgesManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let symbolAvoidEdges = manager.symbolAvoidEdges else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: symbolAvoidEdges), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setSymbolPlacementManagerId(_ managerId: String, symbolPlacement: FLTSymbolPlacement, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolPlacement = SymbolPlacement(symbolPlacement)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getSymbolPlacementManagerId(_ managerId: String, completion: @escaping (FLTSymbolPlacementBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let symbolPlacement = manager.symbolPlacement else {
                completion(nil, nil)
                return
            }

            completion(symbolPlacement.toFLTSymbolPlacementBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setSymbolSpacingManagerId(_ managerId: String, symbolSpacing: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolSpacing = symbolSpacing

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getSymbolSpacingManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let symbolSpacing = manager.symbolSpacing else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: symbolSpacing), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setSymbolZElevateManagerId(_ managerId: String, symbolZElevate: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolZElevate = symbolZElevate

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getSymbolZElevateManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let symbolZElevate = manager.symbolZElevate else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: symbolZElevate), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setSymbolZOrderManagerId(_ managerId: String, symbolZOrder: FLTSymbolZOrder, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolZOrder = SymbolZOrder(symbolZOrder)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getSymbolZOrderManagerId(_ managerId: String, completion: @escaping (FLTSymbolZOrderBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let symbolZOrder = manager.symbolZOrder else {
                completion(nil, nil)
                return
            }

            completion(symbolZOrder.toFLTSymbolZOrderBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextAllowOverlapManagerId(_ managerId: String, textAllowOverlap: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textAllowOverlap = textAllowOverlap

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextAllowOverlapManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textAllowOverlap = manager.textAllowOverlap else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textAllowOverlap), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextFontManagerId(_ managerId: String, textFont: [String], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textFont = textFont.map {$0}

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextFontManagerId(_ managerId: String, completion: @escaping ([String]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textFont = manager.textFont else {
                completion(nil, nil)
                return
            }

            completion(textFont, nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextIgnorePlacementManagerId(_ managerId: String, textIgnorePlacement: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textIgnorePlacement = textIgnorePlacement

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextIgnorePlacementManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textIgnorePlacement = manager.textIgnorePlacement else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textIgnorePlacement), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextKeepUprightManagerId(_ managerId: String, textKeepUpright: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textKeepUpright = textKeepUpright

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextKeepUprightManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textKeepUpright = manager.textKeepUpright else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textKeepUpright), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextMaxAngleManagerId(_ managerId: String, textMaxAngle: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textMaxAngle = textMaxAngle

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextMaxAngleManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textMaxAngle = manager.textMaxAngle else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textMaxAngle), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextOptionalManagerId(_ managerId: String, textOptional: Bool, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textOptional = textOptional

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextOptionalManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textOptional = manager.textOptional else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textOptional), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextPaddingManagerId(_ managerId: String, textPadding: Double, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textPadding = textPadding

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextPaddingManagerId(_ managerId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textPadding = manager.textPadding else {
                completion(nil, nil)
                return
            }

            completion(NSNumber(value: textPadding), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextPitchAlignmentManagerId(_ managerId: String, textPitchAlignment: FLTTextPitchAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textPitchAlignment = TextPitchAlignment(textPitchAlignment)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextPitchAlignmentManagerId(_ managerId: String, completion: @escaping (FLTTextPitchAlignmentBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textPitchAlignment = manager.textPitchAlignment else {
                completion(nil, nil)
                return
            }

            completion(textPitchAlignment.toFLTTextPitchAlignmentBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextRotationAlignmentManagerId(_ managerId: String, textRotationAlignment: FLTTextRotationAlignment, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textRotationAlignment = TextRotationAlignment(textRotationAlignment)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextRotationAlignmentManagerId(_ managerId: String, completion: @escaping (FLTTextRotationAlignmentBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textRotationAlignment = manager.textRotationAlignment else {
                completion(nil, nil)
                return
            }

            completion(textRotationAlignment.toFLTTextRotationAlignmentBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconTranslateManagerId(_ managerId: String, iconTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconTranslate = iconTranslate.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconTranslateManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconTranslate = manager.iconTranslate else {
                completion(nil, nil)
                return
            }

            completion(iconTranslate.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setIconTranslateAnchorManagerId(_ managerId: String, iconTranslateAnchor: FLTIconTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconTranslateAnchor = IconTranslateAnchor(iconTranslateAnchor)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getIconTranslateAnchorManagerId(_ managerId: String, completion: @escaping (FLTIconTranslateAnchorBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let iconTranslateAnchor = manager.iconTranslateAnchor else {
                completion(nil, nil)
                return
            }

            completion(iconTranslateAnchor.toFLTIconTranslateAnchorBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextTranslateManagerId(_ managerId: String, textTranslate: [NSNumber], completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textTranslate = textTranslate.map {$0.doubleValue}

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextTranslateManagerId(_ managerId: String, completion: @escaping ([NSNumber]?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textTranslate = manager.textTranslate else {
                completion(nil, nil)
                return
            }

            completion(textTranslate.map(NSNumber.init(value:)), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func setTextTranslateAnchorManagerId(_ managerId: String, textTranslateAnchor: FLTTextTranslateAnchor, completion: @escaping (FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textTranslateAnchor = TextTranslateAnchor(textTranslateAnchor)

            completion(nil)
        } catch {
            completion(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }

    func getTextTranslateAnchorManagerId(_ managerId: String, completion: @escaping (FLTTextTranslateAnchorBox?, FlutterError?) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            guard let textTranslateAnchor = manager.textTranslateAnchor else {
                completion(nil, nil)
                return
            }

            completion(textTranslateAnchor.toFLTTextTranslateAnchorBox(), nil)
        } catch {
            completion(nil, FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
        }
    }
}

extension FLTPointAnnotationOptions {

    func toPointAnnotation() -> PointAnnotation {
        var annotation = PointAnnotation(coordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
        if let image {
            annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: UUID().uuidString)
        }
        annotation.iconAnchor = iconAnchor.flatMap(IconAnchor.init)
        if let iconImage {
            annotation.iconImage = iconImage
        }
        if let iconOffset {
            annotation.iconOffset = iconOffset.map {$0.doubleValue}
        }
        if let iconRotate {
            annotation.iconRotate = iconRotate.doubleValue
        }
        if let iconSize {
            annotation.iconSize = iconSize.doubleValue
        }
        annotation.iconTextFit = iconTextFit.flatMap(IconTextFit.init)
        if let iconTextFitPadding {
            annotation.iconTextFitPadding = iconTextFitPadding.map {$0.doubleValue}
        }
        if let symbolSortKey {
            annotation.symbolSortKey = symbolSortKey.doubleValue
        }
        annotation.textAnchor = textAnchor.flatMap(TextAnchor.init)
        if let textField {
            annotation.textField = textField
        }
        annotation.textJustify = textJustify.flatMap(TextJustify.init)
        if let textLetterSpacing {
            annotation.textLetterSpacing = textLetterSpacing.doubleValue
        }
        if let textLineHeight {
            annotation.textLineHeight = textLineHeight.doubleValue
        }
        if let textMaxWidth {
            annotation.textMaxWidth = textMaxWidth.doubleValue
        }
        if let textOffset {
            annotation.textOffset = textOffset.map {$0.doubleValue}
        }
        if let textRadialOffset {
            annotation.textRadialOffset = textRadialOffset.doubleValue
        }
        if let textRotate {
            annotation.textRotate = textRotate.doubleValue
        }
        if let textSize {
            annotation.textSize = textSize.doubleValue
        }
        annotation.textTransform = textTransform.flatMap(TextTransform.init)
        if let iconColor {
            annotation.iconColor = StyleColor.init(uiColorFromHex(rgbValue: iconColor.intValue))
        }
        if let iconEmissiveStrength {
            annotation.iconEmissiveStrength = iconEmissiveStrength.doubleValue
        }
        if let iconHaloBlur {
            annotation.iconHaloBlur = iconHaloBlur.doubleValue
        }
        if let iconHaloColor {
            annotation.iconHaloColor = StyleColor.init(uiColorFromHex(rgbValue: iconHaloColor.intValue))
        }
        if let iconHaloWidth {
            annotation.iconHaloWidth = iconHaloWidth.doubleValue
        }
        if let iconImageCrossFade {
            annotation.iconImageCrossFade = iconImageCrossFade.doubleValue
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity.doubleValue
        }
        if let textColor {
            annotation.textColor = StyleColor.init(uiColorFromHex(rgbValue: textColor.intValue))
        }
        if let textEmissiveStrength {
            annotation.textEmissiveStrength = textEmissiveStrength.doubleValue
        }
        if let textHaloBlur {
            annotation.textHaloBlur = textHaloBlur.doubleValue
        }
        if let textHaloColor {
            annotation.textHaloColor = StyleColor.init(uiColorFromHex(rgbValue: textHaloColor.intValue))
        }
        if let textHaloWidth {
            annotation.textHaloWidth = textHaloWidth.doubleValue
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity.doubleValue
        }
        return annotation
    }
}

extension FLTPointAnnotation {

    func toPointAnnotation() -> PointAnnotation {
                var annotation = PointAnnotation(id: self.id, coordinate: convertDictionaryToCLLocationCoordinate2D(dict: self.geometry)!)
        if let image = self.image {
            annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: iconImage ?? UUID().uuidString)
        }
                annotation.iconAnchor = iconAnchor.flatMap(IconAnchor.init)
        if let iconImage {
            annotation.iconImage = iconImage
        }
        if let iconOffset {
            annotation.iconOffset = iconOffset.map {$0.doubleValue}
        }
        if let iconRotate {
            annotation.iconRotate = iconRotate.doubleValue
        }
        if let iconSize {
            annotation.iconSize = iconSize.doubleValue
        }
        annotation.iconTextFit = iconTextFit.flatMap(IconTextFit.init)
        if let iconTextFitPadding {
            annotation.iconTextFitPadding = iconTextFitPadding.map {$0.doubleValue}
        }
        if let symbolSortKey {
            annotation.symbolSortKey = symbolSortKey.doubleValue
        }
        annotation.textAnchor = textAnchor.flatMap(TextAnchor.init)
        if let textField {
            annotation.textField = textField
        }
        annotation.textJustify = textJustify.flatMap(TextJustify.init)
        if let textLetterSpacing {
            annotation.textLetterSpacing = textLetterSpacing.doubleValue
        }
        if let textLineHeight {
            annotation.textLineHeight = textLineHeight.doubleValue
        }
        if let textMaxWidth {
            annotation.textMaxWidth = textMaxWidth.doubleValue
        }
        if let textOffset {
            annotation.textOffset = textOffset.map {$0.doubleValue}
        }
        if let textRadialOffset {
            annotation.textRadialOffset = textRadialOffset.doubleValue
        }
        if let textRotate {
            annotation.textRotate = textRotate.doubleValue
        }
        if let textSize {
            annotation.textSize = textSize.doubleValue
        }
        annotation.textTransform = textTransform.flatMap(TextTransform.init)
        if let iconColor {
            annotation.iconColor = StyleColor.init(uiColorFromHex(rgbValue: iconColor.intValue))
        }
        if let iconEmissiveStrength {
            annotation.iconEmissiveStrength = iconEmissiveStrength.doubleValue
        }
        if let iconHaloBlur {
            annotation.iconHaloBlur = iconHaloBlur.doubleValue
        }
        if let iconHaloColor {
            annotation.iconHaloColor = StyleColor.init(uiColorFromHex(rgbValue: iconHaloColor.intValue))
        }
        if let iconHaloWidth {
            annotation.iconHaloWidth = iconHaloWidth.doubleValue
        }
        if let iconImageCrossFade {
            annotation.iconImageCrossFade = iconImageCrossFade.doubleValue
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity.doubleValue
        }
        if let textColor {
            annotation.textColor = StyleColor.init(uiColorFromHex(rgbValue: textColor.intValue))
        }
        if let textEmissiveStrength {
            annotation.textEmissiveStrength = textEmissiveStrength.doubleValue
        }
        if let textHaloBlur {
            annotation.textHaloBlur = textHaloBlur.doubleValue
        }
        if let textHaloColor {
            annotation.textHaloColor = StyleColor.init(uiColorFromHex(rgbValue: textHaloColor.intValue))
        }
        if let textHaloWidth {
            annotation.textHaloWidth = textHaloWidth.doubleValue
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity.doubleValue
        }
        return annotation
    }
}
extension PointAnnotation {
    func toFLTPointAnnotation() -> FLTPointAnnotation {
        let iconAnchor = iconAnchor?.toFLTIconAnchorBox()
        let iconImage = iconImage
        let iconOffset = iconOffset?.map(NSNumber.init(value:))
        let iconRotate = iconRotate.map(NSNumber.init(value:))
        let iconSize = iconSize.map(NSNumber.init(value:))
        let iconTextFit = iconTextFit?.toFLTIconTextFitBox()
        let iconTextFitPadding = iconTextFitPadding?.map(NSNumber.init(value:))
        let symbolSortKey = symbolSortKey.map(NSNumber.init(value:))
        let textAnchor = textAnchor?.toFLTTextAnchorBox()
        let textField = textField
        let textJustify = textJustify?.toFLTTextJustifyBox()
        let textLetterSpacing = textLetterSpacing.map(NSNumber.init(value:))
        let textLineHeight = textLineHeight.map(NSNumber.init(value:))
        let textMaxWidth = textMaxWidth.map(NSNumber.init(value:))
        let textOffset = textOffset?.map(NSNumber.init(value:))
        let textRadialOffset = textRadialOffset.map(NSNumber.init(value:))
        let textRotate = textRotate.map(NSNumber.init(value:))
        let textSize = textSize.map(NSNumber.init(value:))
        let textTransform = textTransform?.toFLTTextTransformBox()
        let iconColor = iconColor?.nsNumberValue
        let iconEmissiveStrength = iconEmissiveStrength.map(NSNumber.init(value:))
        let iconHaloBlur = iconHaloBlur.map(NSNumber.init(value:))
        let iconHaloColor = iconHaloColor?.nsNumberValue
        let iconHaloWidth = iconHaloWidth.map(NSNumber.init(value:))
        let iconImageCrossFade = iconImageCrossFade.map(NSNumber.init(value:))
        let iconOpacity = iconOpacity.map(NSNumber.init(value:))
        let textColor = textColor?.nsNumberValue
        let textEmissiveStrength = textEmissiveStrength.map(NSNumber.init(value:))
        let textHaloBlur = textHaloBlur.map(NSNumber.init(value:))
        let textHaloColor = textHaloColor?.nsNumberValue
        let textHaloWidth = textHaloWidth.map(NSNumber.init(value:))
        let textOpacity = textOpacity.map(NSNumber.init(value:))

        return FLTPointAnnotation.make(
            withId: id,
            geometry: geometry.toMap(),
            image: image?.image.pngData().map(FlutterStandardTypedData.init(bytes:)),
            iconAnchor: iconAnchor,
            iconImage: iconImage,
            iconOffset: iconOffset,
            iconRotate: iconRotate,
            iconSize: iconSize,
            iconTextFit: iconTextFit,
            iconTextFitPadding: iconTextFitPadding,
            symbolSortKey: symbolSortKey,
            textAnchor: textAnchor,
            textField: textField,
            textJustify: textJustify,
            textLetterSpacing: textLetterSpacing,
            textLineHeight: textLineHeight,
            textMaxWidth: textMaxWidth,
            textOffset: textOffset,
            textRadialOffset: textRadialOffset,
            textRotate: textRotate,
            textSize: textSize,
            textTransform: textTransform,
            iconColor: iconColor,
            iconEmissiveStrength: iconEmissiveStrength,
            iconHaloBlur: iconHaloBlur,
            iconHaloColor: iconHaloColor,
            iconHaloWidth: iconHaloWidth,
            iconImageCrossFade: iconImageCrossFade,
            iconOpacity: iconOpacity,
            textColor: textColor,
            textEmissiveStrength: textEmissiveStrength,
            textHaloBlur: textHaloBlur,
            textHaloColor: textHaloColor,
            textHaloWidth: textHaloWidth,
            textOpacity: textOpacity
        )
    }
}
// End of generated file.
