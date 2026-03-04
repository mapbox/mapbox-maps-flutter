import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class CompassController: CompassSettingsInterface {

    func updateSettings(settings: CompassSettings) throws {
        var compass = ornaments.options.compass
        switch settings.position {
        case .bOTTOMLEFT:
            compass.position = .bottomLeading
            compass.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginBottom ?? 0)
        case .bOTTOMRIGHT:
            compass.position = .bottomTrailing
            compass.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginBottom ?? 0)
        case .tOPLEFT:
            compass.position = .topLeading
            compass.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginTop ?? 0)
        case .tOPRIGHT, .none:
            compass.position = .topTrailing
            compass.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginTop ?? 0)
        }

        if let data = settings.image?.data {
            compass.image = UIImage(data: data, scale: UIScreen.main.scale)
        }

        if let visible = settings.enabled {
            let fadeWhenFacingNorth = settings.fadeWhenFacingNorth ?? true

            let visibility: OrnamentVisibility
            switch (visible, fadeWhenFacingNorth) {
            case (true, true): visibility = .adaptive
            case (true, false): visibility = .visible
            case (false, _): visibility = .hidden
            }

            compass.visibility = visibility
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
            enabled: true,
            position: position,
            marginLeft: options.margins.x,
            marginTop: options.margins.y,
            marginRight: options.margins.x,
            marginBottom: options.margins.y,
            opacity: 1,
            rotation: 0,
            visibility: visibility,
            fadeWhenFacingNorth: fadeNorth,
            clickable: true,
            image: topImage
        )
    }

    func getFLT_SETTINGSOrnamentPosition(position: MapboxMaps.OrnamentPosition) -> OrnamentPosition {
        switch position {
        case .bottomLeading:
            return .bOTTOMLEFT
        case  .bottomTrailing:
            return .bOTTOMRIGHT
        case .topLeading:
            return .tOPLEFT
        default:
            return.tOPRIGHT
        }
    }

    private var ornaments: OrnamentsManager
    private var cancelable: Cancelable?

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
    }
}
