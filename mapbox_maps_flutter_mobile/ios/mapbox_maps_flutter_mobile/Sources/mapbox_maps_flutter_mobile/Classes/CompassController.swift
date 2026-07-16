import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class CompassController: CompassSettingsInterface {

    func updateSettings(settings: CompassSettings) throws {
        var compass = ornaments.options.compass
        if let position = settings.position {
            compass.position = toNativeOrnamentPosition(position)
        }
        compass.margins = margins.apply(
            marginLeft: settings.marginLeft,
            marginTop: settings.marginTop,
            marginRight: settings.marginRight,
            marginBottom: settings.marginBottom,
            for: compass.position)

        if let data = settings.image?.data {
            compass.image = UIImage(data: data, scale: UIScreen.main.scale)
        }

        // Apply `enabled` and `fadeWhenFacingNorth` independently so either can be
        // changed on its own — matching the Android implementation (CompassMappings.kt).
        // Previously visibility was only updated when `enabled` was non-nil, so
        // `fadeWhenFacingNorth: false` was silently ignored on iOS and the compass
        // kept fading at north.
        if settings.enabled != nil || settings.fadeWhenFacingNorth != nil {
            let current = compass.visibility
            let enabled = settings.enabled ?? (current != .hidden)
            let fadeWhenFacingNorth = settings.fadeWhenFacingNorth ?? (current == .adaptive)

            switch (enabled, fadeWhenFacingNorth) {
            case (true, true):  compass.visibility = .adaptive
            case (true, false): compass.visibility = .visible
            case (false, _):    compass.visibility = .hidden
            }
        }

        ornaments.options.compass = compass
    }

    func getSettings() throws -> CompassSettings {
        let options = ornaments.options.compass
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        var topImage: FlutterStandardTypedData?
        if let topData = options.image?.pngData() {
            topImage = FlutterStandardTypedData(bytes: topData)
        }

        let visibility: Bool
        let fadeNorth: Bool
        switch options.visibility {
        case .adaptive:
            fadeNorth = true
            visibility = true
        case .hidden:
            fadeNorth = false
            visibility = false
        case .visible:
            fadeNorth = false
            visibility = true
        }

        return CompassSettings(
            enabled: visibility,
            position: position,
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom,
            opacity: 1,
            rotation: 0,
            visibility: visibility,
            fadeWhenFacingNorth: fadeNorth,
            clickable: true,
            image: topImage
        )
    }

    private var ornaments: OrnamentsManager
    private var cancelable: Cancelable?
    private var margins: OrnamentMargins

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.compass.margins)
    }
}
