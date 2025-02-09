import Combine
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxMaps
import _MapboxNavigationHelpers

@MainActor
final class NavigationController: NSObject, NavigationInterface {
    
    @Published private(set) var isInActiveNavigation: Bool = false
    @Published private(set) var routes: MapboxNavigationCore.NavigationRoutes?
    @Published private(set) var routeProgress: MapboxNavigationCore.RouteProgress?
    @Published private(set) var currentLocation: CLLocation?
    @Published var cameraState: MapboxNavigationCore.NavigationCameraState = .idle
    @Published var profileIdentifier: ProfileIdentifier = .automobileAvoidingTraffic
    @Published var shouldRequestMapMatching = false

    private var waypoints: [Waypoint] = []
    private let core: MapboxNavigation

    private var cancelables: Set<AnyCancelable> = []
    private var onNavigationListener: NavigationListener?
    
    private let navigationMapView: NavigationMapView
    
    init(withMapView: NavigationMapView, navigationProvider: MapboxNavigation) {
        self.navigationMapView = withMapView
        self.core = navigationProvider
        
        super.init()
        observeMap()
    }
    
    func observeMap(){
        self.navigationMapView.navigationCamera.cameraStates.sink { state in
            self.onNavigationListener?.onNavigationCameraStateChanged(state: state.toFLTNavigationCameraState()!) { _ in }
        }
    }

    func startFreeDrive() {
        core.tripSession().startFreeDrive()
    }

    func cancelPreview() {
        waypoints = []
        routes = nil
        self.navigationMapView.removeRoutes()
    }

    func startActiveNavigation() {
        guard let previewRoutes = routes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
    }

    func stopActiveNavigation() {
        core.tripSession().startFreeDrive()
        self.navigationMapView.navigationCamera.stop()
    }

    func requestRoutes(points: [Point]) async throws {
       
        self.waypoints = points.map { Waypoint(coordinate: LocationCoordinate2D(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)) }
        
        let provider = core.routingProvider()
        if shouldRequestMapMatching {
            let mapMatchingOptions = NavigationMatchOptions(
                waypoints: waypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: mapMatchingOptions).value
            routes = previewRoutes
            self.onNavigationListener?.onNavigationRouteReady() { _ in }
        } else {
            let routeOptions = NavigationRouteOptions(
                waypoints: waypoints,
                profileIdentifier: profileIdentifier
            )
            let previewRoutes = try await provider.calculateRoutes(options: routeOptions).value
            routes = previewRoutes
            self.onNavigationListener?.onNavigationRouteReady() { _ in }
        }
        self.navigationMapView.showcase(routes!)
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
        
        stopActiveNavigation()
        completion(.success(Void()))
    }

    func startTripSession(withForegroundService: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let previewRoutes = routes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
        routes = nil
        waypoints = []
        completion(.success(Void()))
    }

    func requestNavigationCameraToFollowing(completion: @escaping (Result<Void, Error>) -> Void) {
        navigationMapView.update(navigationCameraState: .following)
        completion(.success(Void()))
    }

    func requestNavigationCameraToOverview(completion: @escaping (Result<Void, Error>) -> Void) {
        navigationMapView.update(navigationCameraState: .overview)
        completion(.success(Void()))
    }

    func lastLocation(completion: @escaping (Result<NavigationLocation?, Error>) -> Void) {
        var mapView = self.navigationMapView.mapView
        if(self.currentLocation != nil)
        {
            completion(.success(self.currentLocation!.toFLTNavigationLocation()))
        }
        else if(mapView.location.latestLocation != nil)
        {
            let timestamp = Int64(mapView.location.latestLocation!.timestamp.timeIntervalSince1970)
            
            completion(.success(NavigationLocation(
                latitude: mapView.location.latestLocation!.coordinate.latitude,
                longitude: mapView.location.latestLocation!.coordinate.longitude,
                timestamp: timestamp,
                monotonicTimestamp: timestamp,
                altitude: mapView.location.latestLocation!.altitude,
                horizontalAccuracy: mapView.location.latestLocation!.horizontalAccuracy,
                verticalAccuracy: mapView.location.latestLocation!.verticalAccuracy,
                speed: mapView.location.latestLocation!.speed,
                speedAccuracy: mapView.location.latestLocation!.speedAccuracy,
                bearing: nil,
                bearingAccuracy: nil,
                floor: nil,
                source: nil
            )))
        }
        else {
            var locationManager = NavigationLocationManager()
            if(locationManager.location != nil){
                completion(.success(locationManager.location!.toFLTNavigationLocation()))
            }
            else{
                completion(.success(nil))
            }
        }
    }
}
