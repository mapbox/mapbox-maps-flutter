import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class GesturesController: NSObject, GesturesSettingsInterface, UIGestureRecognizerDelegate {

    private var cancelables: Set<AnyCancelable> = []
    private var onGestureListener: GestureListener?
    private let mapView: MapView

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }

    @objc private func onMapPan(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else {
            return
        }

        let touchPoint = sender.location(in: mapView)
        let point = Point(mapView.mapboxMap.coordinate(for: touchPoint))
        let context = MapContentGestureContext(
            touchPosition: touchPoint.toFLTScreenCoordinate(),
            point: point,
            gestureState: sender.state.toFLTGestureState()
        )

        onGestureListener?.onScroll(context: context, completion: { _ in })
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

    func addListeners(messenger: SuffixBinaryMessenger) {
        removeListeners()
        mapView.gestures.panGestureRecognizer.addTarget(self, action: #selector(onMapPan))

        onGestureListener = GestureListener(binaryMessenger: messenger.messenger, messageChannelSuffix: messenger.suffix)

        mapView.gestures.onMapTap.observe { [weak self] context in
            guard let self else { return }
            self.onGestureListener?.onTap(context: context.toFLTMapContentGestureContext()) { _ in }
        }
        .store(in: &cancelables)
        mapView.gestures.onMapLongPress.observe { [weak self] context in
            guard let self else { return }
            self.onGestureListener?.onLongTap(context: context.toFLTMapContentGestureContext()) { _ in }
        }
        .store(in: &cancelables)
    }

    func removeListeners() {
        cancelables = []
    }
}
