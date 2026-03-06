import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class LogoController: LogoSettingsInterface {
    func updateSettings(settings: LogoSettings) throws {
        var logo = ornaments.options.logo
        switch settings.position {
        case .bOTTOMLEFT, .none:
            logo.position = .bottomLeading
            logo.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginBottom ?? 0)
        case .bOTTOMRIGHT:
            logo.position = .bottomTrailing
            logo.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginBottom ?? 0)
        case .tOPLEFT:
            logo.position = .topLeading
            logo.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginTop ?? 0)
        case .tOPRIGHT:
            logo.position = .topTrailing
            logo.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginTop ?? 0)
        }
        logo.visibility = (settings.enabled ?? true) ? .visible : .hidden
        ornaments.options.logo = logo
    }

    func getSettings() throws -> LogoSettings {
        let options = ornaments.options.logo
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        return LogoSettings(
            enabled: options.visibility != .hidden,
            position: position,
            marginLeft: options.margins.x,
            marginTop: options.margins.y,
            marginRight: options.margins.x,
            marginBottom: options.margins.y
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
