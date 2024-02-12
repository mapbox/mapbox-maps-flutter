import Foundation
@_spi(Experimental) import MapboxMaps

final class ScaleBarController: ScaleBarSettingsInterface {

    func updateSettings(settings: ScaleBarSettings) throws {
        var scaleBar = ornaments.options.scaleBar
        switch settings.position {
        case .bOTTOMLEFT:
            scaleBar.position = .bottomLeading
            scaleBar.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginBottom ?? 0)
        case .bOTTOMRIGHT:
            scaleBar.position = .bottomTrailing
            scaleBar.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginBottom ?? 0)
        case .tOPLEFT, .none:
            scaleBar.position = .topLeading
            scaleBar.margins = CGPoint(x: settings.marginLeft ?? 0, y: settings.marginTop ?? 0)
        case .tOPRIGHT:
            scaleBar.position = .topTrailing
            scaleBar.margins = CGPoint(x: settings.marginRight ?? 0, y: settings.marginTop ?? 0)
        }
        if let isMetric = settings.isMetricUnits {
            scaleBar.useMetricUnits = isMetric
        }
        if let visible = settings.enabled {
            scaleBar.visibility = visible ? .adaptive : .hidden
        }

        ornaments.options.scaleBar = scaleBar
    }

    func getSettings() throws -> ScaleBarSettings {
        let options = ornaments.options.scaleBar
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)

        return ScaleBarSettings(
            enabled: ornaments.options.scaleBar.visibility != OrnamentVisibility.hidden,
            position: position,
            marginLeft: options.margins.x,
            marginTop: options.margins.y,
            marginRight: options.margins.x,
            marginBottom: options.margins.y,
            textColor: nil,
            primaryColor: nil,
            secondaryColor: nil,
            borderWidth: nil,
            height: nil,
            textBarMargin: nil,
            textBorderWidth: nil,
            textSize: nil,
            isMetricUnits: ornaments.options.scaleBar.useMetricUnits,
            refreshInterval: nil,
            showTextBorder: nil,
            ratio: nil,
            useContinuousRendering: nil)
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
