import MapboxMaps
import Flutter

final class TileStoreController: _TileStore {

    enum `Error`: Swift.Error {
        case invalidTileRegionLoadOptions
    }

    private let proxy: ProxyBinaryMessenger
    private let tileStore: TileStore

    private lazy var offlineManager = OfflineManager()
    private var tileRegionLoadProgressHandlers: [String: AnyFlutterStreamHandler] = [:]
    private var tileRegionEstimateProgressHandlers: [String: AnyFlutterStreamHandler] = [:]

    init(proxy: ProxyBinaryMessenger, tileStore: TileStore) {
        self.proxy = proxy
        self.tileStore = tileStore
    }

    func loadTileRegion(id: String, loadOptions: TileRegionLoadOptions, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        tileStore.loadTileRegion(forId: id, loadOptions: loadOptions) { [weak self] progress in
            guard let self else { return }
            self.tileRegionLoadProgressHandlers[id]?.eventSink?(progress.toFLTTileRegionLoadProgress().toList())
        } completion: { result in
            completion(result.map { $0.toFLTTileRegion() })
        }
    }

    func addTileRegionLoadProgressListener(id: String) throws {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/tilestore/tile-region-\(id)", binaryMessenger: proxy.messenger)
        eventChannel.setStreamHandler(handler)
        tileRegionLoadProgressHandlers[id] = handler
    }

    func estimateTileRegion(id: String, loadOptions: TileRegionLoadOptions, estimateOptions: TileRegionEstimateOptions?, completion: @escaping (Result<TileRegionEstimateResult, Swift.Error>) -> Void) {

        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        tileStore.estimateTileRegion(
            forId: id,
            loadOptions: loadOptions,
            estimateOptions: estimateOptions.map(MapboxCommon.TileRegionEstimateOptions.init(fltValue:))) { [weak self] progress in
                guard let self else { return }
                self.tileRegionEstimateProgressHandlers[id]?.eventSink?(progress.toFLTTileRegionEstimateProgress().toList())
            } completion: { result in
                completion(result.map { $0.toFLTTileRegionEstimateResult() })
            }
    }

    func addTileRegionEstimateProgressListener(id: String) throws {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/tilestore/tile-region-estimate-\(id)", binaryMessenger: proxy.messenger)
        eventChannel.setStreamHandler(handler)
//        handler.onCancelled = { [weak self] in
//            eventChannel.setStreamHandler(nil)
//            self?.tileRegionEstimateProgressHandlers.removeValue(forKey: id)
//        }
        tileRegionEstimateProgressHandlers[id] = handler
    }

    func tileRegionMetadata(id: String, completion: @escaping (Result<[String?: Any?], Swift.Error>) -> Void) {
        tileStore.tileRegionMetadata(forId: id) { result in
            completion(result.map { $0 as? [String: Any] ?? [:] })
        }
    }

    func allTileRegions(completion: @escaping (Result<[TileRegion], Swift.Error>) -> Void) {
        tileStore.allTileRegions { result in
            let result = result.map { regions in
                regions.map { $0.toFLTTileRegion() }
            }
            completion(result)
        }
    }

    func tileRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.tileRegion(forId: id) { result in
            completion(result.map { $0.toFLTTileRegion() })
        }
    }

    func removeRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.removeRegion(forId: id) { result in
            completion(result.map { $0.toFLTTileRegion() })
        }
    }
}

extension OfflineManager {

    fileprivate func tileRegionLoadOptions(_ fltValue: TileRegionLoadOptions) -> MapboxCommon.TileRegionLoadOptions? {
        .init(
            geometry: convertDictionaryToGeometry(dict: fltValue.geometry),
            descriptors: fltValue.descriptorsOptions?.compactMap { descriptorOptions in
                guard let descriptorOptions else { return nil }
                return createTilesetDescriptor(for: MapboxCoreMaps.TilesetDescriptorOptions(fltValue: descriptorOptions))
            },
            metadata: fltValue.metadata,
            acceptExpired: fltValue.acceptExpired,
            networkRestriction: MapboxCommon.NetworkRestriction(other: fltValue.networkRestriction) ?? .none,
            averageBytesPerSecond: fltValue.averageBytesPerSecond.map(Int.init),
            extraOptions: fltValue.extraOptions
        )
    }
}
