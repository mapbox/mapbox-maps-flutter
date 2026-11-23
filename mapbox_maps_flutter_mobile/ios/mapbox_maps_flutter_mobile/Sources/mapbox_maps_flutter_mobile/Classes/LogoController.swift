import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class LogoController: LogoSettingsInterface {
    func updateSettings(settings: LogoSettings) throws {
        var logo = ornaments.options.logo
        if let position = settings.position {
            logo.position = toNativeOrnamentPosition(position)
        }
        logo.margins = margins.apply(
            marginLeft: settings.marginLeft,
            marginTop: settings.marginTop,
            marginRight: settings.marginRight,
            marginBottom: settings.marginBottom,
            for: logo.position)
        if let enabled = settings.enabled {
            logo.visibility = enabled ? .visible : .hidden
        }
        ornaments.options.logo = logo
    }

    func getSettings() throws -> LogoSettings {
        let options = ornaments.options.logo
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        return LogoSettings(
            enabled: options.visibility != .hidden,
            position: position,
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom
        )
    }

    private var ornaments: OrnamentsManager
    private var cancelable: Cancelable?
    private var margins: OrnamentMargins

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.logo.margins)
    }
}
