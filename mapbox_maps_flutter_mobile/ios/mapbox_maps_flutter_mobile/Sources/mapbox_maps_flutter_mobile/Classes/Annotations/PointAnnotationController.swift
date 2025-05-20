// swiftlint:disable file_length
// This file is generated.
@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

extension MapboxMaps.PointAnnotation: InteractableAnnotation {}

final class PointAnnotationController: BaseAnnotationMessenger<PointAnnotationManager>, _PointAnnotationMessenger {
    private static let errorCode = "0"
    private typealias AnnotationManager = PointAnnotationManager

    func create(managerId: String, annotationOption: PointAnnotationOptions, completion: @escaping (Result<PointAnnotation, Error>) -> Void) {
        try createMulti(managerId: managerId, annotationOptions: [annotationOption]) { result in
            completion(result.flatMap {
                guard let createdAnnotation = $0.first else {
                    return .failure(FlutterError(code: PointAnnotationController.errorCode, message: "Fail to appen annotation", details: nil))
                }
                return .success(createdAnnotation)
            })
        }
    }

    func createMulti(managerId: String, annotationOptions: [PointAnnotationOptions], completion: @escaping (Result<[PointAnnotation], Error>) -> Void) {
        do {
            let annotations = annotationOptions.map({ options in
                var annotation = options.toPointAnnotation()
                annotation.dragBeginHandler = { [weak self] (annotation, context) in
                    let context = PointAnnotationInteractionContext(
                        annotation: annotation.toFLTPointAnnotation(),
                        gestureState: .started)
                    self?.sendGestureEvent(context, managerId: managerId)
                    return true
                }
                annotation.dragChangeHandler = { [weak self] (annotation, context) in
                    let context = PointAnnotationInteractionContext(
                        annotation: annotation.toFLTPointAnnotation(),
                        gestureState: .changed)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
				annotation.dragEndHandler = { [weak self] (annotation, context) in
              	    let context = PointAnnotationInteractionContext(
                	    annotation: annotation.toFLTPointAnnotation(),
                        gestureState: .ended)
                    self?.sendGestureEvent(context, managerId: managerId)
                }
                return annotation
            })
            try append(annotations, managerId: managerId)
            completion(.success((annotations.map { $0.toFLTPointAnnotation() })))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func update(managerId: String, annotation: PointAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let updatedAnnotation = annotation.toPointAnnotation()
            try update(annotation: updatedAnnotation, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager or annotation found with manager id: \(managerId) annotation id: \(annotation.id)", details: nil)))
        }
    }

    func delete(managerId: String, annotation: PointAnnotation, completion: @escaping (Result<Void, Error>) -> Void) {
        delete(annotation: annotation.id, managerId: managerId)
        completion(.success(()))
    }

    func deleteAll(managerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteAllAnnotations(from: managerId)
        completion(.success(()))
    }

    // MARK: Properties

    func getIconAllowOverlap(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconAllowOverlap, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconAllowOverlap(managerId: String, iconAllowOverlap: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconAllowOverlap
            try set(\.iconAllowOverlap, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconAnchor(managerId: String, completion: @escaping (Result<IconAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconAnchor, managerId: managerId)?.toFLTIconAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconAnchor(managerId: String, iconAnchor: IconAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.IconAnchor(iconAnchor)
            try set(\.iconAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconIgnorePlacement(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconIgnorePlacement, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconIgnorePlacement(managerId: String, iconIgnorePlacement: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconIgnorePlacement
            try set(\.iconIgnorePlacement, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconImage(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconImage, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconImage(managerId: String, iconImage: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconImage
            try set(\.iconImage, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconKeepUpright(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconKeepUpright, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconKeepUpright(managerId: String, iconKeepUpright: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconKeepUpright
            try set(\.iconKeepUpright, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOffset(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOffset(managerId: String, iconOffset: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconOffset.compactMap { $0 }
            try set(\.iconOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOptional(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconOptional, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOptional(managerId: String, iconOptional: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconOptional
            try set(\.iconOptional, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconPadding(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconPadding, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconPadding(managerId: String, iconPadding: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconPadding
            try set(\.iconPadding, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconPitchAlignment(managerId: String, completion: @escaping (Result<IconPitchAlignment?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconPitchAlignment, managerId: managerId)?.toFLTIconPitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconPitchAlignment(managerId: String, iconPitchAlignment: IconPitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.IconPitchAlignment(iconPitchAlignment)
            try set(\.iconPitchAlignment, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconRotate(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconRotate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconRotate(managerId: String, iconRotate: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconRotate
            try set(\.iconRotate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconRotationAlignment(managerId: String, completion: @escaping (Result<IconRotationAlignment?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconRotationAlignment, managerId: managerId)?.toFLTIconRotationAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconRotationAlignment(managerId: String, iconRotationAlignment: IconRotationAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.IconRotationAlignment(iconRotationAlignment)
            try set(\.iconRotationAlignment, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconSize(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconSize, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconSize(managerId: String, iconSize: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconSize
            try set(\.iconSize, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconSizeScaleRange(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconSizeScaleRange, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconSizeScaleRange(managerId: String, iconSizeScaleRange: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconSizeScaleRange.compactMap { $0 }
            try set(\.iconSizeScaleRange, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTextFit(managerId: String, completion: @escaping (Result<IconTextFit?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconTextFit, managerId: managerId)?.toFLTIconTextFit()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTextFit(managerId: String, iconTextFit: IconTextFit, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.IconTextFit(iconTextFit)
            try set(\.iconTextFit, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTextFitPadding(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconTextFitPadding, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTextFitPadding(managerId: String, iconTextFitPadding: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconTextFitPadding.compactMap { $0 }
            try set(\.iconTextFitPadding, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolAvoidEdges(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolAvoidEdges, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolAvoidEdges(managerId: String, symbolAvoidEdges: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = symbolAvoidEdges
            try set(\.symbolAvoidEdges, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolElevationReference(managerId: String, completion: @escaping (Result<SymbolElevationReference?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolElevationReference, managerId: managerId)?.toFLTSymbolElevationReference()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolElevationReference(managerId: String, symbolElevationReference: SymbolElevationReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.SymbolElevationReference(symbolElevationReference)
            try set(\.symbolElevationReference, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolPlacement(managerId: String, completion: @escaping (Result<SymbolPlacement?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolPlacement, managerId: managerId)?.toFLTSymbolPlacement()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolPlacement(managerId: String, symbolPlacement: SymbolPlacement, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.SymbolPlacement(symbolPlacement)
            try set(\.symbolPlacement, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolSortKey(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolSortKey, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolSortKey(managerId: String, symbolSortKey: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = symbolSortKey
            try set(\.symbolSortKey, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolSpacing(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolSpacing, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolSpacing(managerId: String, symbolSpacing: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = symbolSpacing
            try set(\.symbolSpacing, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolZElevate(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolZElevate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolZElevate(managerId: String, symbolZElevate: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = symbolZElevate
            try set(\.symbolZElevate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolZOrder(managerId: String, completion: @escaping (Result<SymbolZOrder?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolZOrder, managerId: managerId)?.toFLTSymbolZOrder()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolZOrder(managerId: String, symbolZOrder: SymbolZOrder, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.SymbolZOrder(symbolZOrder)
            try set(\.symbolZOrder, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextAllowOverlap(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textAllowOverlap, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextAllowOverlap(managerId: String, textAllowOverlap: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textAllowOverlap
            try set(\.textAllowOverlap, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextAnchor(managerId: String, completion: @escaping (Result<TextAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textAnchor, managerId: managerId)?.toFLTTextAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextAnchor(managerId: String, textAnchor: TextAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextAnchor(textAnchor)
            try set(\.textAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextField(managerId: String, completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textField, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextField(managerId: String, textField: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textField
            try set(\.textField, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextFont(managerId: String, completion: @escaping (Result<[String?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textFont, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextFont(managerId: String, textFont: [String?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textFont.compactMap { $0 }
            try set(\.textFont, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextIgnorePlacement(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textIgnorePlacement, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextIgnorePlacement(managerId: String, textIgnorePlacement: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textIgnorePlacement
            try set(\.textIgnorePlacement, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextJustify(managerId: String, completion: @escaping (Result<TextJustify?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textJustify, managerId: managerId)?.toFLTTextJustify()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextJustify(managerId: String, textJustify: TextJustify, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextJustify(textJustify)
            try set(\.textJustify, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextKeepUpright(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textKeepUpright, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextKeepUpright(managerId: String, textKeepUpright: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textKeepUpright
            try set(\.textKeepUpright, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextLetterSpacing(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textLetterSpacing, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextLetterSpacing(managerId: String, textLetterSpacing: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textLetterSpacing
            try set(\.textLetterSpacing, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextLineHeight(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textLineHeight, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextLineHeight(managerId: String, textLineHeight: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textLineHeight
            try set(\.textLineHeight, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextMaxAngle(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textMaxAngle, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextMaxAngle(managerId: String, textMaxAngle: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textMaxAngle
            try set(\.textMaxAngle, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextMaxWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textMaxWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextMaxWidth(managerId: String, textMaxWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textMaxWidth
            try set(\.textMaxWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOffset(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOffset(managerId: String, textOffset: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textOffset.compactMap { $0 }
            try set(\.textOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOptional(managerId: String, completion: @escaping (Result<Bool?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textOptional, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOptional(managerId: String, textOptional: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textOptional
            try set(\.textOptional, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextPadding(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textPadding, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextPadding(managerId: String, textPadding: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textPadding
            try set(\.textPadding, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextPitchAlignment(managerId: String, completion: @escaping (Result<TextPitchAlignment?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textPitchAlignment, managerId: managerId)?.toFLTTextPitchAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextPitchAlignment(managerId: String, textPitchAlignment: TextPitchAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextPitchAlignment(textPitchAlignment)
            try set(\.textPitchAlignment, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextRadialOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textRadialOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextRadialOffset(managerId: String, textRadialOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textRadialOffset
            try set(\.textRadialOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextRotate(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textRotate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextRotate(managerId: String, textRotate: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textRotate
            try set(\.textRotate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextRotationAlignment(managerId: String, completion: @escaping (Result<TextRotationAlignment?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textRotationAlignment, managerId: managerId)?.toFLTTextRotationAlignment()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextRotationAlignment(managerId: String, textRotationAlignment: TextRotationAlignment, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextRotationAlignment(textRotationAlignment)
            try set(\.textRotationAlignment, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextSize(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textSize, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextSize(managerId: String, textSize: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textSize
            try set(\.textSize, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextSizeScaleRange(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textSizeScaleRange, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextSizeScaleRange(managerId: String, textSizeScaleRange: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textSizeScaleRange.compactMap { $0 }
            try set(\.textSizeScaleRange, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextTransform(managerId: String, completion: @escaping (Result<TextTransform?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textTransform, managerId: managerId)?.toFLTTextTransform()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextTransform(managerId: String, textTransform: TextTransform, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextTransform(textTransform)
            try set(\.textTransform, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconColor(managerId: String, iconColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: iconColor)
            try set(\.iconColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconColorSaturation(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconColorSaturation, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconColorSaturation(managerId: String, iconColorSaturation: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconColorSaturation
            try set(\.iconColorSaturation, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconEmissiveStrength, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconEmissiveStrength(managerId: String, iconEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconEmissiveStrength
            try set(\.iconEmissiveStrength, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconHaloBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconHaloBlur, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconHaloBlur(managerId: String, iconHaloBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconHaloBlur
            try set(\.iconHaloBlur, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconHaloColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconHaloColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconHaloColor(managerId: String, iconHaloColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: iconHaloColor)
            try set(\.iconHaloColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconHaloWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconHaloWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconHaloWidth(managerId: String, iconHaloWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconHaloWidth
            try set(\.iconHaloWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconImageCrossFade(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconImageCrossFade, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconImageCrossFade(managerId: String, iconImageCrossFade: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconImageCrossFade
            try set(\.iconImageCrossFade, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconOcclusionOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOcclusionOpacity(managerId: String, iconOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconOcclusionOpacity
            try set(\.iconOcclusionOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconOpacity(managerId: String, iconOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconOpacity
            try set(\.iconOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconTranslate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTranslate(managerId: String, iconTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = iconTranslate.compactMap { $0 }
            try set(\.iconTranslate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getIconTranslateAnchor(managerId: String, completion: @escaping (Result<IconTranslateAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.iconTranslateAnchor, managerId: managerId)?.toFLTIconTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setIconTranslateAnchor(managerId: String, iconTranslateAnchor: IconTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.IconTranslateAnchor(iconTranslateAnchor)
            try set(\.iconTranslateAnchor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getSymbolZOffset(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.symbolZOffset, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setSymbolZOffset(managerId: String, symbolZOffset: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = symbolZOffset
            try set(\.symbolZOffset, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextColor(managerId: String, textColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: textColor)
            try set(\.textColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextEmissiveStrength(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textEmissiveStrength, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextEmissiveStrength(managerId: String, textEmissiveStrength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textEmissiveStrength
            try set(\.textEmissiveStrength, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextHaloBlur(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textHaloBlur, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextHaloBlur(managerId: String, textHaloBlur: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textHaloBlur
            try set(\.textHaloBlur, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextHaloColor(managerId: String, completion: @escaping (Result<Int64?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textHaloColor, managerId: managerId)?.intValue))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextHaloColor(managerId: String, textHaloColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = StyleColor(rgb: textHaloColor)
            try set(\.textHaloColor, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextHaloWidth(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textHaloWidth, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextHaloWidth(managerId: String, textHaloWidth: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textHaloWidth
            try set(\.textHaloWidth, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOcclusionOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textOcclusionOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOcclusionOpacity(managerId: String, textOcclusionOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textOcclusionOpacity
            try set(\.textOcclusionOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextOpacity(managerId: String, completion: @escaping (Result<Double?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textOpacity, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextOpacity(managerId: String, textOpacity: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textOpacity
            try set(\.textOpacity, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextTranslate(managerId: String, completion: @escaping (Result<[Double?]?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textTranslate, managerId: managerId)))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextTranslate(managerId: String, textTranslate: [Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = textTranslate.compactMap { $0 }
            try set(\.textTranslate, newValue: newValue, managerId: managerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func getTextTranslateAnchor(managerId: String, completion: @escaping (Result<TextTranslateAnchor?, Error>) -> Void) {
        do {
            completion(.success(try get(\.textTranslateAnchor, managerId: managerId)?.toFLTTextTranslateAnchor()))
        } catch {
            completion(.failure(FlutterError(code: PointAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil)))
        }
    }

    func setTextTranslateAnchor(managerId: String, textTranslateAnchor: TextTranslateAnchor, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newValue = MapboxMaps.TextTranslateAnchor(textTranslateAnchor)
            try set(\.textTranslateAnchor, newValue: newValue, managerId: managerId)
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
        if let iconOcclusionOpacity {
            annotation.iconOcclusionOpacity = iconOcclusionOpacity
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity
        }
        if let symbolZOffset {
            annotation.symbolZOffset = symbolZOffset
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
        if let textOcclusionOpacity {
            annotation.textOcclusionOpacity = textOcclusionOpacity
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
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
        if let iconOcclusionOpacity {
            annotation.iconOcclusionOpacity = iconOcclusionOpacity
        }
        if let iconOpacity {
            annotation.iconOpacity = iconOpacity
        }
        if let symbolZOffset {
            annotation.symbolZOffset = symbolZOffset
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
        if let textOcclusionOpacity {
            annotation.textOcclusionOpacity = textOcclusionOpacity
        }
        if let textOpacity {
            annotation.textOpacity = textOpacity
        }
        if let isDraggable {
            annotation.isDraggable = isDraggable
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
            iconOcclusionOpacity: iconOcclusionOpacity,
            iconOpacity: iconOpacity,
            symbolZOffset: symbolZOffset,
            textColor: textColor?.intValue,
            textEmissiveStrength: textEmissiveStrength,
            textHaloBlur: textHaloBlur,
            textHaloColor: textHaloColor?.intValue,
            textHaloWidth: textHaloWidth,
            textOcclusionOpacity: textOcclusionOpacity,
            textOpacity: textOpacity,
            isDraggable: isDraggable
        )
    }
}
// End of generated file.
// swiftlint:enable file_length
