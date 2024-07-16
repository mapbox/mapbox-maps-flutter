import Foundation
@_spi(Experimental) import MapboxMaps
import MapboxCoreMaps_Private
import Flutter

let COORDINATES = "coordinates"

extension FlutterError: Error { }

// FLT to Mapbox

extension GlyphsRasterizationMode {
    func toGlyphsRasterizationMode() -> MapboxMaps.GlyphsRasterizationMode {
        switch self {
        case .nOGLYPHSRASTERIZEDLOCALLY: return .noGlyphsRasterizedLocally
        case .iDEOGRAPHSRASTERIZEDLOCALLY: return .ideographsRasterizedLocally
        case .aLLGLYPHSRASTERIZEDLOCALLY: return .allGlyphsRasterizedLocally
        }
    }
}

extension GlyphsRasterizationOptions {
    func toGlyphsRasterizationOptions() -> MapboxMaps.GlyphsRasterizationOptions {
        return MapboxMaps.GlyphsRasterizationOptions(
            rasterizationMode: rasterizationMode.toGlyphsRasterizationMode(),
            fontFamilies: fontFamily.map { [$0 ]} ?? []
        )
    }
}

extension MapSnapshotOptions {
    func toMapSnapshotOptions() -> MapboxMaps.MapSnapshotOptions {
        return MapboxMaps.MapSnapshotOptions(
            size: size.toCGSize(),
            pixelRatio: pixelRatio,
            glyphsRasterizationOptions: glyphsRasterizationOptions?.toGlyphsRasterizationOptions() ?? .init(),
            showsLogo: showsLogo ?? true,
            showsAttribution: showsAttribution ?? true
        )
    }
}

extension TileCoverOptions {
    func toTileCoverOptions() -> MapboxMaps.TileCoverOptions {
        return MapboxMaps.TileCoverOptions(
            tileSize: tileSize.map(UInt16.init),
            minZoom: minZoom.map(UInt8.init),
            maxZoom: maxZoom.map(UInt8.init),
            roundZoom: roundZoom
        )
    }
}
extension Size {
    func toCGSize() -> CGSize {
        return CGSize(width: width, height: height)
    }
}

extension ViewportMode {
    func toViewportMode() -> MapboxCoreMaps.ViewportMode {
        switch self {
        case .dEFAULT: return .default
        case .fLIPPEDY: return .flippedY
        }
    }
}

extension ConstrainMode {
    func toConstrainMode() -> MapboxCoreMaps.ConstrainMode {
        switch self {
        case .nONE: return .none
        case .hEIGHTONLY: return .heightOnly
        case .wIDTHANDHEIGHT: return .widthAndHeight
        }
    }
}

extension NorthOrientation {
    func toNorthOrientation() -> MapboxCoreMaps.NorthOrientation {
        switch self {
        case .uPWARDS: return .upwards
        case .rIGHTWARDS: return .rightwards
        case .dOWNWARDS: return .downwards
        case .lEFTWARDS: return .leftwards
        }
    }
}

extension TileCacheBudgetInMegabytes {
    func toTileCacheBudgetInMegabytes() -> MapboxMaps.TileCacheBudgetInMegabytes {
        return .init(size: UInt64(size))
    }
}

extension TileCacheBudgetInTiles {
    func toTileCacheBudgetInTiles() -> MapboxMaps.TileCacheBudgetInTiles {
        return .init(size: UInt64(size))
    }
}

extension SourceQueryOptions {
    func toSourceQueryOptions() throws -> MapboxMaps.SourceQueryOptions {
        return MapboxMaps.SourceQueryOptions(sourceLayerIds: sourceLayerIds?.compactMap { $0 }, filter: filter)
    }
}
extension RenderedQueryOptions {
    func toRenderedQueryOptions() throws -> MapboxCoreMaps.RenderedQueryOptions {
        var filterExp: Exp?
        if filter != nil {
            // FIXME - WARNING HERE
            filterExp =  try JSONDecoder().decode(Expression.self, from: filter!.data(using: .utf8)!)
        }
        return MapboxCoreMaps.RenderedQueryOptions(layerIds: layerIds?.compactMap { $0 }, filter: filterExp)
    }
}
extension MercatorCoordinate {
    func toMercatorCoordinate() -> MapboxMaps.MercatorCoordinate {
        return MapboxMaps.MercatorCoordinate(x: x, y: y)
    }
}
extension ProjectedMeters {
    func toProjectedMeters() -> MapboxMaps.ProjectedMeters {
        return MapboxMaps.ProjectedMeters(northing: northing, easting: easting)
    }
}
extension MapDebugOptions {
    func toMapDebugOptions() -> MapboxCoreMaps.MapDebugOptions {
        return MapboxCoreMaps.MapDebugOptions(rawValue: Int(self.data.rawValue))!
    }
}
extension CameraOptions {
    func toCameraOptions() -> MapboxMaps.CameraOptions {
        return MapboxMaps.CameraOptions(
            center: self.center?.coordinates,
            padding: self.padding?.toUIEdgeInsets(),
            anchor: self.anchor?.toCGPoint(),
            zoom: self.zoom?.CGFloat,
            bearing: self.bearing?.CLLocationDirection,
            pitch: self.pitch?.CGFloat
        )
    }
}

extension CameraBoundsOptions {
    func toCameraBoundsOptions() -> MapboxMaps.CameraBoundsOptions {
        return MapboxMaps.CameraBoundsOptions(
            bounds: self.bounds?.toCoordinateBounds(),
            maxZoom: maxZoom.map { CGFloat($0) },
            minZoom: self.minZoom.map { CGFloat($0) },
            maxPitch: self.maxPitch.map { CGFloat($0) },
            minPitch: self.minPitch.map { CGFloat($0) }
        )
    }
}
extension ScreenBox {
    func toScreenBox() -> ScreenBox {
        return ScreenBox(min: self.min.toScreenCoordinate(), max: self.max.toScreenCoordinate())
    }
    func toCGRect() -> CGRect {
        return CGRect(x: min.x, y: min.y, width: max.x - min.x, height: max.y - min.y)
    }
}
extension ScreenCoordinate {
    func toScreenCoordinate() -> ScreenCoordinate {
        return ScreenCoordinate(x: self.x, y: self.y)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}
extension CoordinateBounds {
    func toCoordinateBounds() -> MapboxMaps.CoordinateBounds {
        return MapboxMaps.CoordinateBounds(southwest: southwest.coordinates, northeast: northeast.coordinates)
    }
}

extension CanonicalTileID {
    func toCanonicalTileID() -> MapboxMaps.CanonicalTileID {
        return MapboxMaps.CanonicalTileID(z: UInt8(z), x: UInt32(x), y: UInt32(y))
    }
}

extension LayerPosition {
    func toLayerPosition() -> MapboxMaps.LayerPosition {
        var position = MapboxMaps.LayerPosition.default
        if self.above != nil {
            position = MapboxMaps.LayerPosition.above(self.above!)
        } else if self.below != nil {
            position = MapboxMaps.LayerPosition.below(self.below!)
        } else if self.at != nil {
            position = MapboxMaps.LayerPosition.at(Int(at!))
        }
        return position
    }
}

extension TransitionOptions {
    func toTransitionOptions() -> MapboxMaps.TransitionOptions {
        return MapboxMaps.TransitionOptions(
            duration: self.duration.map(TimeInterval.init),
            delay: self.delay.map(TimeInterval.init),
            enablePlacementTransitions: self.enablePlacementTransitions)
    }

    func toStyleTransition() -> StyleTransition {
        return StyleTransition(
            duration: self.duration.map { Double($0) / 1000.0 } ?? 0,
            delay: self.delay.map { Double($0) / 1000.0 } ?? 0)
    }
}

extension MbxEdgeInsets {
    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top,
            left: self.left,
            bottom: self.bottom,
            right: self.right)
    }
}

// Mapbox to FLT

extension MapboxMaps.CanonicalTileID {
    func toFLTCanonicalTileID() -> CanonicalTileID {
        return CanonicalTileID(z: Int64(z), x: Int64(x), y: Int64(y))
    }
}

extension MapboxMaps.CameraState {
    func toFLTCameraState() -> CameraState {
        return CameraState(
            center: Point(center),
            padding: MbxEdgeInsets(
                top: padding.top,
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
extension MapboxMaps.LoggingLevel {
    func toFLTLoggingLevel() -> LoggingLevel {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .warning
        case .error: return .error
        @unknown default: return .error
        }
    }
}

extension MapboxCoreMaps.ConstrainMode {
    func toFLTConstrainMode() -> ConstrainMode {
        switch self {
        case .heightOnly: return .hEIGHTONLY
        case .widthAndHeight: return .wIDTHANDHEIGHT
        case .none: return .nONE
        @unknown default: return .nONE
        }
    }
}

extension MapboxCoreMaps.ViewportMode {
    func toFLTViewportMode() -> ViewportMode {
        switch self {
        case .default: return .dEFAULT
        case .flippedY: return .fLIPPEDY
        @unknown default: return .dEFAULT
        }
    }
}

extension MapboxCoreMaps.NorthOrientation {
    func toFLTNorthOrientation() -> NorthOrientation {
        switch self {
        case .upwards: return .uPWARDS
        case .leftwards: return .lEFTWARDS
        case .rightwards: return .rIGHTWARDS
        case .downwards: return .dOWNWARDS
        @unknown default: return .uPWARDS
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
extension MapboxCoreMaps.FeatureExtensionValue {
    func toFLTFeatureExtensionValue() -> FeatureExtensionValue {
        let featureCollection = features?.map({$0.toMap()})
        var resultValue: String?
        if value != nil {resultValue = String(describing: value!)}
        return FeatureExtensionValue(value: resultValue, featureCollection: featureCollection)
    }
}
extension MapboxMaps.QueriedSourceFeature {
    func toFLTQueriedSourceFeature() -> QueriedSourceFeature {
        return QueriedSourceFeature(queriedFeature: queriedFeature.toFLTQueriedFeature())
    }
}
extension MapboxMaps.QueriedRenderedFeature {
    func toFLTQueriedRenderedFeature() -> QueriedRenderedFeature {
        return QueriedRenderedFeature(queriedFeature: queriedFeature.toFLTQueriedFeature(), layers: layers)
    }
}
extension MapboxMaps.QueriedFeature {
    func toFLTQueriedFeature() -> QueriedFeature {
        let stateString = convertDictionaryToString(dict: state as? [String: Any])
        return QueriedFeature(feature: feature.toMap(), source: source, sourceLayer: sourceLayer, state: stateString)
    }
}
extension MapboxMaps.MercatorCoordinate {
    func toFLTMercatorCoordinate() -> MercatorCoordinate {
        return MercatorCoordinate(x: x, y: y)
    }
}
extension MapboxMaps.MapDebugOptions {
    func toFLTMapDebugOptions() -> MapDebugOptions {
        let data = MapDebugOptionsData(rawValue: rawValue)!
        return MapDebugOptions(data: data)
    }
}

extension CGSize {
    func toFLTSize() -> Size {
        return Size(width: width, height: height)
    }
}

extension MapboxMaps.GlyphsRasterizationOptions {
    func toFLTGlyphsRasterizationOptions() -> GlyphsRasterizationOptions {
        let mode = GlyphsRasterizationMode(rawValue: rasterizationMode.rawValue)
        return GlyphsRasterizationOptions(rasterizationMode: mode!, fontFamily: self.fontFamily)
    }
}
extension MapboxMaps.MapOptions {
    func toFLTMapOptions() -> MapOptions {
        return MapOptions(
            contextMode: nil,
            constrainMode: __constrainMode.map { MapboxMaps.ConstrainMode(rawValue: $0.intValue) }??.toFLTConstrainMode() ?? .nONE,
            viewportMode: __viewportMode.map { MapboxMaps.ViewportMode(rawValue: $0.intValue) }??.toFLTViewportMode() ?? .dEFAULT,
            orientation: __orientation.map { MapboxMaps.NorthOrientation(rawValue: $0.intValue) }??.toFLTNorthOrientation() ?? .uPWARDS,
            crossSourceCollisions: crossSourceCollisions,
            size: self.size?.toFLTSize(),
            pixelRatio: Double(pixelRatio),
            glyphsRasterizationOptions: self.glyphsRasterizationOptions?.toFLTGlyphsRasterizationOptions()
        )
    }
}
extension MapboxMaps.CameraBounds {
    func toFLTCameraBounds() -> CameraBounds {
        return CameraBounds(
            bounds: self.bounds.toFLTCoordinateBounds(),
            maxZoom: maxZoom,
            minZoom: minZoom,
            maxPitch: maxPitch,
            minPitch: minPitch)
    }
}
extension CGPoint {
    func toFLTScreenCoordinate() -> ScreenCoordinate {
        return ScreenCoordinate(x: x, y: y)
    }
}

extension MapboxMaps.MapContentGestureContext {

    func toFLTMapContentGestureContext() -> MapContentGestureContext {
        MapContentGestureContext(touchPosition: point.toFLTScreenCoordinate(), point: Point(coordinate))
    }
}

extension MapboxMaps.CoordinateBoundsZoom {
    func toFLTCoordinateBoundsZoom() -> CoordinateBoundsZoom {
        return CoordinateBoundsZoom(bounds: self.bounds.toFLTCoordinateBounds(), zoom: zoom)
    }
}
extension MapboxMaps.CoordinateBounds {
    func toFLTCoordinateBounds() -> CoordinateBounds {
        CoordinateBounds(
            southwest: Point(southwest),
            northeast: Point(northeast),
            infiniteBounds: infiniteBounds)
    }
}
extension MapboxMaps.CameraOptions {
    func toFLTCameraOptions() -> CameraOptions {
        let padding = self.padding != nil ? MbxEdgeInsets(
            top: padding!.top,
            left: padding!.left,
            bottom: padding!.bottom,
            right: padding!.right) : nil

        let anchor = self.anchor != nil ? ScreenCoordinate(x: self.anchor!.x, y: self.anchor!.y) : nil

        return CameraOptions(
            center: center.map(Point.init),
            padding: padding,
            anchor: anchor,
            zoom: zoom.map(Double.init),
            bearing: bearing,
            pitch: pitch.map(Double.init)
        )
    }
}
extension MapboxMaps.TransitionOptions {
    func toFLTTransitionOptions() -> TransitionOptions {
        return TransitionOptions(
            duration: duration.map(Int64.init),
            delay: delay.map(Int64.init),
            enablePlacementTransitions: enablePlacementTransitions
        )
    }
}

extension MapboxMaps.StyleTransition {
    func toFLTTransitionOptions() -> TransitionOptions {
        return TransitionOptions(
            duration: Int64(duration),
            delay: Int64(delay),
            enablePlacementTransitions: nil
        )
    }
}

extension MapboxMaps.StylePropertyValue {
    func toFLTStylePropertyValue(property: String) -> StylePropertyValue {
        let data = StylePropertyValueKind(rawValue: kind.rawValue)!
        let convertedValue: Any?
        switch value {
        case is [AnyHashable: Any], is [Any], is NSNumber:
            convertedValue = value
        case is NSNull:
            convertedValue = nil
        default:
            convertedValue = String(describing: value)
        }
        return StylePropertyValue(value: convertedValue, kind: data)
    }
}

extension MapboxMaps.Geometry {

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

    func toFLTScreenCoordinate() -> ScreenCoordinate {
        return ScreenCoordinate(x: longitude, y: latitude)
    }
}

func convertDictionaryToCLLocationCoordinate2D(dict: [String?: Any?]?) -> CLLocationCoordinate2D? {
    if dict == nil { return nil}
    let coordinates = dict![COORDINATES] as? [Any]

    return CLLocationCoordinate2D(latitude: coordinates?.last as? CLLocationDegrees ?? 0, longitude: coordinates?.first as? CLLocationDegrees ?? 0)
}

func convertDictionaryToPolygon(dict: [String?: Any?]) -> Polygon {
    let coordinates = dict[COORDINATES] as? [[[CLLocationDegrees]]]
    let coordinatesList = coordinates.map({$0.map({$0.map({CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)})})})!

    return Polygon(coordinatesList)
}

func convertDictionaryToPolyline(dict: [String?: Any?]) -> LineString {
    let coordinates = dict[COORDINATES] as? [[CLLocationDegrees]]

    let coordinatesList = coordinates.map({$0.map({CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)})})!
    return LineString(coordinatesList)
}

func convertDictionaryToCGPoint(dict: [String?: Any?]?) -> CGPoint? {
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

func convertDictionaryToString(dict: [String?: Any?]?) -> String {
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

func convertDictionaryToGeometry(dict: [String?: Any?]?) -> Geometry? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let geometry = try JSONDecoder().decode(Geometry.self, from: jsonData)
        return geometry
    } catch {
        return nil
    }
}

func convertDictionaryToFeature(dict: [String?: Any?]) -> Feature? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let feature = try JSONDecoder().decode(Feature.self, from: jsonData)
        return feature
    } catch {
        return nil
    }
}

func uiColorFromHex(rgbValue: Int64) -> UIColor {

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

extension Double {
    internal var CGFloat: CGFloat {
        CoreGraphics.CGFloat(self)
    }

    internal var CLLocationDirection: CLLocationDirection {
        CoreLocation.CLLocationDirection(self)
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
    var intValue: Int64? {
        do {
            let color = try SupportedStyleColor(styleColor: self)
            return Int64(color.intValue)
        } catch {
            return nil
        }
    }

    init?(rgb: Int64?) {
        guard let rgb else { return nil }

        self.init(uiColorFromHex(rgbValue: rgb))
    }

    init(rgb: Int64) {
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

extension MapboxMaps.StyleProjectionName {

    init(_ fltValue: StyleProjectionName) {
        switch fltValue {
        case .mercator: self = .mercator
        case .globe: self = .globe
        }
    }

    func toFLTStyleProjectionName() -> StyleProjectionName? {
        switch self {
        case .globe: return .globe
        case .mercator: return .mercator
        default: return nil
        }
    }
}

extension MapboxMaps.StyleProjection {

    func toFLTStyleProjection() -> StyleProjection? {
        name.toFLTStyleProjectionName().map(StyleProjection.init(name:))
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

extension RawRepresentable {

    init?<Other>(other: Other) where Other: RawRepresentable, Other.RawValue == RawValue {
        self.init(rawValue: other.rawValue)
    }
}

extension String {

    init?(json: Any, encoding: String.Encoding = .utf8) {
        do {
            guard JSONSerialization.isValidJSONObject(json) else { return nil }
            let data = try JSONSerialization.data(withJSONObject: json)
            self.init(data: data, encoding: encoding)
        } catch {
            return nil
        }
    }
}

extension Array {

    func compacted<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }
}

extension Date {

    var miliSecondsSince1970: TimeInterval {
        timeIntervalSince1970 * 1000
    }
}

// MARK: Offline

extension MapboxCoreMaps.StylePackLoadOptions {

    convenience init?(fltValue: StylePackLoadOptions) {
        self.init(
            glyphsRasterizationMode: fltValue.glyphsRasterizationMode?.toGlyphsRasterizationMode(),
            metadata: fltValue.metadata,
            acceptExpired: fltValue.acceptExpired
        )
    }

    func toFLTStylePackLoadOptions() -> StylePackLoadOptions {
        StylePackLoadOptions(
            glyphsRasterizationMode: glyphsRasterizationMode.flatMap(GlyphsRasterizationMode.init(other:)),
            metadata: metadata as? [String: Any],
            acceptExpired: acceptExpired
        )
    }
}

extension MapboxCoreMaps.StylePack {

    func toFLTStylePack() -> StylePack {
        StylePack(
            styleURI: styleURI,
            glyphsRasterizationMode: GlyphsRasterizationMode(rawValue: glyphsRasterizationMode.rawValue)!,
            requiredResourceCount: Int64(requiredResourceCount),
            completedResourceCount: Int64(completedResourceCount),
            completedResourceSize: Int64(completedResourceSize))
    }
}

extension MapboxCoreMaps.StylePackLoadProgress {

    func toFLTStylePackLoadProgress() -> StylePackLoadProgress {
        StylePackLoadProgress(
            completedResourceCount: Int64(completedResourceCount),
            completedResourceSize: Int64(completedResourceSize),
            erroredResourceCount: Int64(erroredResourceCount),
            requiredResourceCount: Int64(requiredResourceCount),
            loadedResourceCount: Int64(loadedResourceCount),
            loadedResourceSize: Int64(loadedResourceSize))
    }
}

extension MapboxCoreMaps.TilesetDescriptorOptions {

    convenience init(fltValue: TilesetDescriptorOptions) {
        if let pixelRatio = fltValue.pixelRatio {
            self.init(
                styleURI: fltValue.styleURI,
                minZoom: UInt8(fltValue.minZoom),
                maxZoom: UInt8(fltValue.maxZoom),
                pixelRatio: Float(pixelRatio),
                tilesets: fltValue.tilesets?.compacted(),
                stylePack: fltValue.stylePackOptions.flatMap(MapboxCoreMaps.StylePackLoadOptions.init(fltValue:)),
                extraOptions: fltValue.extraOptions)
        } else {
            self.init(
                styleURI: fltValue.styleURI,
                minZoom: UInt8(fltValue.minZoom),
                maxZoom: UInt8(fltValue.maxZoom),
                tilesets: fltValue.tilesets?.compacted(),
                stylePack: fltValue.stylePackOptions.flatMap(MapboxCoreMaps.StylePackLoadOptions.init(fltValue:)),
                extraOptions: fltValue.extraOptions)
        }
    }
}

extension MapboxCommon.TileRegion {

    func toFLTTileRegion() -> TileRegion {
        TileRegion(
            id: id,
            requiredResourceCount: Int64(requiredResourceCount),
            completedResourceCount: Int64(completedResourceCount),
            completedResourceSize: Int64(completedResourceSize),
            expires: expires.map { Int64($0.miliSecondsSince1970) })
    }
}

extension MapboxCommon.TileRegionEstimateOptions {

    convenience init(fltValue: TileRegionEstimateOptions) {
        self.init(
            errorMargin: Float(fltValue.errorMargin),
            preciseEstimationTimeout: fltValue.preciseEstimationTimeout,
            timeout: fltValue.timeout,
            extraOptions: fltValue.extraOptions)
    }
}

extension MapboxCommon.TileRegionEstimateResult {

    func toFLTTileRegionEstimateResult() -> TileRegionEstimateResult {
        TileRegionEstimateResult(
            errorMargin: errorMargin,
            transferSize: Int64(transferSize),
            storageSize: Int64(storageSize),
            extraOptions: extraData as? [String: Any])
    }
}

extension MapboxCommon.TileRegionLoadProgress {

    func toFLTTileRegionLoadProgress() -> TileRegionLoadProgress {
        TileRegionLoadProgress(
            completedResourceCount: Int64(completedResourceCount),
            completedResourceSize: Int64(completedResourceSize),
            erroredResourceCount: Int64(erroredResourceCount),
            requiredResourceCount: Int64(requiredResourceCount),
            loadedResourceCount: Int64(loadedResourceCount),
            loadedResourceSize: Int64(loadedResourceSize))
    }
}

extension MapboxCommon.TileRegionEstimateProgress {

    func toFLTTileRegionEstimateProgress() -> TileRegionEstimateProgress {
        TileRegionEstimateProgress(
            requiredResourceCount: Int64(requiredResourceCount),
            completedResourceCount: Int64(completedResourceCount),
            erroredResourceCount: Int64(erroredResourceCount))
    }
}
// MARK: Result
extension Result where Failure == any Error {
    init(code: String, catchingFlutter body: () throws -> Success) {
        self.init {
            do {
                return try body()
            } catch {
                throw FlutterError(code: code, message: error.localizedDescription, details: [NSUnderlyingErrorKey: error])
            }
        }
    }
}

extension Result {

    func mapElement<Element, NewElement>(
        _ transform: (Element) -> NewElement
    ) -> Result<[NewElement], Failure> where Success == [Element] {
        return map { success in success.map(transform) }
    }
}

func executeOnMainThread<T>(_ execute: @escaping (T) -> Void) -> (T) -> Void {
    return { t in
        DispatchQueue.main.async {
            execute(t)
        }
    }
}
