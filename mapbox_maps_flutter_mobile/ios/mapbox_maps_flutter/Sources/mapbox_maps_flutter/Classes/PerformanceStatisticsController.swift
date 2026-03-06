import Foundation
@_spi(Experimental) import MapboxMaps

final class PerformanceStatisticsController: _PerformanceStatisticsApi {
    private let mapboxMap: MapboxMap
    private var collectionCancelable: AnyCancelable?
    private var performanceStatisticsListener: PerformanceStatisticsListener?

    init(mapboxMap: MapboxMap, messenger: SuffixBinaryMessenger) {
        self.mapboxMap = mapboxMap
        performanceStatisticsListener = PerformanceStatisticsListener(
            binaryMessenger: messenger.messenger,
            messageChannelSuffix: messenger.suffix
        )
    }

    func startPerformanceStatisticsCollection(options: PerformanceStatisticsOptions) throws {
        let options = options.toPerformanceStatisticsOptions()
        collectionCancelable = mapboxMap.collectPerformanceStatistics(options) { [weak self] statistics in
            self?.performanceStatisticsListener?.onPerformanceStatisticsCollected(
                statistics: statistics.toFLTPerformanceStatistics(),
                completion: { _ in }
            )
        }
    }

    func stopPerformanceStatisticsCollection() throws {
        collectionCancelable = nil
    }
}
