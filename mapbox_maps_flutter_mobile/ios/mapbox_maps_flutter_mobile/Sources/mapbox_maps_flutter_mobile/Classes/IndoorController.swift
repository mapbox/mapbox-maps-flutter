import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter
import Combine

private final class IndoorEventStream: IndoorUpdatesStreamHandler {
    var sink: PigeonEventSink<IndoorState>?
    var lastState = IndoorState(floors: [])

    override func onListen(withArguments _: Any?, sink: PigeonEventSink<IndoorState>) {
        self.sink = sink
        sink.success(lastState)
    }

    override func onCancel(withArguments _: Any?) {
        sink = nil
    }
}

final class IndoorController: NSObject, _IndoorMessenger {
    private let mapboxMap: MapboxMap
    private let stream = IndoorEventStream()
    private var cancellable: AnyCancellable?

    init(withMapboxMap mapboxMap: MapboxMap, messenger: SuffixBinaryMessenger) {
        self.mapboxMap = mapboxMap
        super.init()

        IndoorUpdatesStreamHandler.register(with: messenger.messenger, instanceName: messenger.suffix, streamHandler: stream)

        cancellable = mapboxMap.indoor.onIndoorUpdated.sink { [weak self] state in
            guard let self else { return }
            let data = state.toFLT()
            stream.lastState = data
            stream.sink?.success(data)
        }
    }

    func selectFloor(floorId: String?) throws {
        mapboxMap.indoor.selectFloor(selectedFloorId: floorId)
    }

    func tearDown() {
        cancellable?.cancel()
        cancellable = nil
        stream.sink = nil
    }
}

private extension MapboxMaps.IndoorState {
    func toFLT() -> IndoorState {
        IndoorState(
            floors: floors.map { IndoorFloor(id: $0.id, name: $0.name) },
            selectedFloorId: selectedFloorId.isEmpty ? nil : selectedFloorId
        )
    }
}
