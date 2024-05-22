import Foundation
@_spi(Experimental) import MapboxMaps
import MapboxCoreMaps_Private
import Flutter
import Turf

final class MapInterfaceController: _MapInterface {
    private static let errorCode = "0"
    private var mapboxMap: MapboxMap
    init(withMapboxMap mapboxMap: MapboxMap) {
        self.mapboxMap = mapboxMap
    }

    func loadStyleURI(styleURI: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.mapboxMap.loadStyle(StyleURI(rawValue: styleURI)!) { error in
            if let error {
                completion(.failure(FlutterError(
                    code: "loadStyleUriError",
                    message: error.localizedDescription,
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func loadStyleJson(styleJson: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.mapboxMap.loadStyle(styleJson) { error in
            if let error {
                completion(.failure(FlutterError(
                    code: "loadStyleUriError",
                    message: error.localizedDescription,
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func clearData(completion: @escaping (Result<Void, Error>) -> Void) {
        MapboxMap.clearData { error in
            if let error {
                completion(.failure(FlutterError(
                    code: "clearDataError",
                    message: error.localizedDescription,
                    details: nil
                )))
            } else {
                completion(.success(()))
            }
        }
    }

    func setTileCacheBudget(tileCacheBudgetInMegabytes: TileCacheBudgetInMegabytes?, tileCacheBudgetInTiles: TileCacheBudgetInTiles?) throws {
        if let tileCacheBudgetInMegabytes {
            self.mapboxMap.setTileCacheBudget(TileCacheBudget.fromTileCacheBudget(tileCacheBudgetInMegabytes.toTileCacheBudgetInMegabytes()))
        } else if let tileCacheBudgetInTiles {
            self.mapboxMap.setTileCacheBudget(TileCacheBudget.fromTileCacheBudget(tileCacheBudgetInTiles.toTileCacheBudgetInTiles()))
        }
    }

    func getSize() throws -> Size {
        throw FlutterError(code: MapInterfaceController.errorCode, message: "Not available.", details: nil)
    }

    func triggerRepaint() throws {
        self.mapboxMap.triggerRepaint()
    }

    func setGestureInProgress(inProgress: Bool) throws {
        if inProgress {
            self.mapboxMap.beginGesture()
        } else {
            self.mapboxMap.endGesture()
        }
    }

    func isGestureInProgress() throws -> Bool {
        return mapboxMap.isGestureInProgress
    }

    func setUserAnimationInProgress(inProgress: Bool) throws {
        if inProgress {
            self.mapboxMap.beginAnimation()
        } else {
            self.mapboxMap.endAnimation()
        }
    }

    func isUserAnimationInProgress() throws -> Bool {
        return mapboxMap.isAnimationInProgress
    }

    func setPrefetchZoomDelta(delta: Int64) throws {
        self.mapboxMap.prefetchZoomDelta = UInt8(delta)
    }

    func getPrefetchZoomDelta() throws -> Int64 {
        return Int64(self.mapboxMap.prefetchZoomDelta)
    }

    func setNorthOrientation(orientation: NorthOrientation) throws {
        mapboxMap.setNorthOrientation(orientation.toNorthOrientation())
    }

    func setConstrainMode(mode: ConstrainMode) throws {
        mapboxMap.setConstrainMode(mode.toConstrainMode())
    }

    func setViewportMode(mode: ViewportMode) throws {
        mapboxMap.setViewportMode(mode.toViewportMode())
    }

    func getMapOptions() throws -> MapOptions {
        return self.mapboxMap.options.toFLTMapOptions()
    }

    func getDebug() throws -> [MapDebugOptions?] {
        return self.mapboxMap.debugOptions.map {$0.toFLTMapDebugOptions()}
    }

    func setDebug(debugOptions: [MapDebugOptions?], value: Bool) throws {
        self.mapboxMap.debugOptions = debugOptions.compactMap {$0?.toMapDebugOptions()}
    }

    func queryRenderedFeatures(geometry: RenderedQueryGeometry, options: RenderedQueryOptions, completion: @escaping (Result<[QueriedRenderedFeature?], Error>) -> Void) {
        do {
            if geometry.type == .sCREENBOX {
                let screenBoxArray = convertStringToArray(properties: geometry.value)
                guard let minCoord = screenBoxArray[0] as? [Double] else {return}
                guard let maxCoord = screenBoxArray[1] as? [Double] else {return}

                let screenBox = ScreenBox(min: ScreenCoordinate(x: minCoord[0], y: minCoord[1]),
                                          max: ScreenCoordinate(x: maxCoord[0], y: maxCoord[1]))
                let cgRect = screenBox.toCGRect()
                let queryOptions = try options.toRenderedQueryOptions()
                self.mapboxMap.queryRenderedFeatures(with: cgRect, options: queryOptions) { result in
                    switch result {
                    case .success(let features):
                        completion(.success(features.map({$0.toFLTQueriedRenderedFeature()})))
                    case .failure(let error):
                        completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
                    }
                }
            } else if geometry.type == .sCREENCOORDINATE {
                guard let pointArray = convertStringToArray(properties: geometry.value) as? [Double] else {return}
                let cgPoint = CGPoint(x: pointArray[0], y: pointArray[1])

                try self.mapboxMap.queryRenderedFeatures(with: cgPoint, options: options.toRenderedQueryOptions()) { result in
                    switch result {
                    case .success(let features):
                        completion(.success(features.map({$0.toFLTQueriedRenderedFeature()})))
                    case .failure(let error):
                        completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
                    }
                }
            } else {
                let cgPoints = try JSONDecoder().decode([[Double]].self, from: geometry.value.data(using: String.Encoding.utf8)!)

                try self.mapboxMap.queryRenderedFeatures(with: cgPoints.map({CGPoint(x: $0[0], y: $0[1])}), options: options.toRenderedQueryOptions()) { result in
                    switch result {
                    case .success(let features):
                        completion(.success(features.map({$0.toFLTQueriedRenderedFeature()})))
                    case .failure(let error):
                        completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
                    }
                }
            }
        } catch {
            completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
        }
    }

    func querySourceFeatures(sourceId: String, options: SourceQueryOptions, completion: @escaping (Result<[QueriedSourceFeature?], Error>) -> Void) {
        do {
            try self.mapboxMap.querySourceFeatures(for: sourceId, options: options.toSourceQueryOptions()) { result in
                switch result {
                case .success(let features):
                    completion(.success(features.map({$0.toFLTQueriedSourceFeature()})))
                case .failure(let error):
                    completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
                }
            }
        } catch {
            completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
        }
    }

    func getGeoJsonClusterLeaves(sourceIdentifier: String, cluster: [String?: Any?], limit: Int64?, offset: Int64?, completion: @escaping (Result<FeatureExtensionValue, Error>) -> Void) {
        guard let feature = convertDictionaryToFeature(dict: cluster) else {
            completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Feature format error", details: convertDictionaryToString(dict: cluster))))
            return
        }
        self.mapboxMap.getGeoJsonClusterLeaves(forSourceId: sourceIdentifier, feature: feature, limit: UInt64(limit ?? 10), offset: UInt64(offset ?? 0)) { result in
            switch result {
            case .success(let feature):
                completion(.success(feature.toFLTFeatureExtensionValue()))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
            }
        }
    }

    func getGeoJsonClusterChildren(sourceIdentifier: String, cluster: [String?: Any?], completion: @escaping (Result<FeatureExtensionValue, Error>) -> Void) {
        guard let feature = convertDictionaryToFeature(dict: cluster) else {
            completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Feature format error", details: convertDictionaryToString(dict: cluster))))
            return
        }
        self.mapboxMap.getGeoJsonClusterChildren(forSourceId: sourceIdentifier, feature: feature) { result in
            switch result {
            case .success(let feature):
                completion(.success(feature.toFLTFeatureExtensionValue()))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
            }
        }
    }

    func getGeoJsonClusterExpansionZoom(sourceIdentifier: String, cluster: [String?: Any?], completion: @escaping (Result<FeatureExtensionValue, Error>) -> Void) {
        guard let feature = convertDictionaryToFeature(dict: cluster) else {
            completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Feature format error", details: convertDictionaryToString(dict: cluster))))
            return
        }
        self.mapboxMap.getGeoJsonClusterExpansionZoom(forSourceId: sourceIdentifier, feature: feature) { result in
            switch result {
            case .success(let feature):
                completion(.success(feature.toFLTFeatureExtensionValue()))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
            }
        }
    }

    func setFeatureState(sourceId: String, sourceLayerId: String?, featureId: String, state: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.mapboxMap.setFeatureState(sourceId: sourceId, sourceLayerId: sourceLayerId, featureId: featureId, state: convertStringToDictionary(properties: state)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: error.localizedDescription, details: nil)))
            }
        }
    }

    func getFeatureState(sourceId: String, sourceLayerId: String?, featureId: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.mapboxMap.getFeatureState(sourceId: sourceId, sourceLayerId: sourceLayerId, featureId: featureId) { result in
            switch result {
            case .success(let map):
                completion(.success(convertDictionaryToString(dict: map)))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
            }
        }
    }

    func removeFeatureState(sourceId: String, sourceLayerId: String?, featureId: String, stateKey: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        self.mapboxMap.removeFeatureState(sourceId: sourceId, sourceLayerId: sourceLayerId, featureId: featureId, stateKey: stateKey) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: error.localizedDescription, details: nil)))
            }
        }
    }

    func reduceMemoryUse() throws {
        mapboxMap.reduceMemoryUse()
    }

    func getElevation(coordinate: Point) throws -> Double? {
        return mapboxMap.elevation(at: coordinate.coordinates)
    }

    func tileCover(options: TileCoverOptions) throws -> [CanonicalTileID] {
        return mapboxMap.tileCover(for: options.toTileCoverOptions())
            .map { $0.toFLTCanonicalTileID() }
    }
}
