import Combine
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxMaps

@MainActor
final class NavigationController: NSObject, NavigationInterface {
    let predictiveCacheManager: PredictiveCacheManager?

    @Published private(set) var isInActiveNavigation: Bool = false
    @Published private(set) var currentPreviewRoutes: MapboxNavigationCore.NavigationRoutes?
    @Published private(set) var activeNavigationRoutes: MapboxNavigationCore.NavigationRoutes?
    @Published private(set) var routeProgress: MapboxNavigationCore.RouteProgress?
    @Published private(set) var currentLocation: CLLocation?
    @Published var cameraState: NavigationCameraState = .iDLE
    @Published var profileIdentifier: ProfileIdentifier = .automobileAvoidingTraffic
    @Published var shouldRequestMapMatching = false

    private var waypoints: [Waypoint] = []
    private let core: MapboxNavigation

    private var cancelables: Set<AnyCancelable> = []
    private var onNavigationListener: NavigationListener?    
    private let mapView: MapView
    private let navigationProvider: MapboxNavigationProvider

    init(withMapView mapView: MapView, navigationProvider: MapboxNavigationProvider) {
        
        self.mapView = mapView
        
        self.navigationProvider = navigationProvider
        
        self.core = self.navigationProvider.mapboxNavigation
        self.predictiveCacheManager = self.navigationProvider.predictiveCacheManager
        
        super.init()
        
        observeNavigation()
    }

    private func observeNavigation() {
        self.core.tripSession().session
            .map {
                if case .activeGuidance = $0.state { return true }
                return false
            }
            .removeDuplicates()
            .assign(to: &$isInActiveNavigation)
        
        core.navigation().routeProgress.sink { state in
            self.routeProgress=state?.routeProgress
            if (self.routeProgress != nil) {
                self.onNavigationListener?.onRouteProgress(routeProgress: self.routeProgress!.toFLTRouteProgress()) { _ in }
            }
        }

        core.tripSession().navigationRoutes
            .assign(to: &$activeNavigationRoutes)
        
        core.navigation().locationMatching.sink { state in
            self.currentLocation = state.enhancedLocation
            self.onNavigationListener?.onNewLocation(location: state.enhancedLocation.toFLTNavigationLocation()) { _ in }
        }
        
        if (core.navigation().currentLocationMatching != nil) {
            self.currentLocation = self.core.navigation().currentLocationMatching?.enhancedLocation
            if(self.currentLocation != nil)
            {
                self.onNavigationListener?.onNewLocation(location: self.currentLocation!.toFLTNavigationLocation()) { _ in }
            }
        }
    }

    func startFreeDrive() {
        core.tripSession().startFreeDrive()
    }

    func cancelPreview() {
        waypoints = []
        currentPreviewRoutes = nil
        cameraState = .fOLLOWING
    }

    func startActiveNavigation() {
        guard let previewRoutes = currentPreviewRoutes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
        cameraState = .fOLLOWING
        currentPreviewRoutes = nil
        waypoints = []
    }

    func stopActiveNavigation() {
        core.tripSession().startFreeDrive()
        cameraState = .fOLLOWING
    }

    func requestRoutes(points: [Point]) async throws {

        if(self.currentLocation != nil) {
            waypoints.append(Waypoint(coordinate: self.currentLocation!.coordinate, name: "Current location"))
        }

        let provider = core.routingProvider()
        if shouldRequestMapMatching {
            let mapMatchingOptions = NavigationMatchOptions(
                waypoints: waypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: mapMatchingOptions).value
            currentPreviewRoutes = previewRoutes
            self.onNavigationListener?.onNavigationRouteReady() { _ in }
        } else {
            let routeOptions = NavigationRouteOptions(
                waypoints: waypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: routeOptions).value
            currentPreviewRoutes = previewRoutes
            self.onNavigationListener?.onNavigationRouteReady() { _ in }
        }
        cameraState = .iDLE
    }

    func addListeners(messenger: SuffixBinaryMessenger) {
        removeListeners()
        onNavigationListener = NavigationListener(binaryMessenger: messenger.messenger, messageChannelSuffix: messenger.suffix)        
    }

    func removeListeners() {
        cancelables = []
    }

    func setRoute(waypoints: [Point], completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await self.requestRoutes(points: waypoints)
                completion(.success(Void()))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    func stopTripSession(completion: @escaping (Result<Void, Error>) -> Void) {
        
        cameraState = .oVERVIEW
        self.onNavigationListener?.onNavigationCameraStateChanged(state: cameraState) {_ in }
        completion(.success(Void()))
    }

    func startTripSession(withForegroundService: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let previewRoutes = currentPreviewRoutes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
        cameraState = .fOLLOWING
        currentPreviewRoutes = nil
        waypoints = []
        self.onNavigationListener?.onNavigationCameraStateChanged(state: cameraState) {_ in }
        completion(.success(Void()))
    }

    func requestNavigationCameraToFollowing(completion: @escaping (Result<Void, Error>) -> Void) {
        cameraState = .fOLLOWING
        self.onNavigationListener?.onNavigationCameraStateChanged(state: cameraState) {_ in }
        completion(.success(Void()))
    }

    func requestNavigationCameraToOverview(completion: @escaping (Result<Void, Error>) -> Void) {
        cameraState = .oVERVIEW
        self.onNavigationListener?.onNavigationCameraStateChanged(state: cameraState) {_ in }
        completion(.success(Void()))
    }

    func lastLocation(completion: @escaping (Result<NavigationLocation?, Error>) -> Void) {
        if(self.currentLocation != nil)
        {
            completion(.success(self.currentLocation!.toFLTNavigationLocation()))
        }
        else if (self.mapView.location.latestLocation != nil) {
            let timestamp = Int64(self.mapView.location.latestLocation!.timestamp.timeIntervalSince1970)
            
            completion(.success(NavigationLocation(
                latitude: self.mapView.location.latestLocation!.coordinate.latitude,
                longitude: self.mapView.location.latestLocation!.coordinate.longitude,
                timestamp: timestamp,
                monotonicTimestamp: timestamp,
                altitude: self.mapView.location.latestLocation!.altitude,
                horizontalAccuracy: self.mapView.location.latestLocation!.horizontalAccuracy,
                verticalAccuracy: self.mapView.location.latestLocation!.verticalAccuracy,
                speed: self.mapView.location.latestLocation!.speed,
                speedAccuracy: self.mapView.location.latestLocation!.speedAccuracy,
                bearing: nil,
                bearingAccuracy: nil,
                floor: nil,
                source: nil
            )))
        }
        completion(.success(nil))
    }
}
