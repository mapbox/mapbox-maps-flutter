import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class IndoorSelectorController: IndoorSelectorSettingsInterface {
    func updateSettings(settings: IndoorSelectorSettings) throws {
        var indoorSettings = ornaments.options.indoorSelector
        if let position = settings.position {
            indoorSettings.position = toNativeOrnamentPosition(position)
        }
        indoorSettings.margins = margins.apply(
            marginLeft: settings.marginLeft,
            marginTop: settings.marginTop,
            marginRight: settings.marginRight,
            marginBottom: settings.marginBottom,
            for: indoorSettings.position)
        if let enabled = settings.enabled {
            indoorSettings.visibility = enabled ? .visible : .hidden
        }
        ornaments.options.indoorSelector = indoorSettings
    }

    func getSettings() throws -> IndoorSelectorSettings {
        let options = ornaments.options.indoorSelector
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        return IndoorSelectorSettings(
            enabled: options.visibility != .hidden,
            position: position,
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom
        )
    }

    private var ornaments: OrnamentsManager
    private var margins: OrnamentMargins

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.indoorSelector.margins)
    }
}
