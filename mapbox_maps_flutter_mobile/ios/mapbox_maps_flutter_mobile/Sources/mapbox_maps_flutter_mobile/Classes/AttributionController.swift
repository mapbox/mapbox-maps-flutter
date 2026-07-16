import Foundation
@_spi(Experimental) @_spi(Restricted) import MapboxMaps

final class AttributionController: AttributionSettingsInterface {

    func updateSettings(settings: AttributionSettings) throws {
        var attributionButton = ornaments.options.attributionButton
        if let position = settings.position {
            attributionButton.position = toNativeOrnamentPosition(position)
        }
        attributionButton.margins = margins.apply(
            marginLeft: settings.marginLeft,
            marginTop: settings.marginTop,
            marginRight: settings.marginRight,
            marginBottom: settings.marginBottom,
            for: attributionButton.position)
        if let enabled = settings.enabled {
            attributionButton.visibility = enabled ? .visible : .hidden
        }
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
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom,
            clickable: nil
        )
    }

    private var ornaments: OrnamentsManager
    private var cancelable: Cancelable?
    private var margins: OrnamentMargins

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.attributionButton.margins)
    }
}
