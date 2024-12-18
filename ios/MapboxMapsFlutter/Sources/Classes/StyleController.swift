@_spi(Experimental) import MapboxMaps
import Foundation
import Flutter

final class StyleController: StyleManager {
    private static let errorCode = "0"

    private let styleManager: MapboxMaps.StyleManager

    init(styleManager: MapboxMaps.StyleManager) {
        self.styleManager = styleManager
    }

    func getStyleURI(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(styleManager.styleURI?.rawValue ?? ""))
    }

    func setStyleURI(uri: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: uri) else {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: "Invalid style uri", details: nil)))
            return
        }
        styleManager.load(mapStyle: MapStyle(uri: styleURI)) { error in
            guard let error else {
                completion(.success(()))
                return
            }
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleJSON(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(styleManager.styleJSON))
    }

    func setStyleJSON(json: String, completion: @escaping (Result<Void, Error>) -> Void) {
        styleManager.load(mapStyle: MapStyle(json: json)) { error in
            guard let error else {
                completion(.success(()))
                return
            }

            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleDefaultCamera(completion: @escaping (Result<CameraOptions, Error>) -> Void) {
        let camera = styleManager.styleDefaultCamera
        completion(.success(camera.toFLTCameraOptions()))
    }

    func getStyleTransition(completion: @escaping (Result<TransitionOptions, Error>) -> Void) {
        let transition = styleManager.styleTransition
        completion(.success(transition.toFLTTransitionOptions()))

    }

    func setStyleTransition(transitionOptions: TransitionOptions, completion: @escaping (Result<Void, Error>) -> Void) {
        styleManager.styleTransition = transitionOptions.toTransitionOptions()
        completion(.success(()))
    }

    func addStyleLayer(properties: String, layerPosition: LayerPosition?, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            try styleManager.addLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func addPersistentStyleLayer(properties: String, layerPosition: LayerPosition?, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.addPersistentLayer(
                with: convertStringToDictionary(properties: properties),
                layerPosition: layerPosition?.toLayerPosition()
            )
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func isStyleLayerPersistent(layerId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let isPersistent = try styleManager.isPersistentLayer(id: layerId)
            completion(.success(isPersistent))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func removeStyleLayer(layerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.removeLayer(withId: layerId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func moveStyleLayer(layerId: String, layerPosition: LayerPosition?, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if layerPosition != nil {
                try styleManager.moveLayer(withId: layerId, to: layerPosition!.toLayerPosition())
            } else {
                try styleManager.moveLayer(withId: layerId, to: .default)
            }
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func styleLayerExists(layerId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let exists = styleManager.layerExists(withId: layerId)
        completion(.success(exists))
    }

    func getStyleLayers(completion: @escaping (Result<[StyleObjectInfo?], Error>) -> Void) {
        let layerInfos = styleManager.allLayerIdentifiers.map {
            StyleObjectInfo(id: $0.id, type: $0.type.rawValue)
        }
        completion(.success(layerInfos))
    }

    func getStyleLayerProperty(layerId: String, property: String, completion: @escaping (Result<StylePropertyValue, Error>) -> Void) {
        let layerProperty = styleManager.layerProperty(for: layerId, property: property)
        completion(.success(layerProperty.toFLTStylePropertyValue(property: property)))
    }

    func setStyleLayerProperty(layerId: String, property: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            var mappedValue = value
            if let stringValue = value as? String {
                if stringValue.hasPrefix("[") || stringValue.hasPrefix("{") {
                    if let expressionData = stringValue.data(using: .utf8) {
                        let expJSONObject = try JSONSerialization.jsonObject(with: expressionData, options: [])
                        mappedValue = expJSONObject
                    }
                }
            }
            try styleManager.setLayerProperty(for: layerId, property: property, value: mappedValue)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleLayerProperties(layerId: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let properties = try styleManager.layerProperties(for: layerId)
            completion(.success(convertDictionaryToString(dict: properties)))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func setStyleLayerProperties(layerId: String, properties: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try styleManager.setLayerProperties(for: layerId, properties: jsonObject as? [String: Any] ?? [:])
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func addStyleSource(sourceId: String, properties: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.addSource(withId: sourceId,
                                          properties: convertStringToDictionary(properties: properties))
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleSourceProperty(sourceId: String, property: String, completion: @escaping (Result<StylePropertyValue, Error>) -> Void) {
        let sourceProperty = styleManager.sourceProperty(for: sourceId, property: property)
        completion(.success(sourceProperty.toFLTStylePropertyValue(property: property)))
    }

    func setStyleSourceProperty(sourceId: String, property: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.setSourceProperty(for: sourceId, property: property, value: value)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleSourceProperties(sourceId: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let properties = try styleManager.sourceProperties(for: sourceId)
            completion(.success(convertDictionaryToString(dict: properties)))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func setStyleSourceProperties(sourceId: String, properties: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.setSourceProperties(for: sourceId, properties: convertStringToDictionary(properties: properties))
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func addGeoJSONSourceFeatures(sourceId: String, dataId: String, features: [Feature], completion: @escaping (Result<Void, Error>) -> Void) {
        styleManager.addGeoJSONSourceFeatures(forSourceId: sourceId, features: features, dataId: dataId)
        completion(.success(()))
    }

    func updateGeoJSONSourceFeatures(sourceId: String, dataId: String, features: [Feature], completion: @escaping (Result<Void, Error>) -> Void) {
        styleManager.updateGeoJSONSourceFeatures(forSourceId: sourceId, features: features, dataId: dataId)
        completion(.success(()))
    }

    func removeGeoJSONSourceFeatures(sourceId: String, dataId: String, featureIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        styleManager.removeGeoJSONSourceFeatures(forSourceId: sourceId, featureIds: featureIds, dataId: dataId)
        completion(.success(()))
    }

    func updateStyleImageSourceImage(sourceId: String, image: MbxImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let image = UIImage(data: image.data.data, scale: UIScreen.main.scale) else {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: "Could not initialize the image from the specified data.", details: nil)))
            return
        }
        do {
            try styleManager.updateImageSource(withId: sourceId, image: image)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func removeStyleSource(sourceId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.removeSource(withId: sourceId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func styleSourceExists(sourceId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let exists = styleManager.sourceExists(withId: sourceId)
        completion(.success(exists))
    }

    func getStyleSources(completion: @escaping (Result<[StyleObjectInfo?], Error>) -> Void) {
        let sourcesInfos = styleManager.allSourceIdentifiers.map {
            StyleObjectInfo(id: $0.id, type: $0.type.rawValue)
        }
        completion(.success(sourcesInfos))
    }

    func setStyleTerrain(properties: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try styleManager.setTerrain(properties: jsonObject as? [String: Any] ?? [:])
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleTerrainProperty(property: String, completion: @escaping (Result<StylePropertyValue, Error>) -> Void) {
        let terrainProperty: MapboxMaps.StylePropertyValue = styleManager.terrainProperty(property)
        completion(.success(terrainProperty.toFLTStylePropertyValue(property: property)))
    }

    func setStyleTerrainProperty(property: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.setTerrainProperty(property, value: value)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func getStyleImage(imageId: String, completion: @escaping (Result<MbxImage?, Error>) -> Void) {
        guard let image = styleManager.image(withId: imageId) else {
            completion(.success(nil))
            return
        }

        let data = FlutterStandardTypedData(bytes: image.pngData()!)

        completion(.success(MbxImage(width: Int64(image.size.width * image.scale),
                                    height: Int64(image.size.height * image.scale),
                                    data: data)))
    }

    func addStyleImage(imageId: String, scale: Double, image: MbxImage, sdf: Bool, stretchX: [ImageStretches?], stretchY: [ImageStretches?], content: ImageContent?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let image = UIImage(data: image.data.data, scale: scale) else {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: "Could not initialize the image from the specified data.", details: nil)))
            return
        }
        var imageContent: MapboxMaps.ImageContent?
        if let content {
            imageContent = MapboxMaps.ImageContent(left: Float(content.left),
                                        top: Float(content.top),
                                        right: Float(content.right),
                                        bottom: Float(content.bottom))
        }
        do {
            try styleManager.addImage(image,
                                         id: imageId,
                                         sdf: sdf,
                                      stretchX: stretchX.compactMap {$0 }.map {
                MapboxMaps.ImageStretches(first: Float($0.first), second: Float($0.second))

            }, stretchY: stretchY.compactMap {$0 }.map {
                MapboxMaps.ImageStretches(first: Float($0.first), second: Float($0.second))},
                                         content: imageContent)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func removeStyleImage(imageId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.removeImage(withId: imageId)
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func hasStyleImage(imageId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let imageExists = styleManager.imageExists(withId: imageId)
        completion(.success(imageExists))
    }

    func invalidateStyleCustomGeometrySourceTile(sourceId: String, tileId: CanonicalTileID, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.invalidateCustomGeometrySourceTile(forSourceId: sourceId,
                                                                   tileId: tileId.toCanonicalTileID())
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func invalidateStyleCustomGeometrySourceRegion(sourceId: String, bounds: CoordinateBounds, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.invalidateCustomGeometrySourceRegion(forSourceId: sourceId,
                                                                     bounds: bounds.toCoordinateBounds())
            completion(.success(()))
        } catch {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: error.localizedDescription, details: nil)))
        }
    }

    func isStyleLoaded(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(styleManager.isStyleLoaded))
    }

    func localizeLabels(locale: String, layerIds: [String]?, completion: @escaping (Result<Void, Error>) -> Void) {
        try! styleManager.localizeLabels(into: Locale(identifier: locale), forLayerIds: layerIds)
        completion(.success(()))
    }

    // MARK: Style Imports

    func getStyleImports() throws -> [StyleObjectInfo?] {
        styleManager.styleImports.map { StyleObjectInfo(id: $0.id, type: $0.type) }
    }

    func removeStyleImport(importId: String) throws {
        do {
            try styleManager.removeStyleImport(withId: importId)
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func getStyleImportSchema(importId: String) throws -> Any {
        do {
            return try styleManager.getStyleImportSchema(for: importId)
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func getStyleImportConfigProperties(importId: String) throws -> [String: StylePropertyValue] {
        do {
            let styleImportsConfig = try styleManager.getStyleImportConfigProperties(for: importId)
            return styleImportsConfig.reduce(into: [:]) { partialResult, pair in
                let (key, value) = pair
                partialResult[key] = value.toFLTStylePropertyValue(property: key)
            }
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func getStyleImportConfigProperty(importId: String, config: String) throws -> StylePropertyValue {
        do {
            let value = try styleManager.getStyleImportConfigProperty(for: importId, config: config)
            return value.toFLTStylePropertyValue(property: config)
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func setStyleImportConfigProperties(importId: String, configs: [String: Any]) throws {
        do {
            try styleManager.setStyleImportConfigProperties(for: importId, configs: configs)
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func setStyleImportConfigProperty(importId: String, config: String, value: Any) throws {
        do {
            try styleManager.setStyleImportConfigProperty(for: importId, config: config, value: value)
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    // MARK: Style Lights

    func getStyleLights() throws -> [StyleObjectInfo?] {
        styleManager.allLightIdentifiers.map {
            StyleObjectInfo(id: $0.id, type: $0.type.rawValue)
        }
    }

    func setLight(flatLight: FlatLight) throws {
        do {
            try styleManager.setLights(MapboxMaps.FlatLight(flatLight))
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func setLights(ambientLight: AmbientLight, directionalLight: DirectionalLight) throws {
        do {
            try styleManager.setLights(ambient: MapboxMaps.AmbientLight(ambientLight), directional: MapboxMaps.DirectionalLight(directionalLight))
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func getStyleLightProperty(id: String, property: String, completion: @escaping (Result<StylePropertyValue, Error>) -> Void) {
        let value = styleManager.lightProperty(for: id, property: property)
        var kind = MapboxMaps.StylePropertyValueKind.constant
        // FIXME: Remove workaround to get property kind one MapboxMaps iOS SDK updates.
        if property.hasSuffix("transition") {
            kind = .transition
        }
        completion(.success(MapboxMaps.StylePropertyValue(value: value, kind: kind).toFLTStylePropertyValue(property: property)))
    }

    func setStyleLightProperty(id: String, property: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try styleManager.setLightProperty(for: id, property: property, value: value)
            completion(.success(()))
        } catch let styleError {
            completion(.failure(FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)))
        }
    }

    // MARK: Style Projection

    func getProjection() throws -> StyleProjection? {
        return styleManager.projection?.toFLTStyleProjection()
    }

    func setProjection(projection: StyleProjection) throws {
        do {
            try styleManager.setProjection(MapboxMaps.StyleProjection(name: MapboxMaps.StyleProjectionName(projection.name)))
        } catch let styleError {
            throw FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    // MARK: Model
    func addStyleModel(modelId: String, modelUri: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(.init(code: StyleController.errorCode, catchingFlutter: {
            try styleManager.addStyleModel(modelId: modelId, modelUri: modelUri)
        }))
    }

    func removeStyleModel(modelId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(.init(code: StyleController.errorCode, catchingFlutter: {
            try styleManager.removeStyleModel(modelId: modelId)
        }))
    }

}
