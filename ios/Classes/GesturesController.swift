import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class GesturesController: NSObject, GesturesSettingsInterface, UIGestureRecognizerDelegate, GestureManagerDelegate {

    private var onGestureListener: GestureListener?

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {}

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        guard gestureType == .singleTap else {
            return
        }

        let touchPoint = gestureManager.singleTapGestureRecognizer.location(in: mapView)
        let point = Point(mapView.mapboxMap.coordinate(for: touchPoint))
        let context = MapContentGestureContext(touchPosition: touchPoint.toFLTScreenCoordinate(), point: point)

        onGestureListener?.onTap(context: context, completion: { _ in })
    }

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {}

    @objc private func onMapPan(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else {
            return
        }

        let touchPoint = sender.location(in: mapView)
        let point = Point(mapView.mapboxMap.coordinate(for: touchPoint))
        let context = MapContentGestureContext(touchPosition: touchPoint.toFLTScreenCoordinate(), point: point)

        onGestureListener?.onScroll(context: context, completion: { _ in })
    }

    @objc private func onMapLongTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }

        let touchPoint = sender.location(in: mapView)
        let point = Point(mapView.mapboxMap.coordinate(for: touchPoint))
        let context = MapContentGestureContext(touchPosition: touchPoint.toFLTScreenCoordinate(), point: point)

        onGestureListener?.onLongTap(context: context, completion: { _ in })
    }

    func updateSettings(settings: GesturesSettings) throws {
        if let panEnabled = settings.scrollEnabled {
            mapView.gestures.options.panEnabled = panEnabled
        }
        if let rotateEnabled = settings.rotateEnabled {
            mapView.gestures.options.rotateEnabled = rotateEnabled
        }
        if let simultaneousRotateAndPinchZoomEnabled = settings.simultaneousRotateAndPinchToZoomEnabled {
            mapView.gestures.options.simultaneousRotateAndPinchZoomEnabled = simultaneousRotateAndPinchZoomEnabled
        }
        if let pinchPanEnabled = settings.pinchPanEnabled {
            mapView.gestures.options.pinchPanEnabled = pinchPanEnabled
        }
        if let pitchEnabled = settings.pitchEnabled {
            mapView.gestures.options.pitchEnabled = pitchEnabled
        }
        if let doubleTapToZoomInEnabled = settings.doubleTapToZoomInEnabled {
            mapView.gestures.options.doubleTapToZoomInEnabled = doubleTapToZoomInEnabled
        }
        if let doubleTouchToZoomOutEnabled = settings.doubleTouchToZoomOutEnabled {
            mapView.gestures.options.doubleTouchToZoomOutEnabled = doubleTouchToZoomOutEnabled
        }
        if let quickZoomEnabled = settings.quickZoomEnabled {
            mapView.gestures.options.quickZoomEnabled = quickZoomEnabled
        }
        if let pinchZoomEnabled = settings.pinchToZoomEnabled {
            mapView.gestures.options.pinchZoomEnabled = pinchZoomEnabled
        }
        switch settings.scrollMode {
        case .hORIZONTAL:
            mapView.gestures.options.panMode = PanMode.horizontal
        case .vERTICAL:
            mapView.gestures.options.panMode = PanMode.vertical
        case .hORIZONTALANDVERTICAL, .none:
            mapView.gestures.options.panMode = PanMode.horizontalAndVertical
        }
        if let focalPoint = settings.focalPoint {
            mapView.gestures.options.focalPoint = CGPoint(x: focalPoint.x, y: focalPoint.y)
        }
    }

    func getSettings() throws -> GesturesSettings {
        let options = mapView.gestures.options
        let scrollMode: ScrollMode
        switch options.panMode {
        case .horizontal:
            scrollMode = .hORIZONTAL
        case .vertical:
            scrollMode = .vERTICAL
        case .horizontalAndVertical:
            scrollMode = .hORIZONTALANDVERTICAL
        }
        var focalPoint: ScreenCoordinate?
        if let focalPointSet = options.focalPoint {
            focalPoint = ScreenCoordinate(x: focalPointSet.x, y: focalPointSet.y)
        }

        return GesturesSettings(
            rotateEnabled: options.rotateEnabled,
            pinchToZoomEnabled: options.pinchZoomEnabled,
            scrollEnabled: options.panEnabled,
            simultaneousRotateAndPinchToZoomEnabled: options.rotateEnabled,
            pitchEnabled: options.pitchEnabled,
            scrollMode: scrollMode,
            doubleTapToZoomInEnabled: options.doubleTapToZoomInEnabled,
            doubleTouchToZoomOutEnabled: options.doubleTouchToZoomOutEnabled,
            quickZoomEnabled: options.quickZoomEnabled,
            focalPoint: focalPoint,
            pinchToZoomDecelerationEnabled: false,
            rotateDecelerationEnabled: false,
            scrollDecelerationEnabled: false,
            increaseRotateThresholdWhenPinchingToZoom: false,
            increasePinchToZoomThresholdWhenRotating: false,
            zoomAnimationAmount: 0,
            pinchPanEnabled: options.pinchPanEnabled
        )
    }

    func addListeners(messenger: FlutterBinaryMessenger) {
        removeListeners()
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onMapLongTap))
        mapView.addGestureRecognizer(gestureRecognizer!)
        mapView.gestures.delegate = self
        onGestureListener = GestureListener(binaryMessenger: messenger)
        mapView.gestures.panGestureRecognizer.addTarget(self, action: #selector(onMapPan))
    }

    func removeListeners() {
        if let gestureRecognizer = self.gestureRecognizer {
            mapView.removeGestureRecognizer(gestureRecognizer)
        }
    }

    private var mapView: MapView
    private var gestureRecognizer: UIGestureRecognizer?

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}
