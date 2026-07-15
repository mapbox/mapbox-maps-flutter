import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class AttributionController: AttributionSettingsInterface {

    func updateSettings(settings: AttributionSettings) throws {
        var attributionButton = ornaments.options.attributionButton
        switch settings.position {
        case .bOTTOMLEFT:
            attributionButton.position = .bottomLeading
            attributionButton.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginBottom ?? 0)
        case .bOTTOMRIGHT, .none:
            attributionButton.position = .bottomTrailing
            attributionButton.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginBottom ?? 0)
        case .tOPLEFT:
            attributionButton.position = .topLeading
            attributionButton.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginTop ?? 0)
        case .tOPRIGHT:
            attributionButton.position = .topTrailing
            attributionButton.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginTop ?? 0)
        }
        attributionButton.visibility = (settings.enabled ?? true) ? .visible : .hidden
        ornaments.options.attributionButton = attributionButton

        if let iconColor = settings.iconColor {
            ornaments.attributionButton.tintColor = uiColorFromHex(rgbValue: iconColor)
        }
    }

    func getSettings() throws -> AttributionSettings {
        let options = ornaments.options.attributionButton
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        let iconColor = ornaments.attributionButton.tintColor.rgb()

        return AttributionSettings(
            enabled: options.visibility != .hidden,
            iconColor: Int64(iconColor),
            position: position,
            marginLeft: options.margins.x,
            marginTop: options.margins.y,
            marginRight: options.margins.x,
            marginBottom: options.margins.y,
            clickable: nil
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
