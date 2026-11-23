import Combine
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
        ornaments.options.indoorSelector = indoorSettings
        if let settingsEnabled = settings.enabled {
            enabled = settingsEnabled
        }
        applyVisibility()
    }

    func getSettings() throws -> IndoorSelectorSettings {
        let options = ornaments.options.indoorSelector
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        return IndoorSelectorSettings(
            enabled: enabled,
            position: position,
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom
        )
    }

    private var ornaments: OrnamentsManager
    private var margins: OrnamentMargins
    private var enabled = true
    private var hasFloors = false
    private var cancellable: AnyCancellable?

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.indoorSelector.margins)

        // Drive visibility off the same IndoorManager updates mapboxMap.indoor
        // exposes, instead of relying on the ornament's own `.adaptive` mode:
        // it defaults to `.hidden`, so this also handles the initial state.
        cancellable = mapView.mapboxMap.indoor.onIndoorUpdated.sink { [weak self] state in
            guard let self else { return }
            hasFloors = !state.floors.isEmpty
            applyVisibility()
        }
    }

    private func applyVisibility() {
        var indoorSettings = ornaments.options.indoorSelector
        indoorSettings.visibility = (enabled && hasFloors) ? .visible : .hidden
        ornaments.options.indoorSelector = indoorSettings
    }
}
