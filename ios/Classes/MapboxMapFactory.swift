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

    private func createResourceOptions(args: [String: Any]) -> ResourceOptions {
        var resourceOptions = ResourceOptions(accessToken: "")
        if let resourceOptionsMap = args["resourceOptions"] as? [Any] {
            if let token = resourceOptionsMap[0] as? String {
                resourceOptions.accessToken = token
            }
            if let baseURL = resourceOptionsMap[1] as? String {
                resourceOptions.baseURL = URL(string: baseURL)
            }
            if let dataPath = resourceOptionsMap[2] as? String {
                resourceOptions.dataPathURL = URL(string: dataPath)
            }
            if let assetPath = resourceOptionsMap[3] as? String {
                resourceOptions.assetPathURL = URL(string: assetPath)
            }
            if let tileStoreUsageMode = resourceOptionsMap[4] as? Int {
                resourceOptions.tileStoreUsageMode = TileStoreUsageMode(rawValue: tileStoreUsageMode)!
            }
        }
        return resourceOptions
    }

    private func createGlyphsRasterizationOptions(args: [Any]) -> GlyphsRasterizationOptions {
        var glyphsRasterizationOptions: GlyphsRasterizationOptions = GlyphsRasterizationOptions(fontFamilies: [])
        if let glyphsRasterizationOptionsList = args[8] as? [Any] {
            if let rasterizationModeValue = glyphsRasterizationOptionsList[0] as? Int {
                let rasterizationMode = GlyphsRasterizationMode(rawValue: rasterizationModeValue)
                var fontFamilies: [String] = []
                if let fontFamiliesString = glyphsRasterizationOptionsList[1] as? String {
                    fontFamilies.append(fontFamiliesString)
                }
                glyphsRasterizationOptions = GlyphsRasterizationOptions(
                    rasterizationMode: rasterizationMode!,
                    fontFamilies: fontFamilies
                )
            }
        }
        return glyphsRasterizationOptions
    }
    private func createMapOptions(args: [String: Any]) -> MapOptions {
        var mapOptions = MapOptions()
        if let mapOptionsMap = args["mapOptions"] as? [Any] {
            var constrainMode: ConstrainMode = .heightOnly
            var viewportMode: ViewportMode = .default
            var orientation: NorthOrientation = .upwards
            var crossSourceCollisions: Bool = true
            var optimizeForTerrain: Bool = true
            var size: CGSize?
            var pixelRatio: CGFloat = UIScreen.main.nativeScale
            if let constrainModeInt = mapOptionsMap[1] as? Int {
                constrainMode = ConstrainMode(rawValue: constrainModeInt)!
            }
            if let viewportModeInt = mapOptionsMap[2] as? Int {
                viewportMode = ViewportMode(rawValue: viewportModeInt)!
            }
            if let orientationInt = mapOptionsMap[3] as? Int {
                orientation = NorthOrientation(rawValue: orientationInt)!
            }
            if let crossSourceCollisionsBool = mapOptionsMap[4] as? Bool {
                crossSourceCollisions = crossSourceCollisionsBool
            }
            if let optimizeForTerrainBool = mapOptionsMap[5] as? Bool {
                optimizeForTerrain = optimizeForTerrainBool
            }
            if let sizeMap = mapOptionsMap[6] as? [CGFloat] {
                size = CGSize(width: sizeMap[0], height: sizeMap[1])
            }
            if let pixelRatioFloat = mapOptionsMap[7] as? CGFloat {
                pixelRatio = pixelRatioFloat
            }

            mapOptions = MapOptions(
                constrainMode: constrainMode,
                viewportMode: viewportMode,
                orientation: orientation,
                crossSourceCollisions: crossSourceCollisions,
                optimizeForTerrain: optimizeForTerrain,
                size: size,
                pixelRatio: pixelRatio,
                glyphsRasterizationOptions: createGlyphsRasterizationOptions(args: mapOptionsMap)
            )
        }
        return mapOptions
    }

    private func createCameraOptions(args: [String: Any]) -> CameraOptions {
        var cameraOptions = CameraOptions()
        if let cameraOptionsMap = args["cameraOptions"] as? [Any] {
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
                    top: paddingMap[0] / UIScreen.main.scale,
                    left: paddingMap[1] / UIScreen.main.scale,
                    bottom: paddingMap[2] / UIScreen.main.scale,
                    right: paddingMap[3] / UIScreen.main.scale
                )
            }

            if let anchorMap = cameraOptionsMap[2] as? [CGFloat] {
                anchor = CGPoint(x: anchorMap[0], y: anchorMap[1])
            }

            cameraOptions = CameraOptions(center: center,
                                          padding: padding,
                                          anchor: anchor,
                                          zoom: zoom,
                                          bearing: bearing,
                                          pitch: pitch)
        }
        return cameraOptions
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        var mapInitOptions = MapInitOptions()
        var eventTypes = [String]()
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
        if let types = args["eventTypes"] as? [String] {
            eventTypes = types
        }
        mapInitOptions = MapInitOptions(resourceOptions: createResourceOptions(args: args),
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
