import Foundation
import MapboxMaps

let COORDINATES = "coordinates"
// FLT to Mapbox
extension FLTMapMemoryBudgetInMegabytes {
    func toMapMemoryBudgetInMegabytes() -> MapMemoryBudgetInMegabytes {
        return MapMemoryBudgetInMegabytes.init(size: size.uint64Value)
    }
}

extension FLTMapMemoryBudgetInTiles {
    func toTMapMemoryBudgetInTiles() -> MapMemoryBudgetInTiles {
        return MapMemoryBudgetInTiles.init(size: size.uint64Value)
    }
}

extension FLTSourceQueryOptions {
    func toSourceQueryOptions() throws -> SourceQueryOptions {
        //        let filterExp =  try JSONDecoder().decode(Expression.self, from: filter.data(using: .utf8)!)
        return SourceQueryOptions(sourceLayerIds: sourceLayerIds, filter: filter)
    }
}
extension FLTRenderedQueryOptions {
    func toRenderedQueryOptions() throws -> RenderedQueryOptions {
        var filterExp: Exp?
        if filter != nil {
            // FIXME - WARNING HERE
            filterExp =  try JSONDecoder().decode(Expression.self, from: filter!.data(using: .utf8)!)
        }
        return RenderedQueryOptions(layerIds: layerIds, filter: filterExp)
    }
}
extension FLTMercatorCoordinate {
    func toMercatorCoordinate() -> MercatorCoordinate {
        return MercatorCoordinate(x: x.doubleValue, y: y.doubleValue)
    }
}
extension FLTProjectedMeters {
    func toProjectedMeters() -> ProjectedMeters {
        return ProjectedMeters(northing: northing.doubleValue, easting: easting.doubleValue)
    }
}
extension FLTMapDebugOptions {
    func toMapDebugOptions() -> MapDebugOptions {
        return MapDebugOptions(rawValue: Int(self.data.rawValue))!
    }
}
extension FLTCameraOptions {
    func toCameraOptions() -> CameraOptions {
        return CameraOptions(center: convertDictionaryToCLLocationCoordinate2D(dict: self.center), padding: self.padding?.toUIEdgeInsets(), anchor: self.anchor?.toCGPoint(), zoom: self.zoom?.CGFloat, bearing: self.bearing?.CLLocationDirection, pitch: self.pitch?.CGFloat)
    }
}

extension FLTCameraBoundsOptions {
    func toCameraBoundsOptions() -> CameraBoundsOptions {
        return CameraBoundsOptions(bounds: self.bounds?.toCoordinateBounds(), maxZoom: self.maxZoom?.CGFloat, minZoom: self.minZoom?.CGFloat, maxPitch: self.maxPitch?.CGFloat, minPitch: self.minPitch?.CGFloat)
    }
}
extension FLTScreenBox {
    func toScreenBox() -> ScreenBox {
        return ScreenBox(min: self.min.toScreenCoordinate(), max: self.max.toScreenCoordinate())
    }

    func toCGRect() -> CGRect {
        return toScreenBox().toCGRect()
    }
}
extension ScreenBox {
    func toCGRect() -> CGRect {
        return CGRect(x: min.x, y: min.y, width: max.x - min.x, height: max.y - min.y)
    }
}
extension FLTScreenCoordinate {
    func toScreenCoordinate() -> ScreenCoordinate {
        return ScreenCoordinate(x: self.x.doubleValue, y: self.y.doubleValue)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x.doubleValue, y: self.y.doubleValue)
    }
}
extension FLTCoordinateBounds {
    func toCoordinateBounds() -> CoordinateBounds {
        let southwest = convertDictionaryToCLLocationCoordinate2D(dict: self.southwest)
        let northeast = convertDictionaryToCLLocationCoordinate2D(dict: self.northeast)
        return CoordinateBounds(southwest: southwest!, northeast: northeast!)
    }
}

extension FLTCanonicalTileID {
    func toCanonicalTileID() -> CanonicalTileID {
        return CanonicalTileID(z: UInt8(truncating: self.z), x: UInt32(truncating: self.x), y: UInt32(truncating: self.y))
    }
}

extension FLTLayerPosition {
    func toLayerPosition() -> LayerPosition {
        var position = LayerPosition.default
        if self.above != nil {position = LayerPosition.above(self.above!)} else if self.below != nil {position = LayerPosition.below(self.below!)} else if self.at != nil {position = LayerPosition.at(Int(truncating: (self.at)!))}
        return position
    }
}

extension FLTTransitionOptions {
    func toTransitionOptions() -> TransitionOptions {
        return TransitionOptions(
            duration: self.duration?.doubleValue,
            delay: self.delay?.doubleValue,
            enablePlacementTransitions: self.enablePlacementTransitions?.boolValue)
    }
}

extension FLTMbxEdgeInsets {
    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top.doubleValue / UIScreen.main.scale,
            left: self.left.doubleValue / UIScreen.main.scale,
            bottom: self.bottom.doubleValue / UIScreen.main.scale,
            right: self.right.doubleValue / UIScreen.main.scale)
    }
}

// Mapbox to FLT
extension Feature {
    func toMap() -> [String: Any] {
        let jsonData = try! JSONEncoder().encode(geoJSONObject)
        let json = String(data: jsonData, encoding: .utf8)

        return convertStringToDictionary(properties: json!)
    }
}
extension FeatureExtensionValue {
    func toFLTFeatureExtensionValue() -> FLTFeatureExtensionValue {
        let featureCollection = features?.map({$0.toMap()})
        var resultValue: String?
        if value != nil {resultValue = String(describing: value!)}
        return FLTFeatureExtensionValue.make(withValue: resultValue, featureCollection: featureCollection)
    }
}
extension QueriedFeature {
    func toFLTQueriedFeature() -> FLTQueriedFeature {
        let stateString = convertDictionaryToString(dict: state as? [String: Any])
        return FLTQueriedFeature.make(withFeature: feature.toMap(), source: source, sourceLayer: sourceLayer, state: stateString)
    }
}
extension MercatorCoordinate {
    func toFLTMercatorCoordinate() -> FLTMercatorCoordinate {
        return FLTMercatorCoordinate.makeWith(x: NSNumber(value: x), y: NSNumber(value: y))
    }
}
extension ResourceOptions {
    func toFLTResourceOptions() -> FLTResourceOptions {
        let data = FLTTileStoreUsageMode(rawValue: UInt(self.tileStoreUsageMode.rawValue))
        return FLTResourceOptions.make(withAccessToken: self.accessToken, baseURL: self.baseURL?.absoluteString, dataPath: self.dataPathURL?.absoluteString, assetPath: self.assetPathURL?.absoluteString, tileStoreUsageMode: data!)
    }
}
extension MapDebugOptions {
    func toFLTMapDebugOptions() -> FLTMapDebugOptions {
        let data = FLTMapDebugOptionsData(rawValue: UInt(self.rawValue))!
        return FLTMapDebugOptions.make(with: data)
    }
}

extension CGSize {
    func toFLTSize() -> FLTSize {
        return FLTSize.make(withWidth: NSNumber(value: self.width), height: NSNumber(value: self.height))
    }
}
extension GlyphsRasterizationOptions {
    func toFLTGlyphsRasterizationOptions() -> FLTGlyphsRasterizationOptions {
        let mode = FLTGlyphsRasterizationMode(rawValue: UInt(self.rasterizationMode.rawValue))
        return FLTGlyphsRasterizationOptions.make(with: mode!, fontFamily: self.fontFamily)
    }
}
extension MapOptions {
    func toFLTMapOptions() -> FLTMapOptions {
        return FLTMapOptions.make(with: .SHARED, constrainMode: .NONE, viewportMode: .DEFAULT, orientation: .UPWARDS, crossSourceCollisions: NSNumber(value: self.crossSourceCollisions), optimizeForTerrain: NSNumber(value: self.optimizeForTerrain), size: self.size?.toFLTSize(), pixelRatio: NSNumber(value: self.pixelRatio), glyphsRasterizationOptions: self.glyphsRasterizationOptions?.toFLTGlyphsRasterizationOptions())
    }
}
extension CameraBounds {
    func toFLTCameraBounds() -> FLTCameraBounds {
        return FLTCameraBounds.make(with: self.bounds.toFLTCoordinateBounds(), maxZoom: NSNumber(value: self.maxZoom), minZoom: NSNumber(value: self.minZoom), maxPitch: NSNumber(value: self.maxPitch), minPitch: NSNumber(value: self.minPitch))
    }
}
extension CGPoint {
    func toFLTScreenCoordinate() -> FLTScreenCoordinate {
        return FLTScreenCoordinate.makeWith(x: NSNumber(value: self.x), y: NSNumber(value: self.y))
    }
}
extension CoordinateBoundsZoom {
    func toFLTCoordinateBoundsZoom() -> FLTCoordinateBoundsZoom {
        return FLTCoordinateBoundsZoom.make(with: self.bounds.toFLTCoordinateBounds(), zoom: NSNumber(value: self.zoom))
    }
}
extension CoordinateBounds {
    func toFLTCoordinateBounds() -> FLTCoordinateBounds {
        return FLTCoordinateBounds.make(withSouthwest: self.southwest.toDict(), northeast: self.northeast.toDict(), infiniteBounds: NSNumber(value: self.isInfiniteBounds))
    }
}
extension CameraOptions {
    func toFLTCameraOptions() -> FLTCameraOptions {
        let center = self.center != nil ? self.center?.toDict(): nil
        let padding = self.padding != nil ? FLTMbxEdgeInsets.make(
            withTop: NSNumber(value: self.padding!.top * UIScreen.main.scale),
            left: NSNumber(value: self.padding!.left * UIScreen.main.scale),
            bottom: NSNumber(value: self.padding!.bottom * UIScreen.main.scale),
            right: NSNumber(value: self.padding!.right * UIScreen.main.scale)) : nil

        let anchor = self.anchor != nil ? FLTScreenCoordinate.makeWith(x: self.anchor!.x as NSNumber, y: self.anchor!.y as NSNumber) : nil
        let zoom = self.zoom != nil ? NSNumber(value: self.zoom!) : nil
        let bearing = self.bearing != nil ? NSNumber(value: self.bearing!) : nil
        let pitch = self.pitch != nil ? NSNumber(value: self.pitch!) : nil

        return FLTCameraOptions.make(withCenter: center, padding: padding, anchor: anchor, zoom: zoom, bearing: bearing, pitch: pitch)
    }
}
extension TransitionOptions {
    func toFLTTransitionOptions() -> FLTTransitionOptions {
        let duration = self.duration != nil ? NSNumber(value: Int(self.duration!)) : nil
        let delay = self.delay != nil ? NSNumber(value: Int(self.delay!)) : nil
        let enablePlacementTransitions = self.enablePlacementTransitions != nil ? NSNumber(value: self.enablePlacementTransitions!) : nil

        return FLTTransitionOptions.make(withDuration: duration, delay: delay, enablePlacementTransitions: enablePlacementTransitions)
    }
}
extension StylePropertyValue {
    func toFLTStylePropertyValue(property: String) -> FLTStylePropertyValue {
        let data = FLTStylePropertyValueKind(rawValue: UInt(self.kind.rawValue))!
        if property == "tiles" || property == "bounds" || property == "clusterProperties" {
            let valueData = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
            return FLTStylePropertyValue.make(withValue: String(data: valueData!, encoding: .utf8)!, kind: data)
        } else {
            return FLTStylePropertyValue.make(withValue: String(describing: self.value), kind: data)
        }
    }
}

extension Point {
    func toMap() -> [String: Any] {
        return [COORDINATES: [coordinates.longitude, coordinates.latitude]]
    }
}
extension LineString {
    func toMap() -> [String: Any] {
        return [COORDINATES: coordinates.map({[$0.longitude, $0.latitude]})]
    }
}
extension Polygon {
    func toMap() -> [String: Any] {
        return [COORDINATES: coordinates.map({$0.map {[$0.longitude, $0.latitude]}})]
    }
}
extension CLLocationCoordinate2D {
    func toDict() -> [String: Any] {
        return [COORDINATES: [self.longitude, self.latitude]]
    }

    func toFLTScreenCoordinate() -> FLTScreenCoordinate {
        return FLTScreenCoordinate.makeWith(x: NSNumber(value: self.longitude), y: NSNumber(value: self.latitude))
    }
}

func convertDictionaryToCLLocationCoordinate2D(dict: [String: Any]?) -> CLLocationCoordinate2D? {
    if dict == nil { return nil}
    let coordinates = dict![COORDINATES] as? [Any]

    return CLLocationCoordinate2D(latitude: coordinates?.last as? CLLocationDegrees ?? 0, longitude: coordinates?.first as? CLLocationDegrees ?? 0)
}

func convertDictionaryToPolygon(dict: [String: Any]) -> Polygon {
    let coordinates = dict[COORDINATES] as? [[[CLLocationDegrees]]]
    let coordinatesList = coordinates.map({$0.map({$0.map({CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)})})})!

    return Polygon(coordinatesList)
}

func convertDictionaryToPolyline(dict: [String: Any]) -> LineString {
    let coordinates = dict[COORDINATES] as? [[CLLocationDegrees]]

    let coordinatesList = coordinates.map({$0.map({CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)})})!
    return LineString(coordinatesList)
}

func convertDictionaryToCGPoint(dict: [String: Any]?) -> CGPoint? {
    if dict == nil { return nil}
    let coordinates = dict![COORDINATES] as? [Any]
    return CGPoint(x: coordinates![0] as? CGFloat ?? 0, y: coordinates![1] as? CGFloat ?? 0)
}

func convertStringToDictionary(properties: String) -> [String: Any] {
    let data = properties.data(using: String.Encoding.utf8)!
    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])

    guard let result = jsonObject as? [String: Any] else {return [:]}
    return result
}

func convertDictionaryToString(dict: [String: Any]?) -> String {
    var result: String = ""
    if dict == nil { return result }
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))

        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            result = JSONString
        }
    } catch {
        result = ""
    }
    return result
}

func convertDictionaryToGeometry(dict: [String: Any]?) -> Geometry? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let geometry = try JSONDecoder().decode(Geometry.self, from: jsonData)
        return geometry
    } catch {
        return nil
    }
}

func convertDictionaryToFeature(dict: [String: Any]) -> Feature? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let feature = try JSONDecoder().decode(Feature.self, from: jsonData)
        return feature
    } catch {
        return nil
    }
}

func uiColorFromHex(rgbValue: Int) -> UIColor {

    // &  binary AND operator to zero out other color values
    // >>  bitwise right shift operator
    // Divide by 0xFF because UIColor takes CGFloats between 0.0 and 1.0

    let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
    let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
    let alpha = CGFloat((rgbValue & 0xFF000000) >> 24) / 0xFF

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

func toRgb(alpha: Int, red: Int, green: Int, blue: Int) -> Int {
    // Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue
    return (alpha << 24) + (red << 16) + (green << 8) + blue
}

extension StyleColor {
    func rgb() -> Int {
        return toRgb(
            alpha: Int(self.alpha * 255),
            red: Int(self.red),
            green: Int(self.green),
            blue: Int(self.blue)
        )
    }
}

extension UIColor {
    func rgb() -> Int {
         var fRed: CGFloat = 0
         var fGreen: CGFloat = 0
         var fBlue: CGFloat = 0
         var fAlpha: CGFloat = 0
         if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return toRgb(
                alpha: Int(fAlpha * 255.0),
                red: Int(fRed * 255.0),
                green: Int(fGreen * 255.0),
                blue: Int(fBlue * 255.0)
            )
         } else {
             // Could not extract RGBA components: return 0
             return 0
         }
     }
}
