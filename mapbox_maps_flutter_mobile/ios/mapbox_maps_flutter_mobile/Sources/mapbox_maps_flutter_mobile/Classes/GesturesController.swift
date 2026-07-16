import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

/// Shared sink-management for the four `MapContentGestureContext`-typed
/// pigeon stream handlers. Each gesture-specific subclass conforms and
/// inherits `send` for free; only the storage and the two pigeon
/// overrides are repeated (Swift can't override a parent class method
/// from a protocol extension).
private protocol GestureEventStream: AnyObject {
    var sink: PigeonEventSink<MapContentGestureContext>? { get }
}

extension GestureEventStream {
    func send(_ event: MapContentGestureContext) { sink?.success(event) }
}

private final class PanEventStream: PanEventsStreamHandler, GestureEventStream {
    var sink: PigeonEventSink<MapContentGestureContext>?
    override func onListen(withArguments _: Any?, sink: PigeonEventSink<MapContentGestureContext>) { self.sink = sink }
    override func onCancel(withArguments _: Any?) { sink = nil }
}

private final class ZoomEventStream: ZoomEventsStreamHandler, GestureEventStream {
    var sink: PigeonEventSink<MapContentGestureContext>?
    override func onListen(withArguments _: Any?, sink: PigeonEventSink<MapContentGestureContext>) { self.sink = sink }
    override func onCancel(withArguments _: Any?) { sink = nil }
}

private final class RotateEventStream: RotateEventsStreamHandler, GestureEventStream {
    var sink: PigeonEventSink<MapContentGestureContext>?
    override func onListen(withArguments _: Any?, sink: PigeonEventSink<MapContentGestureContext>) { self.sink = sink }
    override func onCancel(withArguments _: Any?) { sink = nil }
}

private final class PitchEventStream: PitchEventsStreamHandler, GestureEventStream {
    var sink: PigeonEventSink<MapContentGestureContext>?
    override func onListen(withArguments _: Any?, sink: PigeonEventSink<MapContentGestureContext>) { self.sink = sink }
    override func onCancel(withArguments _: Any?) { sink = nil }
}

final class GesturesController: NSObject, GesturesSettingsInterface, UIGestureRecognizerDelegate {

    private var cancelables: Set<AnyCancelable> = []
    private var onGestureListener: GestureListener?
    private let mapView: MapView
    private let messenger: SuffixBinaryMessenger

    private let panStream = PanEventStream()
    private let zoomStream = ZoomEventStream()
    private let rotateStream = RotateEventStream()
    private let pitchStream = PitchEventStream()

    init(withMapView mapView: MapView, messenger: SuffixBinaryMessenger) {
        self.mapView = mapView
        self.messenger = messenger
        super.init()
        register(messenger: messenger)
    }

    private func register(messenger: SuffixBinaryMessenger) {
        mapView.gestures.panGestureRecognizer.addTarget(self, action: #selector(onMapPan))
        mapView.gestures.quickZoomGestureRecognizer.addTarget(self, action: #selector(onMapQuickZoom))
        mapView.gestures.pinchGestureRecognizer.addTarget(self, action: #selector(onMapPinch))
        mapView.gestures.doubleTapToZoomInGestureRecognizer.addTarget(self, action: #selector(onMapDoubleTapZoomIn))
        mapView.gestures.doubleTouchToZoomOutGestureRecognizer.addTarget(self, action: #selector(onMapDoubleTouchZoomOut))
        mapView.gestures.rotateGestureRecognizer.addTarget(self, action: #selector(onMapRotate))
        mapView.gestures.pitchGestureRecognizer.addTarget(self, action: #selector(onMapPitch))

        PanEventsStreamHandler.register(with: messenger.messenger, instanceName: messenger.suffix, streamHandler: panStream)
        ZoomEventsStreamHandler.register(with: messenger.messenger, instanceName: messenger.suffix, streamHandler: zoomStream)
        RotateEventsStreamHandler.register(with: messenger.messenger, instanceName: messenger.suffix, streamHandler: rotateStream)
        PitchEventsStreamHandler.register(with: messenger.messenger, instanceName: messenger.suffix, streamHandler: pitchStream)

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

    private func makeContext(at touchPoint: CGPoint, state: UIGestureRecognizer.State) -> MapContentGestureContext {
        let point = Point(mapView.mapboxMap.coordinate(for: touchPoint))
        return MapContentGestureContext(
            touchPosition: touchPoint.toFLTScreenCoordinate(),
            point: point,
            gestureState: state.toFLTGestureState()
        )
    }

    @objc private func onMapPan(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else { return }
        let context = makeContext(at: sender.location(in: mapView), state: sender.state)
        onGestureListener?.onScroll(context: context, completion: { _ in })
        panStream.send(context)
    }

    @objc private func onMapQuickZoom(_ sender: UIGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else { return }
        let context = makeContext(at: sender.location(in: mapView), state: sender.state)
        onGestureListener?.onZoom(context: context, completion: { _ in })
        zoomStream.send(context)
    }

    @objc private func onMapPinch(_ sender: UIPinchGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else { return }
        let context = makeContext(at: sender.location(in: mapView), state: sender.state)
        onGestureListener?.onZoom(context: context, completion: { _ in })
        zoomStream.send(context)
    }

    @objc private func onMapDoubleTapZoomIn(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let context = makeContext(at: sender.location(in: mapView), state: sender.state)
        onGestureListener?.onZoom(context: context, completion: { _ in })
        zoomStream.send(context)
    }

    @objc private func onMapDoubleTouchZoomOut(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let context = makeContext(at: sender.location(in: mapView), state: sender.state)
        onGestureListener?.onZoom(context: context, completion: { _ in })
        zoomStream.send(context)
    }

    @objc private func onMapRotate(_ sender: UIGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else { return }
        rotateStream.send(makeContext(at: sender.location(in: mapView), state: sender.state))
    }

    @objc private func onMapPitch(_ sender: UIGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed || sender.state == .ended else { return }
        pitchStream.send(makeContext(at: sender.location(in: mapView), state: sender.state))
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
        if let scrollDecelerationEnabled = settings.scrollDecelerationEnabled {
            mapView.gestures.options.panDecelerationFactor = scrollDecelerationEnabled
                ? UIScrollView.DecelerationRate.normal.rawValue
                : 0.0
        }
        if let scrollMode = settings.scrollMode {
            switch scrollMode {
            case .hORIZONTAL:
                mapView.gestures.options.panMode = PanMode.horizontal
            case .vERTICAL:
                mapView.gestures.options.panMode = PanMode.vertical
            case .hORIZONTALANDVERTICAL:
                mapView.gestures.options.panMode = PanMode.horizontalAndVertical
            }
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
            scrollDecelerationEnabled: options.panDecelerationFactor > 0.0,
            increaseRotateThresholdWhenPinchingToZoom: false,
            increasePinchToZoomThresholdWhenRotating: false,
            zoomAnimationAmount: 0,
            pinchPanEnabled: options.pinchPanEnabled
        )
    }

    func addListeners() {
        onGestureListener = GestureListener(binaryMessenger: messenger.messenger, messageChannelSuffix: messenger.suffix)
    }

    func removeListeners() {
        onGestureListener = nil
    }
}
