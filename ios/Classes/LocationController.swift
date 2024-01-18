@_spi(Experimental) import MapboxMaps
import UIKit

class LocationController: NSObject, FLT_SETTINGS_LocationComponentSettingsInterface {
    func updateSettingsSettings(
        _ settings: FLT_SETTINGSLocationComponentSettings,
        useDefaultPuck2DIfNeeded: Bool,
        error: AutoreleasingUnsafeMutablePointer<FlutterError?>
    ) {
        do {
            var locationOptions = try mapView.location.options.fromFLT_SETTINGSLocationComponentSettings(settings: settings)
            if useDefaultPuck2DIfNeeded, case .puck2D(var config) = locationOptions.puckType {
                let defaultPuck2DConfig = Puck2DConfiguration.makeDefault(showBearing: locationOptions.puckBearingEnabled)
                config.topImage ?= defaultPuck2DConfig.topImage
                config.bearingImage ?= defaultPuck2DConfig.bearingImage
                config.shadowImage ?= defaultPuck2DConfig.shadowImage
                locationOptions.puckType = .puck2D(config)
            }
            mapView.location.options = locationOptions
        } catch let settingsError {
            error.pointee = FlutterError(code: "0", message: settingsError.localizedDescription, details: settingsError)
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSLocationComponentSettings? {
        return mapView.location.options.toFLT_SETTINGSLocationComponentSettings()
    }

    private var mapView: MapView
    private var cancelable: Cancelable?
    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}

extension LocationOptions {
    func fromFLT_SETTINGSLocationComponentSettings(settings: FLT_SETTINGSLocationComponentSettings) throws -> LocationOptions {
        var options = LocationOptions()
        if let puckBearingEnabled = settings.puckBearingEnabled {
            options.puckBearingEnabled = puckBearingEnabled.boolValue
        }

        if let puckBearing = settings.puckBearing.flatMap(PuckBearing.init) {
            options.puckBearing = puckBearing
        }

        if settings.enabled == false {
            options.puckType = nil
        } else if let puck3D = settings.locationPuck?.locationPuck3D {
                var model = Model(uri: URL(string: puck3D.modelUri!))
                if let position = puck3D.position {
                    model.position = position.map({$0.doubleValue})
                }
                var configuration: Puck3DConfiguration = Puck3DConfiguration(
                    model: model
                )
                if let opacity = puck3D.modelOpacity {
                    configuration.modelOpacity = .constant(opacity.doubleValue)
                }
                if let scale = puck3D.modelScale {
                    configuration.modelScale = .constant(scale.map({$0.doubleValue}))
                }
                if let scaleExpressionData = puck3D.modelScaleExpression?.data(using: .utf8) {
                    let decodedExpression = try! JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                    configuration.modelScale = .expression(decodedExpression)
                }
                if let rotation = puck3D.modelRotation {
                    configuration.modelRotation = .constant(rotation.map({$0.doubleValue}))
                }
                options.puckType = .puck3D(configuration)
        } else if let puck2D = settings.locationPuck?.locationPuck2D {
            var configuration: Puck2DConfiguration = {
                if case .puck2D(let config) = puckType { return config }
                return Puck2DConfiguration()
            }()
            configuration.topImage = puck2D.topImage.flatMap { UIImage(data: $0.data, scale: UIScreen.main.scale ) }
            configuration.bearingImage = puck2D.bearingImage.flatMap { UIImage(data: $0.data, scale: UIScreen.main.scale ) }
            configuration.shadowImage = puck2D.shadowImage.flatMap { UIImage(data: $0.data, scale: UIScreen.main.scale ) }

            if let scaleData = puck2D.scaleExpression?.data(using: .utf8) {
                configuration.scale = try JSONDecoder().decode(Value<Double>.self, from: scaleData)
            }
            if let color = settings.accuracyRingColor {
                configuration.accuracyRingColor = uiColorFromHex(rgbValue: color.intValue)
            }
            if let color = settings.accuracyRingBorderColor {
                configuration.accuracyRingBorderColor = uiColorFromHex(rgbValue: color.intValue)
            }
            if let showAccuracyRing = settings.showAccuracyRing {
                configuration.showsAccuracyRing = showAccuracyRing.boolValue
            }
            if settings.pulsingEnabled?.boolValue ?? false {
                var pulsing = Puck2DConfiguration.Pulsing()

                if let radius = settings.pulsingMaxRadius?.intValue {
                    // -1 indicates "accuracy" mode(from Android)
                    pulsing.radius = radius == -1 ? .accuracy : .constant(Double(radius))
                }
                if let color = settings.pulsingColor?.intValue {
                    pulsing.color = uiColorFromHex(rgbValue: color)
                }
                configuration.pulsing = pulsing
            }

            if let opacity = puck2D.opacity?.doubleValue {
                configuration.opacity = opacity
            }

            options.puckType = .puck2D(configuration)
        }
        return options
    }

    func toFLT_SETTINGSLocationComponentSettings() -> FLT_SETTINGSLocationComponentSettings {
        var enabled: NSNumber?
        if self.puckType != nil {
            enabled = NSNumber(true)
        }
        let puckBearingEnabled = NSNumber(value: self.puckBearingEnabled)
        let puckBearing = puckBearing.toFLTPuckBearing()
        var accuracyRingColor: NSNumber?
        var accuracyRingBorderColor: NSNumber?
        var showAccuracyRing: NSNumber?
        var pulsingEnabled: NSNumber?
        var pulsingRadius: NSNumber?
        var pulsingColor: NSNumber?
        let locationPuck2D = FLT_SETTINGSLocationPuck2D.init()
        let locationPuck3D = FLT_SETTINGSLocationPuck3D.init()
        let locationPuck = FLT_SETTINGSLocationPuck.make(with: locationPuck2D, locationPuck3D: locationPuck3D)

        if case .puck2D(let oldConfiguration) = self.puckType {
            accuracyRingColor = NSNumber(value: oldConfiguration.accuracyRingColor.rgb())
            accuracyRingBorderColor = NSNumber(value: oldConfiguration.accuracyRingBorderColor.rgb())
            showAccuracyRing = NSNumber(value: oldConfiguration.showsAccuracyRing)
            if let topData = oldConfiguration.topImage?.pngData() {
                locationPuck2D.topImage = FlutterStandardTypedData(bytes: topData)
            }
            if let bearingData = oldConfiguration.bearingImage?.pngData() {
                locationPuck2D.bearingImage = FlutterStandardTypedData(bytes: bearingData)
            }
            if let shadowData = oldConfiguration.shadowImage?.pngData() {
                locationPuck2D.shadowImage = FlutterStandardTypedData(bytes: shadowData)
            }
            if case .expression(let scaleData) = oldConfiguration.scale {
                let encoded = try! JSONEncoder().encode(scaleData)
                locationPuck2D.scaleExpression = String(data: encoded, encoding: .utf8)
            }
            locationPuck2D.opacity = NSNumber(value: oldConfiguration.opacity)
            if let pulsing = oldConfiguration.pulsing {
                pulsingEnabled = NSNumber(value: true)
                switch pulsing.radius {
                case .accuracy:
                    pulsingRadius = NSNumber(value: -1)
                case .constant(let radius):
                    pulsingRadius = NSNumber(value: radius)
                }
                pulsingColor = NSNumber(value: pulsing.color.rgb())
            }
        }
        if case .puck3D(let oldConfiguration) = self.puckType {
            locationPuck3D.modelUri = oldConfiguration.model.uri?.absoluteString
            locationPuck3D.position = oldConfiguration.model.position?.map({NSNumber(value: $0)})
            if case .constant(let opacityData) = oldConfiguration.modelOpacity {
                locationPuck3D.modelOpacity = NSNumber(value: opacityData)
            }
            if case .constant(let scaleData) = oldConfiguration.modelScale {
                locationPuck3D.modelScale = scaleData.map({NSNumber(value: $0)})
            }
            if case .expression(let scaleExpression) = oldConfiguration.modelScale {
                let encoded = try! JSONEncoder().encode(scaleExpression)
                locationPuck3D.modelScaleExpression = String(data: encoded, encoding: .utf8)
            }
            if case .constant(let rotationData) = oldConfiguration.modelRotation {
                locationPuck3D.modelRotation = rotationData.map({NSNumber(value: $0)})
            }
        }

        return FLT_SETTINGSLocationComponentSettings.make(
            withEnabled: enabled,
            pulsingEnabled: pulsingEnabled,
            pulsingColor: pulsingColor,
            pulsingMaxRadius: pulsingRadius,
            showAccuracyRing: showAccuracyRing,
            accuracyRingColor: accuracyRingColor,
            accuracyRingBorderColor: accuracyRingBorderColor,
            layerAbove: nil,
            layerBelow: nil,
            puckBearingEnabled: puckBearingEnabled,
            puckBearing: .init(value: puckBearing),
            locationPuck: locationPuck
        )
    }
}

private extension PuckBearing {

    init?(_ box: FLT_SETTINGSPuckBearingBox) {
        switch box.value {
        case .HEADING: self = .heading
        case .COURSE: self = .course
        @unknown default: return nil
        }
    }

    func toFLTPuckBearing() -> FLT_SETTINGSPuckBearing {
        switch self {
        case .heading: return .HEADING
        case .course: return .COURSE
        }
    }
}
