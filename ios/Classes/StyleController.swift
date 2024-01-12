@_spi(Experimental) import MapboxMaps
import UIKit

final class StyleController: NSObject, FLTStyleManager {

    // MARK: -
    private let styleManager: StyleManager
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
    }
    func getStyleURI(completion: @escaping (String?, FlutterError?) -> Void) {
        completion(styleManager.styleURI?.rawValue, nil)
    }

    func setStyleURIUri(_ uri: String, completion: @escaping (FlutterError?) -> Void) {
        guard let styleURI = StyleURI(rawValue: uri) else {
            completion(FlutterError(code: StyleController.errorCode, message: "Invalid style uri", details: nil))
            return
        }
        styleManager.load(mapStyle: MapStyle(uri: styleURI)) { error in
            completion(error.map { FlutterError(code: StyleController.errorCode, message: $0.localizedDescription, details: $0) })
        }
    }

    func getStyleJSON(completion: @escaping (String?, FlutterError?) -> Void) {
        completion(styleManager.styleJSON, nil)
    }

    func setStyleJSONJson(_ json: String, completion: @escaping (FlutterError?) -> Void) {
        styleManager.load(mapStyle: MapStyle(json: json)) { error in
            completion(error.map { FlutterError(code: StyleController.errorCode, message: $0.localizedDescription, details: $0) })
        }
    }

    func getStyleDefaultCamera(completion: @escaping (FLTCameraOptions?, FlutterError?) -> Void) {
        let camera = styleManager.styleDefaultCamera
        completion(camera.toFLTCameraOptions(), nil)
    }

    func getStyleTransition(completion: @escaping (FLTTransitionOptions?, FlutterError?) -> Void) {
        let transition = styleManager.styleTransition
        completion(transition.toFLTTransitionOptions(), nil)

    }

    func setStyleTransitionTransitionOptions(_ transitionOptions: FLTTransitionOptions,
                                             completion: @escaping (FlutterError?) -> Void) {
        styleManager.styleTransition = transitionOptions.toTransitionOptions()
        completion(nil)
    }

    func addStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                 completion: @escaping (FlutterError?) -> Void) {
        do {
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            try styleManager.addLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addPersistentStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                           completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.addPersistentLayer(
                with: convertStringToDictionary(properties: properties),
                layerPosition: layerPosition?.toLayerPosition()
            )
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLayerPersistentLayerId(_ layerId: String,
                                       completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        do {
            let isPersistent = try styleManager.isPersistentLayer(id: layerId)
            completion(NSNumber(value: isPersistent), nil)
        } catch {
            completion(nil, FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func removeStyleLayerLayerId(_ layerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.removeLayer(withId: layerId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func moveStyleLayerLayerId(_ layerId: String, layerPosition: FLTLayerPosition?,
                               completion: @escaping (FlutterError?) -> Void) {
        do {
            if layerPosition != nil {
                try styleManager.moveLayer(withId: layerId, to: layerPosition!.toLayerPosition())
            } else {
                try styleManager.moveLayer(withId: layerId, to: LayerPosition.default)
            }
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleLayerExistsLayerId(_ layerId: String,
                                 completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let existes = styleManager.layerExists(withId: layerId)
        completion(NSNumber(value: existes), nil)
    }

    func getStyleLayers(completion: @escaping ([FLTStyleObjectInfo]?, FlutterError?) -> Void) {
        let layerInfos = styleManager.allLayerIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        completion(layerInfos, nil)
    }

    func getStyleLayerPropertyLayerId(_ layerId: String,
                                      property: String,
                                      completion: @escaping (FLTStylePropertyValue?,
                                                             FlutterError?) -> Void) {
        let layerProperty = styleManager.layerProperty(for: layerId, property: property)
        completion(layerProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleLayerPropertyLayerId(_ layerId: String,
                                      property: String,
                                      value: Any,
                                      completion: @escaping (FlutterError?) -> Void) {
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
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLayerPropertiesLayerId(_ layerId: String,
                                        completion: @escaping (String?, FlutterError?) -> Void) {
        do {
            let properties = try styleManager.layerProperties(for: layerId)
            completion(convertDictionaryToString(dict: properties), nil)
        } catch {
            completion(nil, FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleLayerPropertiesLayerId(_ layerId: String, properties: String,
                                        completion: @escaping (FlutterError?) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try styleManager.setLayerProperties(for: layerId, properties: jsonObject as? [String: Any] ?? [:])
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addStyleSourceSourceId(_ sourceId: String, properties: String,
                                completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.addSource(withId: sourceId,
                                          properties: convertStringToDictionary(properties: properties))
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertySourceId(_ sourceId: String, property: String,
                                        completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let sourceProperty = styleManager.sourceProperty(for: sourceId, property: property)
        completion(sourceProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleSourcePropertySourceId(_ sourceId: String, property: String,
                                        value: Any, completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.setSourceProperty(for: sourceId, property: property, value: value)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertiesSourceId(_ sourceId: String,
                                          completion: @escaping (String?, FlutterError?) -> Void) {
        do {
            let properties = try styleManager.sourceProperties(for: sourceId)
            completion(convertDictionaryToString(dict: properties), nil)
        } catch {
            completion(nil, FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleSourcePropertiesSourceId(_ sourceId: String, properties: String,
                                          completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.setSourceProperties(for: sourceId, properties: convertStringToDictionary(properties: properties))
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func updateStyleImageSourceImageSourceId(_ sourceId: String, image: FLTMbxImage,
                                             completion: @escaping (FlutterError?) -> Void) {
        guard let image = UIImage(data: image.data.data, scale: UIScreen.main.scale) else { return }
        do {
            try styleManager.updateImageSource(withId: sourceId, image: image)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleSourceSourceId(_ sourceId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.removeSource(withId: sourceId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleSourceExistsSourceId(_ sourceId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let existes = styleManager.sourceExists(withId: sourceId)
        completion(NSNumber(value: existes), nil)
    }

    func getStyleSources(completion: @escaping ([FLTStyleObjectInfo]?, FlutterError?) -> Void) {
        let sourcesInfos = styleManager.allSourceIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        completion(sourcesInfos, nil)
    }

    func setStyleTerrainProperties(_ properties: String, completion: @escaping (FlutterError?) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try styleManager.setTerrain(properties: jsonObject as? [String: Any] ?? [:])
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleTerrainPropertyProperty(_ property: String,
                                         completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let terrainProperty: StylePropertyValue = styleManager.terrainProperty(property)
        completion(terrainProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleTerrainPropertyProperty(_ property: String, value: Any,
                                         completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.setTerrainProperty(property, value: value)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleImageImageId(_ imageId: String, completion: @escaping (FLTMbxImage?, FlutterError?) -> Void) {
        guard let image = styleManager.image(withId: imageId) else {
            completion(nil, nil)
            return
        }

        let data = FlutterStandardTypedData(bytes: image.pngData()!)

        completion(FLTMbxImage.make(withWidth: Int(image.size.width * image.scale),
                                    height: Int(image.size.height * image.scale),
                                    data: data), nil)
    }

    func addStyleImageImageId(_ imageId: String, scale: Double,
                              image: FLTMbxImage, sdf: Bool,
                              stretchX: [FLTImageStretches],
                              stretchY: [FLTImageStretches],
                              content: FLTImageContent?,
                              completion: @escaping (FlutterError?) -> Void) {

        guard let image = UIImage(data: image.data.data, scale: scale) else { return }
        var imageContent: ImageContent?
        if let content {
            imageContent = ImageContent(left: Float(content.left),
                                        top: Float(content.top),
                                        right: Float(content.right),
                                        bottom: Float(content.bottom))
        }
        do {
            try styleManager.addImage(image,
                                         id: imageId,
                                         sdf: sdf,
                                         stretchX: stretchX.map {
                ImageStretches(first: Float($0.first), second: Float($0.second))

            }, stretchY: stretchY.map {
                ImageStretches(first: Float($0.first), second: Float($0.second))},
                                         content: imageContent)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleImageImageId(_ imageId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.removeImage(withId: imageId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func hasStyleImageImageId(_ imageId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let image = styleManager.image(withId: imageId)
        completion(NSNumber(value: image != nil), nil)
    }
//
//    func setStyleCustomGeometrySourceTileDataSourceId(_ sourceId: String,
//                                                      tileId: FLTCanonicalTileID,
//                                                      featureCollection: String,
//                                                      completion: @escaping (FlutterError?) -> Void) {
//        do {
//            let features = try JSONDecoder().decode(FeatureCollection.self,
//                                                    from: featureCollection.data(using: String.Encoding.utf8)!)
//
//            let tileID = CanonicalTileID(z: UInt8(truncating: tileId.z),
//                                         x: UInt32(truncating: tileId.x),
//                                         y: UInt32(truncating: tileId.y)
//                                         try mapboxMap.style.setCustomGeometrySourceTileData(forSourceId: sourceId,
//                                                                                             tileId: tileID),
//                                         features: features.features)
//            completion(nil)
//        } catch {
//            completion(FlutterError(code: StyleController.errorCode , message: "\(error)", details: nil))
//        }
//    }

    func invalidateStyleCustomGeometrySourceTileSourceId(_ sourceId: String,
                                                         tileId: FLTCanonicalTileID,
                                                         completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.invalidateCustomGeometrySourceTile(forSourceId: sourceId,
                                                                   tileId: tileId.toCanonicalTileID())
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func invalidateStyleCustomGeometrySourceRegionSourceId(_ sourceId: String,
                                                           bounds: FLTCoordinateBounds,
                                                           completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.invalidateCustomGeometrySourceRegion(forSourceId: sourceId,
                                                                     bounds: bounds.toCoordinateBounds())
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLoaded(completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        completion(NSNumber(value: (styleManager.isStyleLoaded)), nil)
    }

    func localizeLabelsLocale(_ locale: String, layerIds: [String]?, completion: @escaping (FlutterError?) -> Void) {
        try! styleManager.localizeLabels(into: Locale(identifier: locale), forLayerIds: layerIds)
        completion(nil)
    }

    private static let errorCode = "0"

    // MARK: Style Imports

    func getStyleImportsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [FLTStyleObjectInfo]? {
        styleManager.styleImports.map { FLTStyleObjectInfo.make(withId: $0.id, type: $0.type) }
    }

    func removeStyleImportImportId(_ importId: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.removeStyleImport(for: importId)
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func getStyleImportSchemaImportId(_ importId: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> Any? {
        do {
            return try styleManager.getStyleImportSchema(for: importId)
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
            return nil
        }
    }

    func getStyleImportConfigPropertiesImportId(_ importId: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: FLTStylePropertyValue]? {
        do {
            let styleImportsConfig = try styleManager.getStyleImportConfigProperties(for: importId)
            return styleImportsConfig.reduce(into: [:]) { partialResult, pair in
                let (key, value) = pair
                partialResult[key] = value.toFLTStylePropertyValue(property: key)
            }
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
            return nil
        }
    }

    func getStyleImportConfigPropertyImportId(_ importId: String, config: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTStylePropertyValue? {
        do {
            let value = try styleManager.getStyleImportConfigProperty(for: importId, config: config)
            return value.toFLTStylePropertyValue(property: config)
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
            return nil
        }
    }

    func setStyleImportConfigPropertiesImportId(_ importId: String, configs: [String: Any], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.setStyleImportConfigProperties(for: importId, configs: configs)
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    func setStyleImportConfigPropertyImportId(_ importId: String, config: String, value: Any, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.setStyleImportConfigProperty(for: importId, config: config, value: value)
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }

    // MARK: Style Lights

    func getStyleLightsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [FLTStyleObjectInfo]? {
        styleManager.allLightIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id, type: $0.type.rawValue)
        }
    }

    func setLightFlatLight(_ flatLight: FLTFlatLight, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.setLights(FlatLight(flatLight))
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: error)
        }
    }

    func setLightsAmbientLight(_ ambientLight: FLTAmbientLight, directionalLight: FLTDirectionalLight, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.setLights(ambient: AmbientLight(ambientLight), directional: DirectionalLight(directionalLight))
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: error)
        }
    }

    func getStyleLightPropertyId(_ id: String, property: String, completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let value = styleManager.lightProperty(for: id, property: property)
        var kind = StylePropertyValueKind.constant
        // FIXME: Remove workaround to get property kind one MapboxMaps iOS SDK updates.
        if property.hasSuffix("transition") {
            kind = .transition
        }
        completion(StylePropertyValue(value: value, kind: kind).toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleLightPropertyId(_ id: String, property: String, value: Any, completion: @escaping (FlutterError?) -> Void) {
        do {
            try styleManager.setLightProperty(for: id, property: property, value: value)
            completion(nil)
        } catch let styleError {
            completion(FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil))
        }
    }

    // MARK: Style Projection

    func getProjectionWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTStyleProjection? {
        guard let projection = styleManager.projection else { return nil }
        return projection.toFLTStyleProjection()
    }

    func setProjectionProjection(_ projection: FLTStyleProjection, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try styleManager.setProjection(StyleProjection(name: StyleProjectionName(projection.name)))
        } catch let styleError {
            error.pointee = FlutterError(code: StyleController.errorCode, message: styleError.localizedDescription, details: nil)
        }
    }
}
