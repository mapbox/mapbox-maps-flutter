import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class ScaleBarController: NSObject, FLT_SETTINGSScaleBarSettingsInterface {

    func updateSettingsSettings(_ settings: FLT_SETTINGSScaleBarSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        switch settings.position {
        case .BOTTOM_LEFT:
            mapView.ornaments.options.scaleBar.position = .bottomLeading
            mapView.ornaments.options.scaleBar.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .BOTTOM_RIGHT:
            mapView.ornaments.options.scaleBar.position = .bottomTrailing
            mapView.ornaments.options.scaleBar.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_LEFT:
            mapView.ornaments.options.scaleBar.position = .topLeading
            mapView.ornaments.options.scaleBar.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_RIGHT:
            mapView.ornaments.options.scaleBar.position = .topTrailing
            mapView.ornaments.options.scaleBar.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        }
        if let isMetric = settings.isMetricUnits?.boolValue {
            mapView.ornaments.options.scaleBar.useMetricUnits = isMetric
        }
        if let visible = settings.enabled {
            if !visible.boolValue {
                mapView.ornaments.options.scaleBar.visibility = OrnamentVisibility.hidden
            } else {
                mapView.ornaments.options.scaleBar.visibility = OrnamentVisibility.adaptive
            }
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSScaleBarSettings? {
        let options = mapView.ornaments.options.scaleBar
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)

        let settings = FLT_SETTINGSScaleBarSettings.make(
            withEnabled: NSNumber(value: mapView.ornaments.options.scaleBar.visibility != OrnamentVisibility.hidden),
            position: position,
            marginLeft: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginTop: NSNumber(value: options.margins.y * UIScreen.main.scale),
            marginRight: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginBottom: NSNumber(value: options.margins.y * UIScreen.main.scale),
            textColor: nil,
            primaryColor: nil,
            secondaryColor: nil,
            borderWidth: nil,
            height: nil,
            textBarMargin: nil,
            textBorderWidth: nil,
            textSize: nil,
            isMetricUnits: NSNumber(value: mapView.ornaments.options.scaleBar.useMetricUnits),
            refreshInterval: nil,
            showTextBorder: nil,
            ratio: nil,
            useContinuousRendering: nil)

        return settings
    }

    func getFLT_SETTINGSOrnamentPosition(position: OrnamentPosition) -> FLT_SETTINGSOrnamentPosition {
        switch position {
        case .bottomLeading:
            return .BOTTOM_LEFT
        case  .bottomTrailing:
            return .BOTTOM_RIGHT
        case .topLeading:
            return .TOP_LEFT
        default:
            return.TOP_RIGHT
        }
    }

    private var mapView: MapView
    private var cancelable: Cancelable?

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}
