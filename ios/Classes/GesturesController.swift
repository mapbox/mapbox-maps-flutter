import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit

class GesturesController: NSObject, FLT_SETTINGSGesturesSettingsInterface, UIGestureRecognizerDelegate, GestureManagerDelegate {

    private var onGestureListener: FLT_GESTURESGestureListener?

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {}

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        switch gestureType {
        case .pan:
            let point = Point(mapView.mapboxMap.coordinate(for: gestureManager.panGestureRecognizer.location(in: mapView)))
            self.onGestureListener?.onScroll(FLT_GESTURESScreenCoordinate.makeWith(x: NSNumber(value: point.coordinates.latitude), y: NSNumber(value: point.coordinates.longitude)), completion: {_ in })
        case .singleTap:
            let point = Point(mapView.mapboxMap.coordinate(for: gestureManager.singleTapGestureRecognizer.location(in: mapView)))
            self.onGestureListener?.onTap(FLT_GESTURESScreenCoordinate.makeWith(x: NSNumber(value: point.coordinates.latitude), y: NSNumber(value: point.coordinates.longitude)), completion: {_ in })
        default: break
        }
    }

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {}

    @objc private func onMapLongTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let point = Point(mapView.mapboxMap.coordinate(for: sender.location(in: mapView)))
        self.onGestureListener?.onLongTap(FLT_GESTURESScreenCoordinate.makeWith(x: NSNumber(value: point.coordinates.latitude), y: NSNumber(value: point.coordinates.longitude)), completion: {_ in })
    }

    func updateSettingsSettings(_ settings: FLT_SETTINGSGesturesSettings, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        if let panEnabled = settings.scrollEnabled {
            mapView.gestures.options.panEnabled = panEnabled.boolValue
        }
        if let rotateEnabled = settings.rotateEnabled {
            mapView.gestures.options.rotateEnabled = rotateEnabled.boolValue
        }
        if let simultaneousRotateAndPinchZoomEnabled = settings.simultaneousRotateAndPinchToZoomEnabled {
            mapView.gestures.options.simultaneousRotateAndPinchZoomEnabled = simultaneousRotateAndPinchZoomEnabled.boolValue
        }
        if let pinchPanEnabled = settings.pinchPanEnabled {
            mapView.gestures.options.pinchPanEnabled = pinchPanEnabled.boolValue
        }
        if let pitchEnabled = settings.pitchEnabled {
            mapView.gestures.options.pitchEnabled = pitchEnabled.boolValue
        }
        if let doubleTapToZoomInEnabled = settings.doubleTapToZoomInEnabled {
            mapView.gestures.options.doubleTapToZoomInEnabled = doubleTapToZoomInEnabled.boolValue
        }
        if let doubleTouchToZoomOutEnabled = settings.doubleTouchToZoomOutEnabled {
            mapView.gestures.options.doubleTouchToZoomOutEnabled = doubleTouchToZoomOutEnabled.boolValue
        }
        if let quickZoomEnabled = settings.quickZoomEnabled {
            mapView.gestures.options.quickZoomEnabled = quickZoomEnabled.boolValue
        }
        if let pinchZoomEnabled = settings.pinchToZoomEnabled {
            mapView.gestures.options.pinchZoomEnabled = pinchZoomEnabled.boolValue
        }
        switch settings.scrollMode {
        case .HORIZONTAL:
            mapView.gestures.options.panMode = PanMode.horizontal
        case .VERTICAL:
            mapView.gestures.options.panMode = PanMode.vertical
        case .HORIZONTAL_AND_VERTICAL:
            mapView.gestures.options.panMode = PanMode.horizontalAndVertical
        @unknown default: break
        }
        if let focalPoint = settings.focalPoint {
            mapView.gestures.options.focalPoint = CGPoint(x: focalPoint.x.doubleValue, y: focalPoint.y.doubleValue)
        }
    }

    func getSettingsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLT_SETTINGSGesturesSettings? {
        let options = mapView.gestures.options
        let scrollMode: FLT_SETTINGSScrollMode
        switch options.panMode {
        case .horizontal:
            scrollMode = FLT_SETTINGSScrollMode.HORIZONTAL
        case .vertical:
            scrollMode = FLT_SETTINGSScrollMode.VERTICAL
        case .horizontalAndVertical:
            scrollMode = FLT_SETTINGSScrollMode.HORIZONTAL_AND_VERTICAL
        }
        var focalPoint: FLT_SETTINGSScreenCoordinate?
        if let focalPointSet = options.focalPoint {
            focalPoint = FLT_SETTINGSScreenCoordinate.makeWith(x: NSNumber(value: focalPointSet.x), y: NSNumber(value: focalPointSet.y))
        }

        let settings = FLT_SETTINGSGesturesSettings.make(
            withRotateEnabled: NSNumber(value: options.rotateEnabled),
            pinchToZoomEnabled: NSNumber(value: options.pinchZoomEnabled),
            scrollEnabled: NSNumber(value: options.panEnabled),
            simultaneousRotateAndPinchToZoomEnabled: NSNumber(value: options.rotateEnabled),
            pitchEnabled: NSNumber(value: options.pitchEnabled),
            scrollMode: scrollMode,
            doubleTapToZoomInEnabled: NSNumber(value: options.doubleTapToZoomInEnabled),
            doubleTouchToZoomOutEnabled: NSNumber(value: options.doubleTouchToZoomOutEnabled),
            quickZoomEnabled: NSNumber(value: options.quickZoomEnabled),
            focalPoint: focalPoint,
            pinchToZoomDecelerationEnabled: NSNumber(false),
            rotateDecelerationEnabled: NSNumber(false),
            scrollDecelerationEnabled: NSNumber(false),
            increaseRotateThresholdWhenPinchingToZoom: NSNumber(false),
            increasePinchToZoomThresholdWhenRotating: NSNumber(false),
            zoomAnimationAmount: NSNumber(value: 0.0),
            pinchPanEnabled: NSNumber(value: options.pinchPanEnabled))
        return settings
    }

    func addListeners(messenger: FlutterBinaryMessenger) {
        removeListeners()
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onMapLongTap))
        mapView.addGestureRecognizer(gestureRecognizer!)
        mapView.gestures.delegate = self
        onGestureListener = FLT_GESTURESGestureListener(binaryMessenger: messenger)
    }

    func removeListeners() {
        if let gestureRecognizer = self.gestureRecognizer {
            mapView.removeGestureRecognizer(gestureRecognizer)
        }
    }

    private var mapView: MapView
    private var gestureRecognizer: UIGestureRecognizer?
    private var cancelable: Cancelable?

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}
