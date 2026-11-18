@_spi(Experimental) import MapboxMaps
import UIKit
import Flutter

final class LocationController: _LocationComponentSettingsInterface {
    // Native `puckType` conflates appearance with visibility (hiding == nil), so
    // we track the real config here and only project it onto `puckType` while
    // enabled, keeping `enabled` an independent setting as it is on Android.
    private var isEnabled = false
    private var puckType: PuckType?

    // Native `puckType` drops the other type's config when switched, including
    // pulsing/accuracy ring embedded in Puck2DConfiguration. Android keeps those
    // independent, so we cache the last 2D config to carry them forward.
    private var puck2DConfiguration: Puck2DConfiguration?

    // Same idea for the 3D puck.
    private var puck3DConfiguration: Puck3DConfiguration?

    func updateSettings(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Bool) throws {
        do {
            if let enabled = settings.enabled {
                isEnabled = enabled
            }

            var options = mapView.location.options
            options.puckType = puckType
            options = try options.fromFLT_SETTINGSLocationComponentSettings(
                settings: settings,
                useDefaultPuck2DIfNeeded: useDefaultPuck2DIfNeeded,
                puck2DConfiguration: puck2DConfiguration,
                puck3DConfiguration: puck3DConfiguration)
            puckType = options.puckType
            if case .puck2D(let configuration) = options.puckType {
                puck2DConfiguration = configuration
            }
            if case .puck3D(let configuration) = options.puckType {
                puck3DConfiguration = configuration
            }
            options.puckType = isEnabled ? puckType : nil
            mapView.location.options = options
        } catch let settingsError {
            // `details` must stay codec-serializable; a raw Swift error crashes
            // the platform channel's reply encoder.
            throw FlutterError(code: "0", message: settingsError.localizedDescription, details: nil)
        }
    }

    func getSettings() throws -> LocationComponentSettings {
        var options = mapView.location.options
        options.puckType = puckType
        var result = options.toFLT_SETTINGSLocationComponentSettings()
        result.enabled = isEnabled
        return result
    }

    private let mapView: MapView

    // Native location-provider override, so the puck can be driven by an
    // externally-supplied combined GPS+indoor location provider instead of
    // Mapbox's default `AppleLocationProvider`.
    private let externalLocationProvider = ExternalLocationProvider()
    private var isOverrideActive = false
    private var externalLocationChannel: FlutterMethodChannel?

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }

    /// Sets up the plain `FlutterMethodChannel` for `setExternalLocation`/
    /// `clearExternalLocation`. Deliberately not Pigeon-generated — Mapbox
    /// doesn't ship the Pigeon input specs for this plugin publicly, only the
    /// generated output, so this is a small hand-written channel kept
    /// isolated from the generated code to stay easy to rebase.
    func setUpExternalLocationChannel(binaryMessenger: FlutterBinaryMessenger, channelSuffix: String) {
        let channel = FlutterMethodChannel(
            name: "plugins.flutter.io.mapbox_maps_flutter.externalLocation.\(channelSuffix)",
            binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handleExternalLocationCall(call, result: result)
        }
        externalLocationChannel = channel
    }

    private func handleExternalLocationCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setExternalLocation":
            setExternalLocation(arguments: call.arguments, result: result)
        case "clearExternalLocation":
            clearExternalLocation(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setExternalLocation(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let latitude = args["latitude"] as? Double,
              let longitude = args["longitude"] as? Double else {
            result(FlutterError(
                code: "invalid_args",
                message: "setExternalLocation requires latitude and longitude",
                details: nil))
            return
        }

        let timestampMs = args["timestamp"] as? Double
        // `Location`'s `timestamp` is milliseconds since epoch as `UInt64`,
        // not a `Date` — see MapboxCommon's `MBXLocation`.
        let timestampMillis = UInt64(timestampMs ?? (Date().timeIntervalSince1970 * 1000))
        let accuracy = args["accuracy"] as? Double
        let heading = args["heading"] as? Double
        let headingAccuracy = args["headingAccuracy"] as? Double
        let floor = args["floor"] as? Int
        // Used below to build the `Heading` update, which takes a `Date`
        // (unlike `Location`, which takes raw millis).
        let timestampDate = Date(timeIntervalSince1970: Double(timestampMillis) / 1000)

        let location = Location(
            __latitude: latitude,
            longitude: longitude,
            timestamp: timestampMillis,
            monotonicTimestamp: nil,
            altitude: nil,
            horizontalAccuracy: accuracy.map(NSNumber.init(value:)),
            verticalAccuracy: nil,
            speed: nil,
            speedAccuracy: nil,
            bearing: heading.map(NSNumber.init(value:)),
            bearingAccuracy: headingAccuracy.map(NSNumber.init(value:)),
            floor: floor.map(NSNumber.init(value:)),
            source: "external-override",
            extra: nil)

        activateOverrideIfNeeded()
        externalLocationProvider.update(location: location)

        if let heading {
            externalLocationProvider.update(heading: Heading(
                direction: heading,
                accuracy: headingAccuracy ?? 0,
                timestamp: timestampDate))
        }

        result(nil)
    }

    /// Restores Mapbox's default `AppleLocationProvider` — "clear" means
    /// "go back to normal GPS." Intended usage: call this on a
    /// location-stream error, where presenting a stale synthetic position
    /// would be worse than falling back to GPS.
    private func clearExternalLocation(result: @escaping FlutterResult) {
        externalLocationProvider.clear()
        if isOverrideActive {
            isOverrideActive = false
            mapView.location.override(provider: AppleLocationProvider())
        }
        result(nil)
    }

    /// Registers `externalLocationProvider` with Mapbox on first use only —
    /// until `setExternalLocation` is called at least once, the map behaves
    /// exactly as it does today (default `AppleLocationProvider`).
    private func activateOverrideIfNeeded() {
        guard !isOverrideActive else { return }
        isOverrideActive = true
        mapView.location.override(provider: externalLocationProvider)
    }
}

extension LocationOptions {

    func fromFLT_SETTINGSLocationComponentSettings(
        settings: LocationComponentSettings,
        useDefaultPuck2DIfNeeded: Bool,
        puck2DConfiguration: Puck2DConfiguration?,
        puck3DConfiguration: Puck3DConfiguration?
    ) throws -> LocationOptions {
        var options = self
        if let puckBearingEnabled = settings.puckBearingEnabled {
            options.puckBearingEnabled = puckBearingEnabled
        }

        if let puckBearing = settings.puckBearing.flatMap(MapboxMaps.PuckBearing.init) {
            options.puckBearing = puckBearing
        }

        if let puck3D = settings.locationPuck?.locationPuck3D {
            // A 3D puck requires a model URI to be constructed. On a partial
            // update that omits it, reuse the currently active 3D puck (if
            // any) instead of requiring every call to resend it.
            let existingConfiguration: Puck3DConfiguration? = {
                if case .puck3D(let existing) = options.puckType {
                    return existing
                }
                return nil
            }()

            var configuration: Puck3DConfiguration
            if let existingConfiguration {
                configuration = existingConfiguration
            } else if let carryForward = puck3DConfiguration {
                // No live 3D puck (e.g. 2D showing) - restore the last known one.
                configuration = carryForward
            } else {
                guard let modelUri = puck3D.modelUri, let url = URL(string: modelUri) else {
                    throw NSError(
                        domain: "LocationController",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "modelUri must be provided the first time a 3D puck is configured."
                        ])
                }
                configuration = Puck3DConfiguration(model: Model(uri: url, position: puck3D.position?.compacted()))
            }

            if let modelUri = puck3D.modelUri, let url = URL(string: modelUri) {
                configuration.model.uri = url
            }
            if let position = puck3D.position {
                configuration.model.position = position.compacted()
            }
            if let opacity = puck3D.modelOpacity {
                configuration.modelOpacity = .constant(opacity)
            }
            if let scale = puck3D.modelScale {
                configuration.modelScale = .constant(scale.compactMap { $0 })
            }
            if let scaleExpressionData = puck3D.modelScaleExpression?.data(using: .utf8) {
                let decodedExpression = try JSONDecoder().decode(Expression.self, from: scaleExpressionData)
                configuration.modelScale = .expression(decodedExpression)
            }
            if let elevationReference = puck3D.modelElevationReference.flatMap(MapboxMaps.ModelElevationReference.init) {
                configuration.modelElevationReference = .constant(elevationReference)
            }
            if let rotation = puck3D.modelRotation {
                configuration.modelRotation = .constant(rotation.compactMap { $0 })
            }
            options.puckType = .puck3D(configuration)
        } else {
            let liveExistingConfiguration: Puck2DConfiguration? = {
                if case .puck2D(let existing) = options.puckType {
                    return existing
                }
                return nil
            }()
            let puck2D = settings.locationPuck?.locationPuck2D

            // Touch the 2D puck only when configuring one, adjusting the active
            // one, or nothing is configured yet; otherwise a live 3D puck is
            // left alone since 2D-only settings don't apply to it.
            if puck2D != nil || liveExistingConfiguration != nil || options.puckType == nil {
                var configuration: Puck2DConfiguration
                // Set when `configuration` is built fresh rather than reusing the
                // live 2D puck, so pulsing/accuracy ring must be carried forward.
                var needsCarryForward = false

                if puck2D != nil && useDefaultPuck2DIfNeeded {
                    // An explicit DefaultLocationPuck2D means "reset to the
                    // built-in look", so rebuild rather than layer on top.
                    configuration = Puck2DConfiguration.makeDefault(showBearing: options.puckBearingEnabled)
                    needsCarryForward = true
                } else if let liveExistingConfiguration {
                    configuration = liveExistingConfiguration
                } else {
                    // No 2D puck active (a 3D puck is showing, or nothing set yet) -
                    // restore the last known one if any.
                    configuration = useDefaultPuck2DIfNeeded
                    ? Puck2DConfiguration.makeDefault(showBearing: options.puckBearingEnabled)
                    : (puck2DConfiguration ?? Puck2DConfiguration())
                    needsCarryForward = true
                }

                if needsCarryForward, let carryForward = puck2DConfiguration {
                    // Pulsing and accuracy ring are independent of the icon's
                    // appearance, so they survive a reset or a detour through 3D.
                    configuration.pulsing = carryForward.pulsing
                    configuration.showsAccuracyRing = carryForward.showsAccuracyRing
                    configuration.accuracyRingColor = carryForward.accuracyRingColor
                    configuration.accuracyRingBorderColor = carryForward.accuracyRingBorderColor
                }

                if let topImage = puck2D?.topImage {
                    configuration.topImage = UIImage(data: topImage.data, scale: UIScreen.main.scale)
                }
                if let bearingImage = puck2D?.bearingImage {
                    configuration.bearingImage = UIImage(data: bearingImage.data, scale: UIScreen.main.scale)
                }
                if let shadowImage = puck2D?.shadowImage {
                    configuration.shadowImage = UIImage(data: shadowImage.data, scale: UIScreen.main.scale)
                }

                if let scaleData = puck2D?.scaleExpression?.data(using: .utf8) {
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
                let pulsingEnabled = settings.pulsingEnabled ?? (configuration.pulsing != nil)
                if pulsingEnabled {
                    var pulsing = configuration.pulsing ?? Puck2DConfiguration.Pulsing()

                    if let radius = settings.pulsingMaxRadius {
                        // -1 indicates "accuracy" mode(from Android)
                        pulsing.radius = radius == -1 ? .accuracy : .constant(Double(radius))
                    }
                    if let color = settings.pulsingColor {
                        pulsing.color = uiColorFromHex(rgbValue: color)
                    }
                    configuration.pulsing = pulsing
                } else {
                    configuration.pulsing = nil
                }

                if let opacity = puck2D?.opacity {
                    configuration.opacity = opacity
                }

                options.puckType = .puck2D(configuration)
            }
        }

        // slot applies to whichever puck type is active, regardless of
        // whether this call also (re)configures the puck itself.
        if let slot = settings.slot {
            switch options.puckType {
            case .puck2D(var configuration):
                configuration.slot = Slot(rawValue: slot)
                options.puckType = .puck2D(configuration)
            case .puck3D(var configuration):
                configuration.slot = Slot(rawValue: slot)
                options.puckType = .puck3D(configuration)
            case .none:
                break
            }
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
            if case .constant(let modelElevationReference) = oldConfiguration.modelElevationReference {
                locationPuck3D.modelElevationReference = modelElevationReference.toFLTModelElevationReference()
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

private extension MapboxMaps.ModelElevationReference {
    init?(_ fltValue: ModelElevationReference) {
        switch fltValue {
        case .gROUND: self = .ground
        case .sEA: self = .sea
        }
    }

    func toFLTModelElevationReference() -> ModelElevationReference {
        switch self {
        case .ground: return .gROUND
        case .sea: return .sEA
        default:
            return .gROUND
        }
    }
}
