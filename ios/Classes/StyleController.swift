import Foundation
import MapboxMaps
import UIKit

class StyleController: NSObject, FLTStyleManager {

    private var mapboxMap: MapboxMap
    init(withMapboxMap mapboxMap: MapboxMap) {
        self.mapboxMap = mapboxMap
    }
    func getStyleURI(completion: @escaping (String?, FlutterError?) -> Void) {
        completion(mapboxMap.style.uri?.rawValue, nil)
    }

    func setStyleURIUri(_ uri: String, completion: @escaping (FlutterError?) -> Void) {
        mapboxMap.style.uri = StyleURI(rawValue: uri)
        completion(nil)
    }

    func getStyleJSON(completion: @escaping (String?, FlutterError?) -> Void) {
        completion(mapboxMap.style.JSON, nil)
    }

    func setStyleJSONJson(_ json: String, completion: @escaping (FlutterError?) -> Void) {
        mapboxMap.style.JSON = json
        completion(nil)
    }

    func getStyleDefaultCamera(completion: @escaping (FLTCameraOptions?, FlutterError?) -> Void) {
        let camera = mapboxMap.style.defaultCamera
        completion(camera.toFLTCameraOptions(), nil)
    }

    func getStyleTransition(completion: @escaping (FLTTransitionOptions?, FlutterError?) -> Void) {
        let transition = mapboxMap.style.transition
        completion(transition.toFLTTransitionOptions(), nil)

    }

    func setStyleTransitionTransitionOptions(_ transitionOptions: FLTTransitionOptions,
                                             completion: @escaping (FlutterError?) -> Void) {
        mapboxMap.style.transition = transitionOptions.toTransitionOptions()
        completion(nil)
    }

    func addStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                 completion: @escaping (FlutterError?) -> Void) {
        do {
            let layerProperties: [String: Any] = convertStringToDictionary(properties: properties)
            try mapboxMap.style.addLayer(with: layerProperties, layerPosition: layerPosition?.toLayerPosition())
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addPersistentStyleLayerProperties(_ properties: String, layerPosition: FLTLayerPosition?,
                                           completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style
                .addPersistentLayer(
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
            let isPersistent = try mapboxMap.style.isPersistentLayer(id: layerId)
            completion(NSNumber(value: isPersistent), nil)
        } catch {
            completion(nil, FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func removeStyleLayerLayerId(_ layerId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.removeLayer(withId: layerId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func moveStyleLayerLayerId(_ layerId: String, layerPosition: FLTLayerPosition?,
                               completion: @escaping (FlutterError?) -> Void) {
        do {
            if layerPosition != nil {
                try mapboxMap.style.moveLayer(withId: layerId, to: layerPosition!.toLayerPosition())
            } else {
                try mapboxMap.style.moveLayer(withId: layerId, to: LayerPosition.default)
            }
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleLayerExistsLayerId(_ layerId: String,
                                 completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let existes = mapboxMap.style.layerExists(withId: layerId)
        completion(NSNumber(value: existes), nil)
    }

    func getStyleLayers(completion: @escaping ([FLTStyleObjectInfo]?, FlutterError?) -> Void) {
        let layerInfos = mapboxMap.style.allLayerIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        completion(layerInfos, nil)
    }

    func getStyleLayerPropertyLayerId(_ layerId: String,
                                      property: String,
                                      completion: @escaping (FLTStylePropertyValue?,
                                                             FlutterError?) -> Void) {
        let layerProperty = mapboxMap.style.layerProperty(for: layerId, property: property)
        completion(layerProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleLayerPropertyLayerId(_ layerId: String,
                                      property: String,
                                      value: Any,
                                      completion: @escaping (FlutterError?) -> Void) {
        do {
            var mappedValue = value
            if let stringValue = value as? String {
                if (stringValue.hasPrefix("[") || stringValue.hasPrefix("{")) {
                    if let expressionData = stringValue.data(using: .utf8) {
                        let expJSONObject = try JSONSerialization.jsonObject(with: expressionData, options: [])
                        mappedValue = expJSONObject
                    }
                }
            }
            try mapboxMap.style.setLayerProperty(for: layerId, property: property, value: mappedValue)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLayerPropertiesLayerId(_ layerId: String,
                                        completion: @escaping (String?, FlutterError?) -> Void) {
        do {
            let properties = try mapboxMap.style.layerProperties(for: layerId)
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
            try mapboxMap.style.setLayerProperties(for: layerId, properties: jsonObject as? [String: Any] ?? [:])
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func addStyleSourceSourceId(_ sourceId: String, properties: String,
                                completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.addSource(withId: sourceId,
                                          properties: convertStringToDictionary(properties: properties))
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertySourceId(_ sourceId: String, property: String,
                                        completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let sourceProperty = mapboxMap.style.sourceProperty(for: sourceId, property: property)
        completion(sourceProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleSourcePropertySourceId(_ sourceId: String, property: String,
                                        value: Any, completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.setSourceProperty(for: sourceId, property: property, value: value)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleSourcePropertiesSourceId(_ sourceId: String,
                                          completion: @escaping (String?, FlutterError?) -> Void) {
        do {
            let properties = try mapboxMap.style.sourceProperties(for: sourceId)
            completion(convertDictionaryToString(dict: properties), nil)
        } catch {
            completion(nil, FlutterError(code: "\(error)", message: nil, details: nil))
        }
    }

    func setStyleSourcePropertiesSourceId(_ sourceId: String, properties: String,
                                          completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.setSourceProperties(for: sourceId,
                                                       properties: convertStringToDictionary(properties: properties))
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func updateStyleImageSourceImageSourceId(_ sourceId: String, image: FLTMbxImage,
                                             completion: @escaping (FlutterError?) -> Void) {
        guard let image = UIImage(data: image.data.data, scale: UIScreen.main.scale) else { return }
        do {
            try mapboxMap.style.updateImageSource(withId: sourceId, image: image)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleSourceSourceId(_ sourceId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.removeSource(withId: sourceId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func styleSourceExistsSourceId(_ sourceId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let existes = mapboxMap.style.sourceExists(withId: sourceId)
        completion(NSNumber(value: existes), nil)
    }

    func getStyleSources(completion: @escaping ([FLTStyleObjectInfo]?, FlutterError?) -> Void) {
        let sourcesInfos = mapboxMap.style.allSourceIdentifiers.map {
            FLTStyleObjectInfo.make(withId: $0.id as String, type: $0.type.rawValue)
        }
        completion(sourcesInfos, nil)
    }

    func setStyleLightProperties(_ properties: String, completion: @escaping (FlutterError?) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setLight(properties: jsonObject as? [String: Any] ?? [:])
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleLightPropertyProperty(_ property: String,
                                       completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let lightProperty: StylePropertyValue = mapboxMap.style.lightProperty(property)
        completion(lightProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleLightPropertyProperty(_ property: String, value: Any,
                                       completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.setLightProperty(property, value: value)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func setStyleTerrainProperties(_ properties: String, completion: @escaping (FlutterError?) -> Void) {
        let data = properties.data(using: String.Encoding.utf8)!
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        do {
            try mapboxMap.style.setTerrain(properties: jsonObject as? [String: Any] ?? [:])
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleTerrainPropertyProperty(_ property: String,
                                         completion: @escaping (FLTStylePropertyValue?, FlutterError?) -> Void) {
        let terrainProperty: StylePropertyValue = mapboxMap.style.terrainProperty(property)
        completion(terrainProperty.toFLTStylePropertyValue(property: property), nil)
    }

    func setStyleTerrainPropertyProperty(_ property: String, value: Any,
                                         completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.setTerrainProperty(property, value: value)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func getStyleImageImageId(_ imageId: String, completion: @escaping (FLTMbxImage?, FlutterError?) -> Void) {
        guard let image = mapboxMap.style.image(withId: imageId) else {
            completion(nil, nil)
            return
        }

        let data = FlutterStandardTypedData(bytes: image.pngData()!)

        completion(FLTMbxImage.make(withWidth: NSNumber(value: Int(image.size.width * image.scale)),
                                    height: NSNumber(value: Int(image.size.height * image.scale)),
                                    data: data), nil)
    }

    func addStyleImageImageId(_ imageId: String, scale: NSNumber,
                              image: FLTMbxImage, sdf: NSNumber,
                              stretchX: [FLTImageStretches],
                              stretchY: [FLTImageStretches],
                              content: FLTImageContent?,
                              completion: @escaping (FlutterError?) -> Void) {

        guard let image = UIImage(data: image.data.data, scale: CGFloat(truncating: scale)) else { return }
        var imageContent: ImageContent?
        if content != nil {
            imageContent = ImageContent(left: Float(truncating: content!.left),
                                        top: Float(truncating: content!.top),
                                        right: Float(truncating: content!.right),
                                        bottom: Float(truncating: content!.bottom))
        }
        do {
            try mapboxMap.style.addImage(image,
                                         id: imageId,
                                         sdf: sdf as? Bool ?? false,
                                         stretchX: stretchX.map {
                ImageStretches(first: Float(truncating: $0.first), second: Float(truncating: $0.second))

            }, stretchY: stretchY.map {
                ImageStretches(first: Float(truncating: $0.first), second: Float(truncating: $0.second))},
                                         content: imageContent)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func removeStyleImageImageId(_ imageId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            try mapboxMap.style.removeImage(withId: imageId)
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func hasStyleImageImageId(_ imageId: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let image = mapboxMap.style.image(withId: imageId)
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
            try mapboxMap.style.invalidateCustomGeometrySourceTile(forSourceId: sourceId,
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
            try mapboxMap.style.invalidateCustomGeometrySourceRegion(forSourceId: sourceId,
                                                                     bounds: bounds.toCoordinateBounds())
            completion(nil)
        } catch {
            completion(FlutterError(code: StyleController.errorCode, message: "\(error)", details: nil))
        }
    }

    func isStyleLoaded(completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        completion(NSNumber(value: (mapboxMap.style.isLoaded)), nil)
    }

    func getProjectionWithCompletion(_ completion: @escaping (String?, FlutterError?) -> Void) {
        completion(mapboxMap.style.projection.name.rawValue, nil)
    }

    func setProjectionProjection(_ projection: String, completion: @escaping (FlutterError?) -> Void) {
        try! mapboxMap.style.setProjection(projection == "globe" ? StyleProjection(name: StyleProjectionName.globe) : StyleProjection(name: StyleProjectionName.mercator))
        completion(nil)
    }

    func localizeLabelsLocale(_ locale: String, layerIds: [String]?, completion: @escaping (FlutterError?) -> Void) {
        try! mapboxMap.style.localizeLabels(into: Locale(identifier: locale), forLayerIds: layerIds)
        completion(nil)
    }

    private static let errorCode = "0"
}
