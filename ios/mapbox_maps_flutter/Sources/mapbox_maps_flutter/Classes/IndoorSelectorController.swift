import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class IndoorSelectorController: IndoorSelectorSettingsInterface {
    func updateSettings(settings: IndoorSelectorSettings) throws {
        var indoorSettings = ornaments.options.indoorSelector
        switch settings.position {
        case .bOTTOMLEFT, .none:
            indoorSettings.position = .bottomLeading
            indoorSettings.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginBottom ?? 0)
        case .bOTTOMRIGHT:
            indoorSettings.position = .bottomTrailing
            indoorSettings.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginBottom ?? 0)
        case .tOPLEFT:
            indoorSettings.position = .topLeading
            indoorSettings.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginTop ?? 0)
        case .tOPRIGHT:
            indoorSettings.position = .topTrailing
            indoorSettings.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginTop ?? 0)
        }
        indoorSettings.visibility = (settings.enabled ?? true) ? .visible : .hidden
        ornaments.options.indoorSelector = indoorSettings
    }

    func getSettings() throws -> IndoorSelectorSettings {
        let options = ornaments.options.indoorSelector
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        return IndoorSelectorSettings(
            enabled: options.visibility != .hidden,
            position: position,
            marginLeft: options.margins.x,
            marginTop: options.margins.y,
            marginRight: options.margins.x,
            marginBottom: options.margins.y
        )
    }

    private func getFLT_SETTINGSOrnamentPosition(position: MapboxMaps.OrnamentPosition) -> OrnamentPosition {
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

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
    }
}
