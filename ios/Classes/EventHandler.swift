import Foundation
import Flutter
import MapboxMaps

protocol EventProvider {
    var onMapLoaded: Signal<MapLoaded> { get }
    var onMapLoadingError: Signal<MapLoadingError> { get }
    var onStyleLoaded: Signal<StyleLoaded> { get }
    var onStyleDataLoaded: Signal<StyleDataLoaded> { get }
    var onCameraChanged: Signal<CameraChanged> { get }
    var onMapIdle: Signal<MapIdle> { get }
    var onSourceAdded: Signal<SourceAdded> { get }
    var onSourceRemoved: Signal<SourceRemoved> { get }
    var onSourceDataLoaded: Signal<SourceDataLoaded> { get }
    var onStyleImageMissing: Signal<StyleImageMissing> { get }
    var onStyleImageRemoveUnused: Signal<StyleImageRemoveUnused> { get }
    var onRenderFrameStarted: Signal<RenderFrameStarted> { get }
    var onRenderFrameFinished: Signal<RenderFrameFinished> { get }
    var onResourceRequest: Signal<ResourceRequest> { get }
}

extension Signal {
    static var empty: Signal {
        self.init { _ in AnyCancelable {} }
    }
}

extension MapboxMap: EventProvider { }
extension Snapshotter: EventProvider {
    var onMapLoaded: MapboxMaps.Signal<MapLoaded> { .empty }
    var onCameraChanged: MapboxMaps.Signal<CameraChanged> { .empty }
    var onMapIdle: MapboxMaps.Signal<MapIdle> { .empty }
    var onSourceAdded: MapboxMaps.Signal<SourceAdded> { .empty }
    var onSourceRemoved: MapboxMaps.Signal<SourceRemoved> { .empty }
    var onSourceDataLoaded: MapboxMaps.Signal<SourceDataLoaded> { .empty }
    var onStyleImageRemoveUnused: MapboxMaps.Signal<StyleImageRemoveUnused> { .empty }
    var onRenderFrameStarted: MapboxMaps.Signal<RenderFrameStarted> { .empty }
    var onRenderFrameFinished: MapboxMaps.Signal<RenderFrameFinished> { .empty }
    var onResourceRequest: MapboxMaps.Signal<ResourceRequest> { .empty }
}

final class MapboxEventHandler {
    private let eventProvider: EventProvider
    private let binaryMessenger: FlutterBinaryMessenger
    private let channel: FlutterMethodChannel
    private var cancelables = Set<AnyCancelable>()

    init(eventProvider: EventProvider, binaryMessenger: FlutterBinaryMessenger, eventTypes: [Int], channelSuffix: String) {
        self.eventProvider = eventProvider
        self.binaryMessenger = binaryMessenger

        let channelSuffix = channelSuffix.isEmpty ? "" : ".\(channelSuffix)"
        channel = FlutterMethodChannel(
            name: "com.mapbox.maps.flutter.map_events\(channelSuffix)",
            binaryMessenger: binaryMessenger
        )
        channel.setMethodCallHandler { [weak self] methodCall, result in
            self?.handleMethodCall(methodCall, result: result)
        }

        eventTypes
            .compactMap(_MapEvent.init)
            .forEach(subscribeToEvent)
    }

    private func handleMethodCall(_ methodCall: FlutterMethodCall, result: FlutterResult) {
        switch (methodCall.method, methodCall.arguments) {
        case ("subscribeToEvents", let rawEventTypes as [Int]):
            // purge old subscriptions to start anew
            cancelables.removeAll()

            rawEventTypes
                .compactMap(_MapEvent.init)
                .forEach(subscribeToEvent)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func subscribeToEvent(_ event: _MapEvent) {
        switch event {
        case .mapLoaded:
            eventProvider.onMapLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .mapLoadingError:
            eventProvider.onMapLoadingError.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleLoaded:
            eventProvider.onStyleLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleDataLoaded:
            eventProvider.onStyleDataLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .cameraChanged:
            eventProvider.onCameraChanged.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .mapIdle:
            eventProvider.onMapIdle.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceAdded:
            eventProvider.onSourceAdded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceRemoved:
            eventProvider.onSourceRemoved.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .sourceDataLoaded:
            eventProvider.onSourceDataLoaded.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleImageMissing:
            eventProvider.onStyleImageMissing.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .styleImageRemoveUnused:
            eventProvider.onStyleImageRemoveUnused.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .renderFrameStarted:
            eventProvider.onRenderFrameStarted.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .renderFrameFinished:
            eventProvider.onRenderFrameFinished.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        case .resourceRequest:
            eventProvider.onResourceRequest.observe { [weak self] payload in
                self?.channel.invokeMethod(event.methodName, arguments: payload.toJSONString)
            }.store(in: &cancelables)
        }
    }
}

private extension _MapEvent {
    var methodName: String { "event#\(rawValue)" }
}
