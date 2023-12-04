import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class CompassController: NSObject, FLT_SETTINGSCompassSettingsInterface {

    func updateSettingsSettings(_ settings: FLT_SETTINGSCompassSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        var compass = mapView.ornaments.options.compass
        switch settings.position?.value {
        case .BOTTOM_LEFT:
            compass.position = .bottomLeading
            compass.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
        case .BOTTOM_RIGHT:
            compass.position = .bottomTrailing
            compass.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginBottom?.CGFloat ?? 0.0)
        case .TOP_LEFT:
            compass.position = .topLeading
            compass.margins = CGPoint(x: settings.marginLeft?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
        case .TOP_RIGHT, .none:
            compass.position = .topTrailing
            compass.margins = CGPoint(x: settings.marginRight?.CGFloat ?? 0.0, y: settings.marginTop?.CGFloat ?? 0.0)
        }

        if let data = settings.image?.data {
            compass.image = UIImage(data: data, scale: UIScreen.main.scale)
        }

        if let visible = settings.enabled?.boolValue {
            let fadeWhenFacingNorth = settings.fadeWhenFacingNorth?.boolValue ?? true

            let visibility: OrnamentVisibility
            switch (visible, fadeWhenFacingNorth) {
            case (true, true): visibility = .adaptive
            case (true, false): visibility = .visible
            case (false, _): visibility = .hidden
            }

            compass.visibility = visibility
        }

        mapView.ornaments.options.compass = compass
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

        let settings = FLT_SETTINGSCompassSettings.make(
            withEnabled: true,
            position: .init(value: position),
            marginLeft: NSNumber(value: options.margins.x),
            marginTop: NSNumber(value: options.margins.y),
            marginRight: NSNumber(value: options.margins.x),
            marginBottom: NSNumber(value: options.margins.y),
            opacity: NSNumber(value: 0.0),
            rotation: NSNumber(value: 0.0),
            visibility: visibility,
            fadeWhenFacingNorth: fadeNorth,
            clickable: true,
            image: topImage
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
