import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class LocationController: NSObject, FLT_SETTINGSLocationComponentSettingsInterface {
    func updateSettingsSettings(_ settings: FLT_SETTINGSLocationComponentSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        mapView.location.options = mapView.location.options.fromFLT_SETTINGSLocationComponentSettings(settings: settings)
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
    func fromFLT_SETTINGSLocationComponentSettings(settings: FLT_SETTINGSLocationComponentSettings) -> LocationOptions {
        var options = LocationOptions()
        if let puckBearingEnabled = settings.puckBearingEnabled {
            options.puckBearingEnabled = puckBearingEnabled.boolValue
        }
        switch settings.puckBearingSource {
        case .COURSE:
            options.puckBearingSource = .course
        default:
            options.puckBearingSource = .heading
        }
        if settings.enabled == false {
            options.puckType = nil
        } else {
            if let puck3D = settings.locationPuck?.locationPuck3D {
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
            } else {
                var configuration: Puck2DConfiguration = { () -> Puck2DConfiguration in
                    if case .puck2D(let configuration) = self.puckType {
                        return configuration
                    } else {
                        return Puck2DConfiguration.makeDefault(showBearing: settings.puckBearingEnabled?.boolValue ?? false)
                    }
                }()
                if let bearingImage = settings.locationPuck?.locationPuck2D?.bearingImage {
                    configuration.bearingImage = UIImage(data: bearingImage.data, scale: UIScreen.main.scale)
                }
                if let shadowImage = settings.locationPuck?.locationPuck2D?.shadowImage {
                    configuration.shadowImage = UIImage(data: shadowImage.data, scale: UIScreen.main.scale)
                }
                if let topImage = settings.locationPuck?.locationPuck2D?.topImage {
                    configuration.topImage = UIImage(data: topImage.data, scale: UIScreen.main.scale)
                }
                if let scaleExpressionData = settings.locationPuck?.locationPuck2D?.scaleExpression?.data(using: .utf8) {
                    let decodedExpression = try! JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                    configuration.scale = .expression(decodedExpression)
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

                options.puckType = .puck2D(configuration)
            }
        }
        return options
    }

    func toFLT_SETTINGSLocationComponentSettings() -> FLT_SETTINGSLocationComponentSettings {
        var enabled: NSNumber?
        if self.puckType != nil {
            enabled = NSNumber(true)
        }
        let puckBearingEnabled = NSNumber(value: self.puckBearingEnabled)
        let puckBearingSource: FLT_SETTINGSPuckBearingSource = self.puckBearingSource == .heading ?
            .HEADING : .COURSE
        var accuracyRingColor: NSNumber?
        var accuracyRingBorderColor: NSNumber?
        var showAccuracyRing: NSNumber?
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

        return FLT_SETTINGSLocationComponentSettings.make(withEnabled: enabled, pulsingEnabled: nil, pulsingColor: nil, pulsingMaxRadius: nil, showAccuracyRing: showAccuracyRing, accuracyRingColor: accuracyRingColor, accuracyRingBorderColor: accuracyRingBorderColor, layerAbove: nil, layerBelow: nil, puckBearingEnabled: puckBearingEnabled, puckBearingSource: puckBearingSource, locationPuck: locationPuck)
    }
}
