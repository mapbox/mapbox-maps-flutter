// This file is generated.
import MapboxMaps
import Foundation
import Flutter

final class PolygonAnnotationController: _PolygonAnnotationMessenger {
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?

    private typealias AnnotationManager = PolygonAnnotationManager
    private enum PolygonAnnotationControllerError: Swift.Error {
        case managerNotFound(String)
    }

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }

    func create(managerId: String, annotationOption: PolygonAnnotationOptions, completion: @escaping (Result<PolygonAnnotation, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let createdAnnotation = annotationOption.toPolygonAnnotation()
                manager.annotations.append(createdAnnotation)
                completion(.success(createdAnnotation.toFLTPolygonAnnotation()))
            } else {
                completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func createMulti(managerId: String, annotationOptions: [PolygonAnnotationOptions], completion: @escaping (Result<[PolygonAnnotation], Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let annotations = annotationOptions.map({ options in
                    options.toPolygonAnnotation()
                })
                manager.annotations.append(contentsOf: annotations)
                let createdAnnotations = annotations.map { annotation in
                    annotation.toFLTPolygonAnnotation()
                }
                completion(.success(createdAnnotations))
            } else {
                completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PolygonAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
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
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PolygonAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                let index = manager.annotations.firstIndex(where: { polygonAnnotation in
                    polygonAnnotation.id == annotation.id
                })

                if index == nil {
                    throw AnnotationControllerError.noAnnotationFound
                }
                manager.annotations.remove(at: index!)
                completion(.success(()))
            } else {
                completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let manager = try delegate?.getManager(managerId: managerId) as? PolygonAnnotationManager {
                manager.annotations = []
            } else {
                completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
            }
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId)", details: nil)))
        }
        completion(.success(()))
    }

    private func getManager(id: String) throws -> AnnotationManager {
        if let manager = try delegate?.getManager(managerId: id) as? AnnotationManager {
            return manager
        } else {
            throw PolygonAnnotationControllerError.managerNotFound(id)
        }
    }

    // MARK: Properties

    func getFillSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillSortKey))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillSortKey(managerId: String, fillSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillSortKey = fillSortKey

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillAntialias(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillAntialias))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillAntialias(managerId: String, fillAntialias: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillAntialias = fillAntialias

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillColor(managerId: String, fillColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillColor = StyleColor(rgb: fillColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillEmissiveStrength))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillEmissiveStrength(managerId: String, fillEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillEmissiveStrength = fillEmissiveStrength

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillOpacity))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillOpacity(managerId: String, fillOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillOpacity = fillOpacity

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillOutlineColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillOutlineColor?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillOutlineColor(managerId: String, fillOutlineColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillOutlineColor = StyleColor(rgb: fillOutlineColor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillPattern(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillPattern))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillPattern(managerId: String, fillPattern: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillPattern = fillPattern

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillTranslate))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillTranslate(managerId: String, fillTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillTranslate = fillTranslate.compactMap { $0 }

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getFillTranslateAnchor(managerId: String, completion: @escaping (Result<FillTranslateAnchor?, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            completion(.success(manager.fillTranslateAnchor?.toFLTFillTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setFillTranslateAnchor(managerId: String, fillTranslateAnchor: FillTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let manager = try getManager(id: managerId)
            manager.fillTranslateAnchor = MapboxMaps.FillTranslateAnchor(fillTranslateAnchor)

            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PolygonAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }
}

extension PolygonAnnotationOptions {

    func toPolygonAnnotation() -> MapboxMaps.PolygonAnnotation {
        var annotation = MapboxMaps.PolygonAnnotation(polygon: geometry)
        if let fillSortKey {
            annotation.fillSortKey = fillSortKey
        }
        if let fillColor {
            annotation.fillColor = StyleColor(rgb: fillColor)
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor(rgb: fillOutlineColor)
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        return annotation
    }
}

extension PolygonAnnotation {

    func toPolygonAnnotation() -> MapboxMaps.PolygonAnnotation {
        var annotation = MapboxMaps.PolygonAnnotation(id: self.id, polygon: geometry)
        if let fillSortKey {
            annotation.fillSortKey = fillSortKey
        }
        if let fillColor {
            annotation.fillColor = StyleColor(rgb: fillColor)
        }
        if let fillOpacity {
            annotation.fillOpacity = fillOpacity
        }
        if let fillOutlineColor {
            annotation.fillOutlineColor = StyleColor(rgb: fillOutlineColor)
        }
        if let fillPattern {
            annotation.fillPattern = fillPattern
        }
        return annotation
    }
}

extension MapboxMaps.PolygonAnnotation {
    func toFLTPolygonAnnotation() -> PolygonAnnotation {
        PolygonAnnotation(
            id: id,
            geometry: polygon,
            fillSortKey: fillSortKey,
            fillColor: fillColor?.intValue,
            fillOpacity: fillOpacity,
            fillOutlineColor: fillOutlineColor?.intValue,
            fillPattern: fillPattern
        )
    }
}
// End of generated file.
