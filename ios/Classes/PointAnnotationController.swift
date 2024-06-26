// This file is generated.
import MapboxMaps
import Foundation
import Flutter

final class PointAnnotationController: _PointAnnotationMessenger {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PointAnnotationManager
    private enum PointAnnotationControllerError: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func create(managerId: String, annotationOption: PointAnnotationOptions, completion: @escaping (Result<PointAnnotation, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let createdAnnotation = annotationOption.toPointAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(.success(createdAnnotation.toFLTPointAnnotation()))
            } else {
                completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func createMulti(managerId: String, annotationOptions: [PointAnnotationOptions], completion: @escaping (Result<[PointAnnotation], Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPointAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPointAnnotation()
                }
                completion(.success(createdAnnotations))
            } else {
                completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PointAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
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
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PointAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                let index = manager.annotations.firstIndex(where: { pointAnnotation in
                    pointAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager {
                manager.annotations = []
            } else {
                completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil)))
        }
        completion(.success(()))
    }

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw PointAnnotationControllerError.managerNotFound(id)
        }
    }

    // MARK: Properties

    func getIconAllowOverlap(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconAllowOverlap))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconAllowOverlap(managerId: String, iconAllowOverlap: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconAllowOverlap = iconAllowOverlap

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconIgnorePlacement(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconIgnorePlacement))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconIgnorePlacement(managerId: String, iconIgnorePlacement: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconIgnorePlacement = iconIgnorePlacement

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconKeepUpright(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconKeepUpright))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconKeepUpright(managerId: String, iconKeepUpright: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconKeepUpright = iconKeepUpright

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOptional(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconOptional))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOptional(managerId: String, iconOptional: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconOptional = iconOptional

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconPadding(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconPadding))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconPadding(managerId: String, iconPadding: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconPadding = iconPadding

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconPitchAlignment(managerId: String, completion: @escaping (Result<IconPitchAlignment?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconPitchAlignment?.toFLTIconPitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconPitchAlignment(managerId: String, iconPitchAlignment: IconPitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconPitchAlignment = MapboxMaps.IconPitchAlignment(iconPitchAlignment)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconRotationAlignment(managerId: String, completion: @escaping (Result<IconRotationAlignment?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconRotationAlignment?.toFLTIconRotationAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconRotationAlignment(managerId: String, iconRotationAlignment: IconRotationAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconRotationAlignment = MapboxMaps.IconRotationAlignment(iconRotationAlignment)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolAvoidEdges(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.symbolAvoidEdges))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolAvoidEdges(managerId: String, symbolAvoidEdges: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolAvoidEdges = symbolAvoidEdges

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolPlacement(managerId: String, completion: @escaping (Result<SymbolPlacement?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.symbolPlacement?.toFLTSymbolPlacement()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolPlacement(managerId: String, symbolPlacement: SymbolPlacement, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolPlacement = MapboxMaps.SymbolPlacement(symbolPlacement)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolSpacing(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.symbolSpacing))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolSpacing(managerId: String, symbolSpacing: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolSpacing = symbolSpacing

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolZElevate(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.symbolZElevate))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolZElevate(managerId: String, symbolZElevate: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolZElevate = symbolZElevate

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolZOrder(managerId: String, completion: @escaping (Result<SymbolZOrder?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.symbolZOrder?.toFLTSymbolZOrder()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolZOrder(managerId: String, symbolZOrder: SymbolZOrder, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.symbolZOrder = MapboxMaps.SymbolZOrder(symbolZOrder)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextAllowOverlap(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textAllowOverlap))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextAllowOverlap(managerId: String, textAllowOverlap: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textAllowOverlap = textAllowOverlap

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextFont(managerId: String, completion: @escaping (Result<[String?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textFont))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextFont(managerId: String, textFont: [String?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textFont = textFont.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextIgnorePlacement(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textIgnorePlacement))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextIgnorePlacement(managerId: String, textIgnorePlacement: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textIgnorePlacement = textIgnorePlacement

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextKeepUpright(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textKeepUpright))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextKeepUpright(managerId: String, textKeepUpright: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textKeepUpright = textKeepUpright

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextMaxAngle(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textMaxAngle))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextMaxAngle(managerId: String, textMaxAngle: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textMaxAngle = textMaxAngle

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOptional(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textOptional))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOptional(managerId: String, textOptional: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textOptional = textOptional

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextPadding(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textPadding))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextPadding(managerId: String, textPadding: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textPadding = textPadding

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextPitchAlignment(managerId: String, completion: @escaping (Result<TextPitchAlignment?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textPitchAlignment?.toFLTTextPitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextPitchAlignment(managerId: String, textPitchAlignment: TextPitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textPitchAlignment = MapboxMaps.TextPitchAlignment(textPitchAlignment)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextRotationAlignment(managerId: String, completion: @escaping (Result<TextRotationAlignment?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textRotationAlignment?.toFLTTextRotationAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextRotationAlignment(managerId: String, textRotationAlignment: TextRotationAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textRotationAlignment = MapboxMaps.TextRotationAlignment(textRotationAlignment)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconColorSaturation(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconColorSaturation))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconColorSaturation(managerId: String, iconColorSaturation: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconColorSaturation = iconColorSaturation

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconOcclusionOpacity))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOcclusionOpacity(managerId: String, iconOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconOcclusionOpacity = iconOcclusionOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconTranslate))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTranslate(managerId: String, iconTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconTranslate = iconTranslate.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTranslateAnchor(managerId: String, completion: @escaping (Result<IconTranslateAnchor?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.iconTranslateAnchor?.toFLTIconTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTranslateAnchor(managerId: String, iconTranslateAnchor: IconTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.iconTranslateAnchor = MapboxMaps.IconTranslateAnchor(iconTranslateAnchor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textOcclusionOpacity))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOcclusionOpacity(managerId: String, textOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textOcclusionOpacity = textOcclusionOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textTranslate))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextTranslate(managerId: String, textTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textTranslate = textTranslate.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextTranslateAnchor(managerId: String, completion: @escaping (Result<TextTranslateAnchor?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.textTranslateAnchor?.toFLTTextTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextTranslateAnchor(managerId: String, textTranslateAnchor: TextTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.textTranslateAnchor = MapboxMaps.TextTranslateAnchor(textTranslateAnchor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension PointAnnotationOptions {

    func toPointAnnotation() -> MapboxMaps.PointAnnotation {
        var annotation = MapboxMaps.PointAnnotation(point: geometry)
        if let image {
            annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: UUID().uuidString)
        }
        if let iconAnchor {
            annotation.iconAnchor = MapboxMaps.IconAnchor(iconAnchor)
        }
        if let iconImage {
            annotation.iconImage = iconImage
        }
        if let iconOffset {
            annotation.iconOffset = iconOffset.compactMap { $0 }
        }
        if let iconRotate {
            annotation.iconRotate = iconRotate
        }
        if let iconSize {
            annotation.iconSize = iconSize
        }
        if let iconTextFit {
            annotation.iconTextFit = MapboxMaps.IconTextFit(iconTextFit)
        }
        if let iconTextFitPadding {
            annotation.iconTextFitPadding = iconTextFitPadding.compactMap { $0 }
        }
        if let symbolSortKey {
            annotation.symbolSortKey = symbolSortKey
        }
        if let textAnchor {
            annotation.textAnchor = MapboxMaps.TextAnchor(textAnchor)
        }
        if let textField {
            annotation.textField = textField
        }
        if let textJustify {
            annotation.textJustify = MapboxMaps.TextJustify(textJustify)
        }
        if let textLetterSpacing {
            annotation.textLetterSpacing = textLetterSpacing
        }
        if let textLineHeight {
            annotation.textLineHeight = textLineHeight
        }
        if let textMaxWidth {
            annotation.textMaxWidth = textMaxWidth
        }
        if let textOffset {
            annotation.textOffset = textOffset.compactMap { $0 }
        }
        if let textRadialOffset {
            annotation.textRadialOffset = textRadialOffset
        }
        if let textRotate {
            annotation.textRotate = textRotate
        }
        if let textSize {
            annotation.textSize = textSize
        }
        if let textTransform {
            annotation.textTransform = MapboxMaps.TextTransform(textTransform)
        }
        if let iconColor {
            annotation.iconColor = StyleColor(rgb: iconColor)
        }
        if let iconEmissiveStrength {
            annotation.iconEmissiveStrength = iconEmissiveStrength
        }
        if let iconHaloBlur {
            annotation.iconHaloBlur = iconHaloBlur
        }
        if let iconHaloColor {
            annotation.iconHaloColor = StyleColor(rgb: iconHaloColor)
        }
        if let iconHaloWidth {
            annotation.iconHaloWidth = iconHaloWidth
        }
        if let iconImageCrossFade {
            annotation.iconImageCrossFade = iconImageCrossFade
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity
        }
        if let textColor {
            annotation.textColor = StyleColor(rgb: textColor)
        }
        if let textEmissiveStrength {
            annotation.textEmissiveStrength = textEmissiveStrength
        }
        if let textHaloBlur {
            annotation.textHaloBlur = textHaloBlur
        }
        if let textHaloColor {
            annotation.textHaloColor = StyleColor(rgb: textHaloColor)
        }
        if let textHaloWidth {
            annotation.textHaloWidth = textHaloWidth
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity
        }
        return annotation
    }
}

extension PointAnnotation {

    func toPointAnnotation() -> MapboxMaps.PointAnnotation {
        var annotation = MapboxMaps.PointAnnotation(id: self.id, point: geometry)
        if let image = self.image {
            annotation.image = .init(image: UIImage(data: image.data, scale: UIScreen.main.scale)!, name: iconImage ?? UUID().uuidString)
        }
        if let iconAnchor {
            annotation.iconAnchor = MapboxMaps.IconAnchor(iconAnchor)
        }
        if let iconImage {
            annotation.iconImage = iconImage
        }
        if let iconOffset {
            annotation.iconOffset = iconOffset.compactMap { $0 }
        }
        if let iconRotate {
            annotation.iconRotate = iconRotate
        }
        if let iconSize {
            annotation.iconSize = iconSize
        }
        if let iconTextFit {
            annotation.iconTextFit = MapboxMaps.IconTextFit(iconTextFit)
        }
        if let iconTextFitPadding {
            annotation.iconTextFitPadding = iconTextFitPadding.compactMap { $0 }
        }
        if let symbolSortKey {
            annotation.symbolSortKey = symbolSortKey
        }
        if let textAnchor {
            annotation.textAnchor = MapboxMaps.TextAnchor(textAnchor)
        }
        if let textField {
            annotation.textField = textField
        }
        if let textJustify {
            annotation.textJustify = MapboxMaps.TextJustify(textJustify)
        }
        if let textLetterSpacing {
            annotation.textLetterSpacing = textLetterSpacing
        }
        if let textLineHeight {
            annotation.textLineHeight = textLineHeight
        }
        if let textMaxWidth {
            annotation.textMaxWidth = textMaxWidth
        }
        if let textOffset {
            annotation.textOffset = textOffset.compactMap { $0 }
        }
        if let textRadialOffset {
            annotation.textRadialOffset = textRadialOffset
        }
        if let textRotate {
            annotation.textRotate = textRotate
        }
        if let textSize {
            annotation.textSize = textSize
        }
        if let textTransform {
            annotation.textTransform = MapboxMaps.TextTransform(textTransform)
        }
        if let iconColor {
            annotation.iconColor = StyleColor(rgb: iconColor)
        }
        if let iconEmissiveStrength {
            annotation.iconEmissiveStrength = iconEmissiveStrength
        }
        if let iconHaloBlur {
            annotation.iconHaloBlur = iconHaloBlur
        }
        if let iconHaloColor {
            annotation.iconHaloColor = StyleColor(rgb: iconHaloColor)
        }
        if let iconHaloWidth {
            annotation.iconHaloWidth = iconHaloWidth
        }
        if let iconImageCrossFade {
            annotation.iconImageCrossFade = iconImageCrossFade
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity
        }
        if let textColor {
            annotation.textColor = StyleColor(rgb: textColor)
        }
        if let textEmissiveStrength {
            annotation.textEmissiveStrength = textEmissiveStrength
        }
        if let textHaloBlur {
            annotation.textHaloBlur = textHaloBlur
        }
        if let textHaloColor {
            annotation.textHaloColor = StyleColor(rgb: textHaloColor)
        }
        if let textHaloWidth {
            annotation.textHaloWidth = textHaloWidth
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity
        }
        return annotation
    }
}

extension MapboxMaps.PointAnnotation {
    func toFLTPointAnnotation() -> PointAnnotation {
        PointAnnotation(
            id: id,
            geometry: point,
            image: image?.image.pngData().map(FlutterStandardTypedData.init(bytes:)),
            iconAnchor: iconAnchor?.toFLTIconAnchor(),
            iconImage: iconImage,
            iconOffset: iconOffset,
            iconRotate: iconRotate,
            iconSize: iconSize,
            iconTextFit: iconTextFit?.toFLTIconTextFit(),
            iconTextFitPadding: iconTextFitPadding,
            symbolSortKey: symbolSortKey,
            textAnchor: textAnchor?.toFLTTextAnchor(),
            textField: textField,
            textJustify: textJustify?.toFLTTextJustify(),
            textLetterSpacing: textLetterSpacing,
            textLineHeight: textLineHeight,
            textMaxWidth: textMaxWidth,
            textOffset: textOffset,
            textRadialOffset: textRadialOffset,
            textRotate: textRotate,
            textSize: textSize,
            textTransform: textTransform?.toFLTTextTransform(),
            iconColor: iconColor?.intValue,
            iconEmissiveStrength: iconEmissiveStrength,
            iconHaloBlur: iconHaloBlur,
            iconHaloColor: iconHaloColor?.intValue,
            iconHaloWidth: iconHaloWidth,
            iconImageCrossFade: iconImageCrossFade,
            iconOpacity: iconOpacity,
            textColor: textColor?.intValue,
            textEmissiveStrength: textEmissiveStrength,
            textHaloBlur: textHaloBlur,
            textHaloColor: textHaloColor?.intValue,
            textHaloWidth: textHaloWidth,
            textOpacity: textOpacity
        )
    }
}
// End of generated file.
