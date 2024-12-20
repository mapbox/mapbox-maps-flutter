@_spi(Experimental) import MapboxMaps
import UIKit
import Flutter

final class LocationController: _LocationComponentSettingsInterface {
    func updateSettings(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Bool) throws {
        do {
            mapView.location.options = try mapView.location.options.fromFLT_SETTINGSLocationComponentSettings(
                settings: settings,
                useDefaultPuck2DIfNeeded: useDefaultPuck2DIfNeeded)
        } catch let settingsError {
            throw FlutterError(code: "0", message: settingsError.localizedDescription, details: settingsError)
        }
    }

    func getSettings() throws -> LocationComponentSettings {
        return mapView.location.options.toFLT_SETTINGSLocationComponentSettings()
    }

    private let mapView: MapView

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}

extension LocationOptions {

    func fromFLT_SETTINGSLocationComponentSettings(
        settings: LocationComponentSettings,
        useDefaultPuck2DIfNeeded: Bool
    ) throws -> LocationOptions {
        var options = LocationOptions()
        if let puckBearingEnabled = settings.puckBearingEnabled {
            options.puckBearingEnabled = puckBearingEnabled
        }

        if let puckBearing = settings.puckBearing.flatMap(MapboxMaps.PuckBearing.init) {
            options.puckBearing = puckBearing
        }

        if settings.enabled == false {
            options.puckType = nil
        } else if let puck3D = settings.locationPuck?.locationPuck3D {
            let model = Model(
                uri: puck3D.modelUri.flatMap(URL.init(string:)),
                position: puck3D.position?.compacted()
            )
            var configuration = Puck3DConfiguration(
                model: model
            )
            if let opacity = puck3D.modelOpacity {
                configuration.modelOpacity = .constant(opacity)
            }
            if let scale = puck3D.modelScale {
                configuration.modelScale = .constant(scale.compactMap { $0 })
            }
            if let scaleExpressionData = puck3D.modelScaleExpression?.data(using: .utf8) {
                let decodedExpression = try! JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                configuration.modelScale = .expression(decodedExpression)
            }
            if let rotation = puck3D.modelRotation {
                configuration.modelRotation = .constant(rotation.compactMap { $0 })
            }
            if let slot = settings.slot {
                configuration.slot = Slot(rawValue: slot)
            }
            options.puckType = .puck3D(configuration)
        } else if let puck2D = settings.locationPuck?.locationPuck2D {
            var configuration = useDefaultPuck2DIfNeeded
            ? Puck2DConfiguration.makeDefault(showBearing: options.puckBearingEnabled)
            : Puck2DConfiguration()

            if let topImage = puck2D.topImage {
                configuration.topImage = UIImage(data: topImage.data, scale: UIScreen.main.scale)
            }
            if let bearingImage = puck2D.bearingImage {
                configuration.bearingImage = UIImage(data: bearingImage.data, scale: UIScreen.main.scale)
            }
            if let shadowImage = puck2D.shadowImage {
                configuration.shadowImage = UIImage(data: shadowImage.data, scale: UIScreen.main.scale)
            }

            if let scaleData = puck2D.scaleExpression?.data(using: .utf8) {
                configuration.scale = try JSONDecoder().decode(Value<Double>.self, from: scaleData)
            }
            if let color = settings.accuracyRingColor {
                configuration.accuracyRingColor = uiColorFromHex(rgbValue: color)
            }
            if let color = settings.accuracyRingBorderColor {
                configuration.accuracyRingBorderColor = uiColorFromHex(rgbValue: color)
            }
            if let showAccuracyRing = settings.showAccuracyRing {
                configuration.showsAccuracyRing = showAccuracyRing
            }
            if settings.pulsingEnabled ?? false {
                var pulsing = Puck2DConfiguration.Pulsing()

                if let radius = settings.pulsingMaxRadius {
                    // -1 indicates "accuracy" mode(from Android)
                    pulsing.radius = radius == -1 ? .accuracy : .constant(Double(radius))
                }
                if let color = settings.pulsingColor {
                    pulsing.color = uiColorFromHex(rgbValue: color)
                }
                configuration.pulsing = pulsing
            }

            if let opacity = puck2D.opacity {
                configuration.opacity = opacity
            }
            if let slot = settings.slot {
                configuration.slot = Slot(rawValue: slot)
            }

            options.puckType = .puck2D(configuration)
        }
        return options
    }

    func toFLT_SETTINGSLocationComponentSettings() -> LocationComponentSettings {
        var accuracyRingColor: Int64?
        var accuracyRingBorderColor: Int64?
        var showAccuracyRing: Bool?
        var pulsingEnabled: Bool?
        var pulsingRadius: Double?
        var pulsingColor: Int64?
        var slot: String?
        var locationPuck2D = LocationPuck2D()
        var locationPuck3D = LocationPuck3D()

        if case .puck2D(let oldConfiguration) = self.puckType {
            accuracyRingColor = Int64(oldConfiguration.accuracyRingColor.rgb())
            accuracyRingBorderColor = Int64(oldConfiguration.accuracyRingBorderColor.rgb())
            showAccuracyRing = oldConfiguration.showsAccuracyRing
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
            locationPuck2D.opacity = oldConfiguration.opacity
            if let pulsing = oldConfiguration.pulsing {
                pulsingEnabled = true
                switch pulsing.radius {
                case .accuracy:
                    pulsingRadius = -1
                case .constant(let radius):
                    pulsingRadius = radius
                }
                pulsingColor = Int64(pulsing.color.rgb())
            }
            slot = oldConfiguration.slot?.rawValue
        }
        if case .puck3D(let oldConfiguration) = self.puckType {
            locationPuck3D.modelUri = oldConfiguration.model.uri?.absoluteString
            locationPuck3D.position = oldConfiguration.model.position?.compactMap { $0 }
            if case .constant(let opacityData) = oldConfiguration.modelOpacity {
                locationPuck3D.modelOpacity = opacityData
            }
            if case .constant(let scaleData) = oldConfiguration.modelScale {
                locationPuck3D.modelScale = scaleData.compactMap { $0 }
            }
            if case .expression(let scaleExpression) = oldConfiguration.modelScale {
                let encoded = try! JSONEncoder().encode(scaleExpression)
                locationPuck3D.modelScaleExpression = String(data: encoded, encoding: .utf8)
            }
            if case .constant(let rotationData) = oldConfiguration.modelRotation {
                locationPuck3D.modelRotation = rotationData.compactMap { $0 }
            }
            slot = oldConfiguration.slot?.rawValue
        }

        return LocationComponentSettings(
            enabled: puckType != nil,
            pulsingEnabled: pulsingEnabled,
            pulsingColor: pulsingColor,
            pulsingMaxRadius: pulsingRadius,
            showAccuracyRing: showAccuracyRing,
            accuracyRingColor: accuracyRingColor,
            accuracyRingBorderColor: accuracyRingBorderColor,
            layerAbove: nil,
            layerBelow: nil,
            puckBearingEnabled: puckBearingEnabled,
            puckBearing: puckBearing.toFLTPuckBearing(),
            slot: slot,
            locationPuck: LocationPuck(locationPuck2D: locationPuck2D, locationPuck3D: locationPuck3D)
        )
    }
}

private extension MapboxMaps.PuckBearing {
    init?(_ fltValue: PuckBearing) {
        switch fltValue {
        case .hEADING: self = .heading
        case .cOURSE: self = .course
        }
    }

    func toFLTPuckBearing() -> PuckBearing {
        switch self {
        case .heading: return .hEADING
        case .course: return .cOURSE
        }
    }
}
