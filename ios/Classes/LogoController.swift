import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class LogoController: NSObject, FLT_SETTINGSLogoSettingsInterface {
    func updateSettingsSettings(_ settings: FLT_SETTINGSLogoSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        var logo = mapView.ornaments.options.logo
        switch settings.position?.value {
        case .BOTTOM_LEFT, .none:
            logo.position = .bottomLeading
            logo.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .BOTTOM_RIGHT:
            logo.position = .bottomTrailing
            logo.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_LEFT:
            logo.position = .topLeading
            logo.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_RIGHT:
            logo.position = .topTrailing
            logo.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        }

        mapView.ornaments.options.logo = logo
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSLogoSettings? {
        let options = mapView.ornaments.options.logo
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        let settings = FLT_SETTINGSLogoSettings.make(
            withPosition: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginTop: NSNumber(value: options.margins.y * UIScreen.main.scale),
            marginRight: NSNumber(value: options.margins.x * UIScreen.main.scale),
            marginBottom: NSNumber(value: options.margins.y * UIScreen.main.scale)
        )
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
