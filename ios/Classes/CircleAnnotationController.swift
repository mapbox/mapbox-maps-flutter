// This file is generated.
import MapboxMaps
import Foundation
import Flutter

final class CircleAnnotationController: _CircleAnnotationMessenger {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = CircleAnnotationManager
    private enum CircleAnnotationControllerError: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func create(managerId: String, annotationOption: CircleAnnotationOptions, completion: @escaping (Result<CircleAnnotation, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let createdAnnotation = annotationOption.toCircleAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(.success(createdAnnotation.toFLTCircleAnnotation()))
            } else {
                completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func createMulti(managerId: String, annotationOptions: [CircleAnnotationOptions], completion: @escaping (Result<[CircleAnnotation], Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toCircleAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTCircleAnnotation()
                }
                completion(.success(createdAnnotations))
            } else {
                completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: CircleAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
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
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: CircleAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                let index = manager.annotations.firstIndex(where: { circleAnnotation in
                    circleAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? CircleAnnotationManager {
                manager.annotations = []
            } else {
                completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil)))
        }
        completion(.success(()))
    }

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw CircleAnnotationControllerError.managerNotFound(id)
        }
    }

    // MARK: Properties

    func getCircleSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleSortKey))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleSortKey(managerId: String, circleSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleSortKey = circleSortKey

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleBlur))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleBlur(managerId: String, circleBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleBlur = circleBlur

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleColor(managerId: String, circleColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleColor = StyleColor(rgb: circleColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleEmissiveStrength))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleEmissiveStrength(managerId: String, circleEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleEmissiveStrength = circleEmissiveStrength

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleOpacity))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleOpacity(managerId: String, circleOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleOpacity = circleOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCirclePitchAlignment(managerId: String, completion: @escaping (Result<CirclePitchAlignment?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circlePitchAlignment?.toFLTCirclePitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCirclePitchAlignment(managerId: String, circlePitchAlignment: CirclePitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circlePitchAlignment = MapboxMaps.CirclePitchAlignment(circlePitchAlignment)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCirclePitchScale(managerId: String, completion: @escaping (Result<CirclePitchScale?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circlePitchScale?.toFLTCirclePitchScale()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCirclePitchScale(managerId: String, circlePitchScale: CirclePitchScale, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circlePitchScale = MapboxMaps.CirclePitchScale(circlePitchScale)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleRadius(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleRadius))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleRadius(managerId: String, circleRadius: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleRadius = circleRadius

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleStrokeColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeColor(managerId: String, circleStrokeColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleStrokeColor = StyleColor(rgb: circleStrokeColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleStrokeOpacity))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeOpacity(managerId: String, circleStrokeOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleStrokeOpacity = circleStrokeOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleStrokeWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleStrokeWidth))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleStrokeWidth(managerId: String, circleStrokeWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleStrokeWidth = circleStrokeWidth

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleTranslate))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleTranslate(managerId: String, circleTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleTranslate = circleTranslate.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getCircleTranslateAnchor(managerId: String, completion: @escaping (Result<CircleTranslateAnchor?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.circleTranslateAnchor?.toFLTCircleTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setCircleTranslateAnchor(managerId: String, circleTranslateAnchor: CircleTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.circleTranslateAnchor = MapboxMaps.CircleTranslateAnchor(circleTranslateAnchor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: CircleAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension CircleAnnotationOptions {

    func toCircleAnnotation() -> MapboxMaps.CircleAnnotation {
        var annotation = MapboxMaps.CircleAnnotation(point: geometry)
        if let circleSortKey {
            annotation.circleSortKey = circleSortKey
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur
        }
        if let circleColor {
            annotation.circleColor = StyleColor(rgb: circleColor)
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor(rgb: circleStrokeColor)
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth
        }
        return annotation
    }
}

extension CircleAnnotation {

    func toCircleAnnotation() -> MapboxMaps.CircleAnnotation {
        var annotation = MapboxMaps.CircleAnnotation(id: self.id, point: geometry)
        if let circleSortKey {
            annotation.circleSortKey = circleSortKey
        }
        if let circleBlur {
            annotation.circleBlur = circleBlur
        }
        if let circleColor {
            annotation.circleColor = StyleColor(rgb: circleColor)
        }
        if let circleOpacity {
            annotation.circleOpacity = circleOpacity
        }
        if let circleRadius {
            annotation.circleRadius = circleRadius
        }
        if let circleStrokeColor {
            annotation.circleStrokeColor = StyleColor(rgb: circleStrokeColor)
        }
        if let circleStrokeOpacity {
            annotation.circleStrokeOpacity = circleStrokeOpacity
        }
        if let circleStrokeWidth {
            annotation.circleStrokeWidth = circleStrokeWidth
        }
        return annotation
    }
}

extension MapboxMaps.CircleAnnotation {
    func toFLTCircleAnnotation() -> CircleAnnotation {
        CircleAnnotation(
            id: id,
            geometry: point,
            circleSortKey: circleSortKey,
            circleBlur: circleBlur,
            circleColor: circleColor?.intValue,
            circleOpacity: circleOpacity,
            circleRadius: circleRadius,
            circleStrokeColor: circleStrokeColor?.intValue,
            circleStrokeOpacity: circleStrokeOpacity,
            circleStrokeWidth: circleStrokeWidth
        )
    }
}
// End of generated file.
