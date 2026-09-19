import Foundation
@_spi(Experimental) import MapboxMaps

final class ScaleBarController: ScaleBarSettingsInterface {

    func updateSettings(settings: ScaleBarSettings) throws {
        var scaleBar = ornaments.options.scaleBar
        if let position = settings.position {
            scaleBar.position = toNativeOrnamentPosition(position)
        }
        scaleBar.margins = margins.apply(
            marginLeft: settings.marginLeft,
            marginTop: settings.marginTop,
            marginRight: settings.marginRight,
            marginBottom: settings.marginBottom,
            for: scaleBar.position)
        if let isMetric = settings.isMetricUnits {
            scaleBar.useMetricUnits = isMetric
        }
        if let visible = settings.enabled {
            scaleBar.visibility = visible ? .adaptive : .hidden
        }
        if let units = settings.distanceUnits {
            scaleBar.units = switch units {
            case .mETRIC: .metric
            case .iMPERIAL: .imperial
            case .nAUTICAL: .nautical
            }
        }
        ornaments.options.scaleBar = scaleBar
    }

    func getSettings() throws -> ScaleBarSettings {
        let options = ornaments.options.scaleBar
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        let units: DistanceUnits? = switch ornaments.options.scaleBar.units {
        case .metric: .mETRIC
        case .imperial: .iMPERIAL
        case .nautical: .nAUTICAL
        default: nil
        }
        return ScaleBarSettings(
            enabled: ornaments.options.scaleBar.visibility != OrnamentVisibility.hidden,
            position: position,
            marginLeft: margins.left,
            marginTop: margins.top,
            marginRight: margins.right,
            marginBottom: margins.bottom,
            textColor: nil,
            primaryColor: nil,
            secondaryColor: nil,
            borderWidth: nil,
            height: nil,
            textBarMargin: nil,
            textBorderWidth: nil,
            textSize: nil,
            isMetricUnits: ornaments.options.scaleBar.useMetricUnits,
            distanceUnits: units,
            refreshInterval: nil,
            showTextBorder: nil,
            ratio: nil,
            useContinuousRendering: nil)
    }

    private var ornaments: OrnamentsManager
    private var cancelable: Cancelable?
    private var margins: OrnamentMargins

    init(withMapView mapView: MapView) {
        self.ornaments = mapView.ornaments
        self.margins = OrnamentMargins(seedingFrom: mapView.ornaments.options.scaleBar.margins)
    }
}
