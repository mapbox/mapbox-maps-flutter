import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class CompassController: NSObject, FLT_SETTINGSCompassSettingsInterface {

    func updateSettingsSettings(_ settings: FLT_SETTINGSCompassSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        switch settings.position {
        case .BOTTOM_LEFT:
            mapView.ornaments.options.compass.position = .bottomLeading
            mapView.ornaments.options.compass.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .BOTTOM_RIGHT:
            mapView.ornaments.options.compass.position = .bottomTrailing
            mapView.ornaments.options.compass.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginBottom?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_LEFT:
            mapView.ornaments.options.compass.position = .topLeading
            mapView.ornaments.options.compass.margins = CGPoint(x: (settings.marginLeft?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        case .TOP_RIGHT:
            mapView.ornaments.options.compass.position = .topTrailing
            mapView.ornaments.options.compass.margins = CGPoint(x: (settings.marginRight?.CGFloat ?? 0.0)/UIScreen.main.scale, y: (settings.marginTop?.CGFloat ?? 0.0)/UIScreen.main.scale)
        }

        if let data = settings.image?.data {
            mapView.ornaments.options.compass.image = UIImage(data: data, scale: UIScreen.main.scale)
        }

        if let visible = settings.enabled {
            if !visible.boolValue {
                mapView.ornaments.options.compass.visibility = OrnamentVisibility.hidden
            } else {
                if settings.fadeWhenFacingNorth?.boolValue ?? true {
                    mapView.ornaments.options.compass.visibility = OrnamentVisibility.adaptive
                } else {
                    mapView.ornaments.options.compass.visibility = OrnamentVisibility.visible
                }
            }
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSCompassSettings? {
        let options = mapView.ornaments.options.compass
        let position = getFLT_SETTINGSOrnamentPosition(position: options.position)
        var topImage: FlutterStandardTypedData?
        if let topData = options.image?.pngData() {
            topImage = FlutterStandardTypedData(bytes: topData)
        }

        var visibility: NSNumber
        var fadeNorth: NSNumber
        switch options.visibility {
        case .adaptive:
            fadeNorth = true
            visibility = true
        case .hidden:
            fadeNorth = false
            visibility = false
        case .visible:
            fadeNorth = false
            visibility = true
        }

        let settings = FLT_SETTINGSCompassSettings.make(withEnabled: true, position: position, marginLeft: NSNumber(value: options.margins.x * UIScreen.main.scale), marginTop: NSNumber(value: options.margins.y * UIScreen.main.scale), marginRight: NSNumber(value: options.margins.x * UIScreen.main.scale), marginBottom: NSNumber(value: options.margins.y * UIScreen.main.scale), opacity: NSNumber(value: 0.0), rotation: NSNumber(value: 0.0), visibility: visibility, fadeWhenFacingNorth: fadeNorth, clickable: true, image: topImage)

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
