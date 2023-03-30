import Foundation
@_spi(Restricted) import MapboxMaps
import UIKit
class AttributionController: NSObject, FLT_SETTINGSAttributionSettingsInterface {

    func updateSettingsSettings(_ settings: FLT_SETTINGSAttributionSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        switch settings.position {
        case .BOTTOM_LEFT:
            mapView.ornaments.options.attributionButton.position = .bottomLeading
            mapView.ornaments.options.attributionButton.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .BOTTOM_RIGHT:
            mapView.ornaments.options.attributionButton.position = .bottomTrailing
            mapView.ornaments.options.attributionButton.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_LEFT:
            mapView.ornaments.options.attributionButton.position = .topLeading
            mapView.ornaments.options.attributionButton.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_RIGHT:
            mapView.ornaments.options.attributionButton.position = .topTrailing
            mapView.ornaments.options.attributionButton.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        default:
            break
        }
        if let visible = settings.enabled {
            if !visible.boolValue {
                mapView.ornaments.options.attributionButton.visibility = OrnamentVisibility.hidden
            } else {
                mapView.ornaments.options.attributionButton.visibility = OrnamentVisibility.adaptive
            }
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSAttributionSettings? {
        let options = mapView.ornaments.options.attributionButton
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        let settings = FLT_SETTINGSAttributionSettings.make(
            withEnabled: NSNumber(value: mapView.ornaments.options.attributionButton.visibility != OrnamentVisibility.hidden),
            position: position,
            marginLeft: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginTop: NSNumber(value: options.margins.y * UIScreen.main.scale),
            marginRight: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginBottom: NSNumber(value: options.margins.y * UIScreen.main.scale),
            clickable: nil,
            iconColor: nil)


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
