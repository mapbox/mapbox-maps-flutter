import Flutter
import MapboxMaps

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
        if let resourceOptionsMap = args["resourceOptions"] as? [String: Any] {
            if let token = resourceOptionsMap["accessToken"] as? String {
                resourceOptions.accessToken = token
            }
            if let baseURL = resourceOptionsMap["baseURL"] as? String {
                resourceOptions.baseURL = URL(string: baseURL)
            }
            if let dataPath = resourceOptionsMap["dataPath"] as? String {
                resourceOptions.dataPathURL = URL(string: dataPath)
            }
            if let assetPath = resourceOptionsMap["assetPath"] as? String {
                resourceOptions.assetPathURL = URL(string: assetPath)
            }
            if let tileStoreUsageMode = resourceOptionsMap["tileStoreUsageMode"] as? Int {
                resourceOptions.tileStoreUsageMode = TileStoreUsageMode(rawValue: tileStoreUsageMode)!
            }
        }
        return resourceOptions
    }

    private func createGlyphsRasterizationOptions(args: [String: Any]) -> GlyphsRasterizationOptions {
        var glyphsRasterizationOptions: GlyphsRasterizationOptions = GlyphsRasterizationOptions(fontFamilies: [])
        if let glyphsRasterizationOptionseMap = args["glyphsRasterizationOptions"] as? [String: Any] {
            if let rasterizationModeValue = glyphsRasterizationOptionseMap["rasterizationMode"] as? Int {
                let rasterizationMode = GlyphsRasterizationMode(rawValue: rasterizationModeValue)
                var fontFamilies: [String] = []
                if let fontFamiliesString = glyphsRasterizationOptionseMap["fontFamily"] as? String {
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
        if let mapOptionsMap = args["mapOptions"] as? [String: Any] {
            var constrainMode: ConstrainMode = .heightOnly
            var viewportMode: ViewportMode = .default
            var orientation: NorthOrientation = .upwards
            var crossSourceCollisions: Bool = true
            var optimizeForTerrain: Bool = true
            var size: CGSize?
            var pixelRatio: CGFloat = UIScreen.main.nativeScale
            if let constrainModeInt = mapOptionsMap["constrainMode"] as? Int {
                constrainMode = ConstrainMode(rawValue: constrainModeInt)!
            }
            if let viewportModeInt = mapOptionsMap["viewportMode"] as? Int {
                viewportMode = ViewportMode(rawValue: viewportModeInt)!
            }
            if let orientationInt = mapOptionsMap["orientation"] as? Int {
                orientation = NorthOrientation(rawValue: orientationInt)!
            }
            if let crossSourceCollisionsBool = mapOptionsMap["crossSourceCollisions"] as? Bool {
                crossSourceCollisions = crossSourceCollisionsBool
            }
            if let optimizeForTerrainBool = mapOptionsMap["optimizeForTerrain"] as? Bool {
                optimizeForTerrain = optimizeForTerrainBool
            }
            if let sizeMap = mapOptionsMap["size"] as? [String: CGFloat] {
                size = CGSize(width: sizeMap["width"]!, height: sizeMap["height"]!)
            }
            if let pixelRatioFloat = mapOptionsMap["pixelRatio"] as? CGFloat {
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
        if let cameraOptionsMap = args["cameraOptions"] as? [String: Any] {
            var center: CLLocationCoordinate2D?
            var padding: UIEdgeInsets?
            var anchor: CGPoint?
            let zoom: CGFloat? =  cameraOptionsMap["zoom"] as? CGFloat
            let bearing: CLLocationDirection? =  cameraOptionsMap["bearing"] as? CLLocationDirection
            let pitch: CGFloat? =  cameraOptionsMap["pitch"] as? CGFloat

            if let centerMap = cameraOptionsMap["center"] as? [String: Any] {
                center = convertDictionaryToCLLocationCoordinate2D(dict: centerMap)
            }

            if let paddingMap = cameraOptionsMap["padding"] as? [String: CGFloat] {
                padding = UIEdgeInsets(
                    top: paddingMap["top"]!,
                    left: paddingMap["left"]!,
                    bottom: paddingMap["bottom"]!,
                    right: paddingMap["right"]!
                )
            }

            if let anchorMap = cameraOptionsMap["anchor"] as? [String: CGFloat] {
                anchor = CGPoint(x: anchorMap["x"]!, y: anchorMap["y"]!)
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

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: mapInitOptions,
                viewIdentifier: viewId,
                eventTypes: eventTypes,
                arguments: args,
                registrar: registrar
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

        return MapboxMapController(
            withFrame: frame,
            mapInitOptions: mapInitOptions,
            viewIdentifier: viewId,
            eventTypes: eventTypes,
            arguments: args,
            registrar: registrar
        )
    }
}
