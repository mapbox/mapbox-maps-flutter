import Foundation
@_spi(Experimental) import MapboxMaps
import MapboxCoreMaps_Private
import Flutter
import Turf

final class MapInterfaceController: _MapInterface {

    private static let errorCode = "0"
    private let mapboxMap: MapboxMap
    private let mapView: MapView

    init(withMapboxMap mapboxMap: MapboxMap, mapView: MapView) {
        self.mapboxMap = mapboxMap
        self.mapView = mapView
    }

    func setSnapshotLegacyMode(enabled: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(.success(()))
    }

    func styleGlyphURL() throws -> String {
        return mapboxMap.styleGlyphURL
    }

    func setStyleGlyphURL(glyphURL: String) throws {
        mapboxMap.styleGlyphURL = glyphURL
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

    func getDebugOptions() throws -> [_MapWidgetDebugOptions] {
        return mapView.debugOptions.toFLTDebugOptions()
    }

    func setDebugOptions(debugOptions: [_MapWidgetDebugOptions]) throws {
        mapView.debugOptions = debugOptions.toDebugOptions()
    }

    func getDebug() throws -> [MapDebugOptions?] {
        return self.mapboxMap.debugOptions.map {$0.toFLTMapDebugOptions()}
    }

    func setDebug(debugOptions: [MapDebugOptions?], value: Bool) throws {
        self.mapboxMap.debugOptions = debugOptions.compactMap {$0?.toMapDebugOptions()}
    }

    func queryRenderedFeatures(geometry: _RenderedQueryGeometry, options: RenderedQueryOptions, completion: @escaping (Result<[QueriedRenderedFeature?], Error>) -> Void) {
        do {
            switch geometry.type {
            case .sCREENBOX:
                let screenBoxArray = convertStringToDictionary(properties: geometry.value)
                guard let minCoord = screenBoxArray["min"] as? [String: Double] else { return }
                guard let maxCoord = screenBoxArray["max"] as? [String: Double] else { return }
                guard let minX = minCoord["x"], let minY = minCoord["y"],
                      let maxX = maxCoord["x"], let maxY = maxCoord["y"] else {
                    completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Geometry format error", details: geometry.value)))
                    return
                }
                let screenBox = ScreenBox(min: ScreenCoordinate(x: minX, y: minY),
                                          max: ScreenCoordinate(x: maxX, y: maxY))
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
            case .sCREENCOORDINATE:
                guard let pointDict = convertStringToDictionary(properties: geometry.value) as? [String: Double],
                      let x = pointDict["x"], let y = pointDict["y"] else {
                    completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Geometry format error", details: geometry.value)))
                    return
                }
                let cgPoint = CGPoint(x: x, y: y)

                try self.mapboxMap.queryRenderedFeatures(with: cgPoint, options: options.toRenderedQueryOptions()) { result in
                    switch result {
                    case .success(let features):
                        completion(.success(features.map({$0.toFLTQueriedRenderedFeature()})))
                    case .failure(let error):
                        completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "\(error)", details: nil)))
                    }
                }
            case .lIST:
                guard let data = geometry.value.data(using: .utf8),
                      let rawPoints = try? JSONDecoder().decode([[String: Double]].self, from: data) else {
                    completion(.failure(FlutterError(code: MapInterfaceController.errorCode, message: "Geometry format error", details: geometry.value)))
                    return
                }
                let cgPoints = rawPoints.compactMap {
                    guard let x = $0["x"], let y = $0["y"] else { return Optional<CGPoint>.none }
                    return CGPoint(x: x, y: y)
                }
                try self.mapboxMap.queryRenderedFeatures(with: cgPoints, options: options.toRenderedQueryOptions()) { result in
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
