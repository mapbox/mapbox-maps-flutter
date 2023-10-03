import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class AttributionController: NSObject, FLT_SETTINGSAttributionSettingsInterface {

    func updateSettingsSettings(_ settings: FLT_SETTINGSAttributionSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        var options = mapView.ornaments.options
        switch settings.position?.value {
        case .BOTTOM_LEFT:
            options.attributionButton.position = .bottomLeading
            options.attributionButton.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .BOTTOM_RIGHT, .none:
            options.attributionButton.position = .bottomTrailing
            options.attributionButton.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_LEFT:
            options.attributionButton.position = .topLeading
            options.attributionButton.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_RIGHT:
            options.attributionButton.position = .topTrailing
            options.attributionButton.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        }

        mapView.ornaments.options = options
        if let iconColor = settings.iconColor?.intValue {
            mapView.ornaments.attributionButton.tintColor = uiColorFromHex(rgbValue: iconColor)
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSAttributionSettings? {
        let options = mapView.ornaments.options.attributionButton
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        let iconColor = mapView.ornaments.attributionButton.tintColor.rgb()

        let settings = FLT_SETTINGSAttributionSettings.make(
            withIconColor: NSNumber(value: iconColor),
            position: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginTop: NSNumber(value: options.margins.y * UIScreen.main.scale),
            marginRight: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginBottom: NSNumber(value: options.margins.y * UIScreen.main.scale),
            clickable: nil)

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
