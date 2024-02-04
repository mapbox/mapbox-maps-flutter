import Foundation
import MapboxMaps
import MapboxCoreMaps_Private

let COORDINATES = "coordinates"

// FLT to Mapbox

extension FLTViewportMode {
    func toViewportMode() -> ViewportMode {
        switch self {
        case .DEFAULT: return .default
        case .FLIPPED_Y: return .flippedY
        @unknown default: return .default
        }
    }
}

extension FLTConstrainMode {
    func toConstrainMode() -> ConstrainMode {
        switch self {
        case .NONE: return .none
        case .HEIGHT_ONLY: return .heightOnly
        case .WIDTH_AND_HEIGHT: return .widthAndHeight
        @unknown default: return .none
        }
    }
}

extension FLTNorthOrientation {
    func toNorthOrientation() -> NorthOrientation {
        switch self {
        case .UPWARDS: return .upwards
        case .RIGHTWARDS: return .rightwards
        case .DOWNWARDS: return .downwards
        case .LEFTWARDS: return .leftwards
        @unknown default: return .upwards
        }
    }
}

extension FLTTileCacheBudgetInMegabytes {
    func toTileCacheBudgetInMegabytes() -> TileCacheBudgetInMegabytes {
        return .init(size: UInt64(size))
    }
}

extension FLTTileCacheBudgetInTiles {
    func toTileCacheBudgetInTiles() -> TileCacheBudgetInTiles {
        return .init(size: UInt64(size))
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
        return MercatorCoordinate(x: x, y: y)
    }
}
extension FLTProjectedMeters {
    func toProjectedMeters() -> ProjectedMeters {
        return ProjectedMeters(northing: northing, easting: easting)
    }
}
extension FLTMapDebugOptions {
    func toMapDebugOptions() -> MapDebugOptions {
        return MapDebugOptions(rawValue: Int(self.data.rawValue))!
    }
}
extension FLTCameraOptions {
    func toCameraOptions() -> MapboxMaps.CameraOptions {
        return CameraOptions(center: convertDictionaryToCLLocationCoordinate2D(dict: self.center), padding: self.padding?.toUIEdgeInsets(), anchor: self.anchor?.toCGPoint(), zoom: self.zoom?.CGFloat, bearing: self.bearing?.CLLocationDirection, pitch: self.pitch?.CGFloat)
    }
}

extension FLTCameraBoundsOptions {
    func toCameraBoundsOptions() -> MapboxMaps.CameraBoundsOptions {
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
        return ScreenCoordinate(x: self.x, y: self.y)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
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
        return CanonicalTileID(z: UInt8(z), x: UInt32(x), y: UInt32(y))
    }
}

extension FLTLayerPosition {
    func toLayerPosition() -> MapboxMaps.LayerPosition {
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

    func toStyleTransition() -> StyleTransition {
        return StyleTransition(
            duration: self.duration.map { $0.doubleValue / 1000.0 } ?? 0,
            delay: self.delay.map { $0.doubleValue / 1000.0 } ?? 0)
    }
}

extension FLTMbxEdgeInsets {
    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top,
            left: self.left,
            bottom: self.bottom,
            right: self.right)
    }
}

// Mapbox to FLT

extension ConstrainMode {
    func toFLTConstrainMode() -> FLTConstrainMode {
        switch self {
        case .heightOnly: return .HEIGHT_ONLY
        case .widthAndHeight: return .WIDTH_AND_HEIGHT
        case .none: return .NONE
        @unknown default: return .NONE
        }
    }
}

extension ViewportMode {
    func toFLTViewportMode() -> FLTViewportMode {
        switch self {
        case .default: return .DEFAULT
        case .flippedY: return .FLIPPED_Y
        @unknown default: return .DEFAULT
        }
    }
}

extension NorthOrientation {
    func toFLTNorthOrientation() -> FLTNorthOrientation {
        switch self {
        case .upwards: return .UPWARDS
        case .leftwards: return .LEFTWARDS
        case .rightwards: return .RIGHTWARDS
        case .downwards: return .DOWNWARDS
        @unknown default: return .UPWARDS
        }
    }
}

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
extension QueriedSourceFeature {
    func toFLTQueriedSourceFeature() -> FLTQueriedSourceFeature {
        return FLTQueriedSourceFeature.make(with: queriedFeature.toFLTQueriedFeature())
    }
}
extension QueriedRenderedFeature {
    func toFLTQueriedRenderedFeature() -> FLTQueriedRenderedFeature {
        return FLTQueriedRenderedFeature.make(with: queriedFeature.toFLTQueriedFeature(), layers: layers)
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
        return FLTMercatorCoordinate.makeWith(x: x, y: y)
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
        return FLTSize.make(withWidth: width, height: height)
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
        return FLTMapOptions.make(
            withContextMode: nil,
            constrainMode: .init(value: __constrainMode.map { ConstrainMode(rawValue: $0.intValue) }??.toFLTConstrainMode() ?? .NONE),
            viewportMode: .init(value: __viewportMode.map { ViewportMode(rawValue: $0.intValue) }??.toFLTViewportMode() ?? .DEFAULT),
            orientation: .init(value: __orientation.map { NorthOrientation(rawValue: $0.intValue) }??.toFLTNorthOrientation() ?? .UPWARDS),
            crossSourceCollisions: NSNumber(value: self.crossSourceCollisions),
            size: self.size?.toFLTSize(),
            pixelRatio: Double(pixelRatio),
            glyphsRasterizationOptions: self.glyphsRasterizationOptions?.toFLTGlyphsRasterizationOptions()
        )
    }
}
extension MapboxMaps.CameraBounds {
    func toFLTCameraBounds() -> FLTCameraBounds {
        return FLTCameraBounds.make(
            with: self.bounds.toFLTCoordinateBounds(),
            maxZoom: maxZoom,
            minZoom: minZoom,
            maxPitch: maxPitch,
            minPitch: minPitch)
    }
}
extension CGPoint {
    func toFLTScreenCoordinate() -> FLTScreenCoordinate {
        return FLTScreenCoordinate.makeWith(x: x, y: y)
    }
}
extension CoordinateBoundsZoom {
    func toFLTCoordinateBoundsZoom() -> FLTCoordinateBoundsZoom {
        return FLTCoordinateBoundsZoom.make(with: self.bounds.toFLTCoordinateBounds(), zoom: zoom)
    }
}
extension CoordinateBounds {
    func toFLTCoordinateBounds() -> FLTCoordinateBounds {
        FLTCoordinateBounds.make(
            withSouthwest: southwest.toDict(),
            northeast: northeast.toDict(),
            infiniteBounds: infiniteBounds)
    }
}
extension MapboxMaps.CameraOptions {
    func toFLTCameraOptions() -> FLTCameraOptions {
        let center = self.center != nil ? self.center?.toDict(): nil
        let padding = self.padding != nil ? FLTMbxEdgeInsets.make(
            withTop: padding!.top,
            left: padding!.left,
            bottom: padding!.bottom,
            right: padding!.right) : nil

        let anchor = self.anchor != nil ? FLTScreenCoordinate.makeWith(x: self.anchor!.x, y: self.anchor!.y) : nil
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

extension StyleTransition {
    func toFLTTransitionOptions() -> FLTTransitionOptions {
        return FLTTransitionOptions.make(
            withDuration: NSNumber(value: duration),
            delay: NSNumber(value: delay),
            enablePlacementTransitions: nil
        )
    }
}

extension StylePropertyValue {
    func toFLTStylePropertyValue(property: String) -> FLTStylePropertyValue {
        let data = FLTStylePropertyValueKind(rawValue: UInt(self.kind.rawValue))!
        let convertedValue: Any?
        switch value {
        case is [AnyHashable: Any], is [Any], is NSNumber:
            convertedValue = value
        case is NSNull:
            convertedValue = nil
        default:
            convertedValue = String(describing: value)
        }
        return FLTStylePropertyValue.make(withValue: convertedValue, kind: data)
    }
}

extension Geometry {

    func toMap() -> [String: Any] {
        switch self {
        case .point(let point):
            return point.toMap()
        case .lineString(let line):
            return line.toMap()
        case .polygon(let polygon):
            return polygon.toMap()
        case .multiPoint, .multiLineString, .multiPolygon, .geometryCollection:
            return [:]
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
        return FLTScreenCoordinate.makeWith(x: longitude, y: latitude)
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

func convertStringToArray(properties: String) -> [Any] {
    let data = properties.data(using: String.Encoding.utf8)!
    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])

    guard let result = jsonObject as? [Any] else {return []}
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

extension RawRepresentable where RawValue == UInt {

    var nsNumberValue: NSNumber {
        NSNumber(value: rawValue)
    }
}

extension NSNumber {
    internal var CGFloat: CGFloat {
        CoreGraphics.CGFloat(doubleValue)
    }

    internal var CLLocationDirection: CLLocationDirection {
        CoreLocation.CLLocationDirection(doubleValue)
    }
}

extension String {

    subscript(_ nsRange: NSRange) -> String? {
        guard let range = Range(nsRange, in: self) else { return nil }
        return String(self[range])
    }
}

// MARK: StyleColor

extension StyleColor {

    var nsNumberValue: NSNumber? {
        do {
            let color = try SupportedStyleColor(styleColor: self)
            return NSNumber(value: color.intValue)
        } catch {
            return nil
        }
    }

    init(rgb: Int) {
        self.init(uiColorFromHex(rgbValue: rgb))
    }
}

/// - Note: Current supports HSL(A) and RGB(A) color values.
struct SupportedStyleColor: Encodable {
    var r, g, b, a: Double

    private enum StyleColorConversionError: Swift.Error {
        case invalidStyleColor
        case unsupportedStyleColor
    }

    init(styleColor: StyleColor) throws {
        let pattern = #"((?<tag>rgb|rgba|hsl|hsla))\((?<value>.*)\)"#
        let regex = try NSRegularExpression(pattern: pattern)
        let colorString = styleColor.rawValue

        guard let match = regex.firstMatch(in: colorString, range: NSRange(colorString.startIndex..<colorString.endIndex, in: colorString)) else {
            throw StyleColorConversionError.unsupportedStyleColor
        }
        guard
            let tag = colorString[match.range(withName: "tag")],
            let valueString = colorString[match.range(withName: "value")]
        else {
            throw StyleColorConversionError.invalidStyleColor
        }

        try self.init(
            tag: tag,
            values: valueString.components(separatedBy: ",").compactMap {
                let scanner = Scanner(string: $0)
                var doubleValue: Double = 0
                scanner.scanDouble(&doubleValue)
                return doubleValue
            })
    }

    private init(tag: String, values: [Double]) throws {
        var values = values

        var r = values.removeFirst()
        var g = values.removeFirst()
        var b = values.removeFirst()

        if tag == "hsl" || tag == "hsla" {
            let (h, s, l) = (r, g, b)

            guard case 0...360 = h, case 0...1 = s, case 0...1 = l else {
                throw StyleColorConversionError.invalidStyleColor
            }

            let chroma = (1 - abs((2 * l) - 1)) * s
            let h60 = h / 60.0
            let x = chroma * (1 - abs((h60.truncatingRemainder(dividingBy: 2)) - 1))

            if h60 < 1 {
                r = chroma
                g = x
            } else if h60 < 2 {
                r = x
                g = chroma
            } else if h60 < 3 {
                g = chroma
                b = x
            } else if h60 < 4 {
                g = x
                b = chroma
            } else if h60 < 5 {
                r = x
                b = chroma
            } else if h60 < 6 {
                r = chroma
                b = x
            }

            let m = l - (chroma / 2)

            r = r + m
            g = g + m
            b = b + m
        } else {
            r /= 255
            g /= 255
            b /= 255
        }

        self.r = r
        self.g = g
        self.b = b
        self.a = values.first ?? 1.0
    }

    var intValue: Int {
        let red = Int(r * 255.0)
        let green = Int(g * 255.0)
        let blue = Int(b * 255.0)
        let alpha = Int(a * 255.0)
        // Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue
        return (alpha << 24) + (red << 16) + (green << 8) + blue
    }
}

// MARK: Style Projection

extension StyleProjectionName {

    init(_ fltValue: FLTStyleProjectionName) {
        switch fltValue {
        case .mercator: self = .mercator
        case .globe: self = .globe
        @unknown default: self.init(rawValue: "undefined")
        }
    }

    func toFLTStyleProjectionName() -> FLTStyleProjectionName? {
        switch self {
        case .globe: return .globe
        case .mercator: return .mercator
        default: return nil
        }
    }
}

extension StyleProjection {

    func toFLTStyleProjection() -> FLTStyleProjection? {
        name.toFLTStyleProjectionName().map(FLTStyleProjection.make(with:))
    }
}

// MARK: Foundation

infix operator ?=
extension Optional {

    static func ?= (lhs: inout Self, rhs: Self) {
        guard lhs == nil else { return }
        lhs = rhs
    }
}

extension UIImage {
    
    func toFLTMbxImage() -> FLTMbxImage {
        let data = FlutterStandardTypedData(bytes: pngData()!)
        return FLTMbxImage.make(withWidth: Int(size.width * scale), height: Int(size.height * scale), data: data)
    }
}

extension MapboxMaps.CameraState {
    func toFLTCameraState() -> FLTCameraState {
        return FLTCameraState.make(
            withCenter: ["coordinates": [center.longitude, center.latitude]],
            padding: FLTMbxEdgeInsets.make(
                withTop: padding.top,
                left: padding.left,
                bottom: padding.bottom,
                right: padding.right
            ),
            zoom: zoom,
            bearing: bearing,
            pitch: pitch
        )
    }
}
