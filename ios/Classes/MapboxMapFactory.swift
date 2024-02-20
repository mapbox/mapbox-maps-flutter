import Flutter
import MapboxMaps
import MapboxCommon

class MapboxMapFactory: NSObject, FlutterPlatformViewFactory {
    var registrar: FlutterPluginRegistrar

    init(withRegistrar registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    private func createGlyphsRasterizationOptions(args: [Any]) -> MapboxMaps.GlyphsRasterizationOptions {
        var glyphsRasterizationOptions = MapboxMaps.GlyphsRasterizationOptions(fontFamilies: [])
        if let glyphsRasterizationOptionsList = args[7] as? [Any] {
            if let rasterizationModeValue = glyphsRasterizationOptionsList[0] as? Int {
                let rasterizationMode = MapboxMaps.GlyphsRasterizationMode(rawValue: rasterizationModeValue)
                var fontFamilies: [String] = []
                if let fontFamiliesString = glyphsRasterizationOptionsList[1] as? String {
                    fontFamilies.append(fontFamiliesString)
                }
                glyphsRasterizationOptions = MapboxMaps.GlyphsRasterizationOptions(
                    rasterizationMode: rasterizationMode!,
                    fontFamilies: fontFamilies
                )
            }
        }
        return glyphsRasterizationOptions
    }

    private func createMapOptions(args: [String: Any]) -> MapboxMaps.MapOptions {
        var mapOptions = MapboxMaps.MapOptions()
        if let mapOptionsMap = args["mapOptions"] as? [Any] {
            var constrainMode: MapboxMaps.ConstrainMode = .heightOnly
            var viewportMode: MapboxMaps.ViewportMode = .default
            var orientation: MapboxMaps.NorthOrientation = .upwards
            var crossSourceCollisions: Bool = true
            var size: CGSize?
            var pixelRatio: CGFloat = UIScreen.main.nativeScale
            if let constrainModeInt = mapOptionsMap[1] as? Int {
                constrainMode = MapboxMaps.ConstrainMode(rawValue: constrainModeInt)!
            }
            if let viewportModeInt = mapOptionsMap[2] as? Int {
                viewportMode = MapboxMaps.ViewportMode(rawValue: viewportModeInt)!
            }
            if let orientationInt = mapOptionsMap[3] as? Int {
                orientation = MapboxMaps.NorthOrientation(rawValue: orientationInt)!
            }
            if let crossSourceCollisionsBool = mapOptionsMap[4] as? Bool {
                crossSourceCollisions = crossSourceCollisionsBool
            }
            if let sizeMap = mapOptionsMap[5] as? [CGFloat] {
                size = CGSize(width: sizeMap[0], height: sizeMap[1])
            }
            if let pixelRatioFloat = mapOptionsMap[6] as? CGFloat {
                pixelRatio = pixelRatioFloat
            }

            mapOptions = MapboxMaps.MapOptions(
                constrainMode: constrainMode,
                viewportMode: viewportMode,
                orientation: orientation,
                crossSourceCollisions: crossSourceCollisions,
                size: size,
                pixelRatio: pixelRatio,
                glyphsRasterizationOptions: createGlyphsRasterizationOptions(args: mapOptionsMap)
            )
        }
        return mapOptions
    }

    private func createCameraOptions(args: [String: Any]) -> MapboxMaps.CameraOptions? {
        guard let cameraOptionsMap = args["cameraOptions"] as? [Any] else {
            return nil
        }

        var center: CLLocationCoordinate2D?
        var padding: UIEdgeInsets?
        var anchor: CGPoint?
        let zoom: CGFloat? =  cameraOptionsMap[3] as? CGFloat
        let bearing: CLLocationDirection? =  cameraOptionsMap[4] as? CLLocationDirection
        let pitch: CGFloat? =  cameraOptionsMap[5] as? CGFloat

        if let centerMap = cameraOptionsMap[0] as? [String: Any] {
            center = convertDictionaryToCLLocationCoordinate2D(dict: centerMap)
        }

        if let paddingMap = cameraOptionsMap[1] as? [CGFloat] {
            padding = UIEdgeInsets(
                top: paddingMap[0],
                left: paddingMap[1],
                bottom: paddingMap[2],
                right: paddingMap[3]
            )
        }

        if let anchorMap = cameraOptionsMap[2] as? [CGFloat] {
            anchor = CGPoint(x: anchorMap[0], y: anchorMap[1])
        }

        return MapboxMaps.CameraOptions(center: center,
                                        padding: padding,
                                        anchor: anchor,
                                        zoom: zoom,
                                        bearing: bearing,
                                        pitch: pitch)
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        var mapInitOptions = MapInitOptions()
        var eventTypes = [Int]()
        var pluginVersion = ""
        var channelSuffix = 0

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: mapInitOptions,
                channelSuffix: channelSuffix,
                eventTypes: eventTypes,
                arguments: args,
                registrar: registrar,
                pluginVersion: pluginVersion
            )
        }
        var styleURI: StyleURI? = .streets
        if let styleURIString = args["styleUri"] as? String {
            styleURI = StyleURI(rawValue: styleURIString)
        }
        if let types = args["eventTypes"] as? [Int] {
            eventTypes = types
        }

        mapInitOptions = MapInitOptions(
            mapOptions: createMapOptions(args: args),
            cameraOptions: createCameraOptions(args: args),
            styleURI: styleURI
        )

        if let version = args["mapboxPluginVersion"] as? String {
            pluginVersion = version
        }

        if let suffix = args["channelSuffix"] as? Int {
            channelSuffix = suffix
        }

        return MapboxMapController(
            withFrame: frame,
            mapInitOptions: mapInitOptions,
            channelSuffix: channelSuffix,
            eventTypes: eventTypes,
            arguments: args,
            registrar: registrar,
            pluginVersion: pluginVersion
        )
    }
}
