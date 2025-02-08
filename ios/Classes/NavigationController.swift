import Combine
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxMaps
import _MapboxNavigationHelpers

@MainActor
final class NavigationController: NSObject, NavigationInterface {
    
    private enum Constants {
            static let initialMapRect = CGRect(x: 0, y: 0, width: 64, height: 64)
            static let initialViewportPadding = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        }
    
    let predictiveCacheManager: PredictiveCacheManager?

    @Published private(set) var isInActiveNavigation: Bool = false
    //@Published private(set) var currentPreviewRoutes: MapboxNavigationCore.NavigationRoutes?
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
    let mapView: MapView
    let navigationProvider: MapboxNavigationProvider
    var navigationCamera: MapboxNavigationCore.NavigationCamera
    let mapStyleManager: NavigationMapStyleManager
    
    // Vanishing route line properties
        var routePoints: RoutePoints?
        var routeLineGranularDistances: RouteLineGranularDistances?
        var routeRemainingDistancesIndex: Int?
    
    private var lifetimeSubscriptions: Set<AnyCancellable> = []

    init(withMapView mapView: MapView, navigationProvider: MapboxNavigationProvider) {
        
        self.mapView = mapView
        
        self.navigationProvider = navigationProvider
        
        self.core = self.navigationProvider.mapboxNavigation
        self.predictiveCacheManager = self.navigationProvider.predictiveCacheManager
        
        self.mapStyleManager = .init(mapView: mapView, customRouteLineLayerPosition: customRouteLineLayerPosition)
        self.navigationCamera = NavigationCamera(
            mapView,
            location: core.navigation().locationMatching.map(\.enhancedLocation).eraseToAnyPublisher(),
            routeProgress: core.navigation().routeProgress.map(\.?.routeProgress).eraseToAnyPublisher())
        
        super.init()
        
        observeNavigation()
        observeCamera()
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
            .assign(to: &$routes)
        
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
    
    private func observeCamera() {
            navigationCamera.cameraStates
                .sink { [weak self] cameraState in
                    guard let self else { return }
                    self.cameraState = cameraState
                    self.onNavigationListener?.onNavigationCameraStateChanged(state: self.cameraState.toFLTNavigationCameraState()!) {_ in }
                }
        }
    
    private var customRouteLineLayerPosition: MapboxMaps.LayerPosition? = nil {
            didSet {
                mapStyleManager.customRouteLineLayerPosition = customRouteLineLayerPosition
                guard let routes else { return }
                show(routes, routeAnnotationKinds: routeAnnotationKinds)
            }
        }
    
    private(set) var routeAnnotationKinds: Set<RouteAnnotationKind> = []
    
    // MARK: - Public configuration

        /// The padding applied to the viewport in addition to the safe area.
        public var viewportPadding: UIEdgeInsets = Constants.initialViewportPadding {
            didSet { updateCameraPadding() }
        }

        /// Controls whether to show annotations on intersections, e.g. traffic signals, railroad crossings, yield and stop
        /// signs. Defaults to `true`.
        public var showsIntersectionAnnotations: Bool = true {
            didSet {
                updateIntersectionAnnotations(routeProgress: routeProgress)
            }
        }

        /// Toggles displaying alternative routes. If enabled, view will draw actual alternative route lines on the map.
        /// Defaults to `true`.
        public var showsAlternatives: Bool = true {
            didSet {
                updateAlternatives(routeProgress: routeProgress)
            }
        }

        /// Toggles displaying relative ETA callouts on alternative routes, during active guidance.
        /// Defaults to `true`.
        public var showsRelativeDurationsOnAlternativeManuever: Bool = true {
            didSet {
                if showsRelativeDurationsOnAlternativeManuever {
                    routeAnnotationKinds = [.relativeDurationsOnAlternativeManuever]
                } else {
                    routeAnnotationKinds.removeAll()
                }
                updateAlternatives(routeProgress: routeProgress)
            }
        }

        /// Controls whether the main route style layer and its casing disappears as the user location puck travels over it.
        /// Defaults to `true`.
        ///
        /// If `true`, the part of the route that has been traversed will be rendered with full transparency, to give the
        /// illusion of a disappearing route. If `false`, the whole route will be shown without traversed part disappearing
        /// effect.
        public var routeLineTracksTraversal: Bool = true

        /// The maximum distance (in screen points) the user can tap for a selection to be valid when selecting a POI.
        public var poiClickableAreaSize: CGFloat = 40

        /// Controls whether to show restricted portions of a route line. Defaults to true.
        public var showsRestrictedAreasOnRoute: Bool = true

        /// Decreases route line opacity based on occlusion from 3D objects.
        /// Value `0` disables occlusion, value `1` means fully occluded. Defaults to `0.85`.
        public var routeLineOcclusionFactor: Double = 0.85

        /// Configuration for displaying congestion levels on the route line.
        /// Allows to customize the congestion colors and ranges that represent different congestion levels.
        public var congestionConfiguration: CongestionConfiguration = .default

        /// Controls whether the traffic should be drawn on the route line or not. Defaults to true.
        public var showsTrafficOnRouteLine: Bool = true

        /// Maximum distance (in screen points) the user can tap for a selection to be valid when selecting an alternate
        /// route.
        public var tapGestureDistanceThreshold: CGFloat = 50

        /// Controls whether intermediate waypoints displayed on the route line. Defaults to `true`.
        public var showsIntermediateWaypoints: Bool = true {
            didSet {
                updateWaypointsVisiblity()
            }
        }
    
    // MARK: RouteLine Customization

        /// Configures the route line color for the main route.
        /// If set, overrides the `.unknown` and `.low` traffic colors.
        @objc public dynamic var routeColor: UIColor {
            get {
                congestionConfiguration.colors.mainRouteColors.unknown
            }
            set {
                congestionConfiguration.colors.mainRouteColors.unknown = newValue
                congestionConfiguration.colors.mainRouteColors.low = newValue
            }
        }

        /// Configures the route line color for alternative routes.
        /// If set, overrides the `.unknown` and `.low` traffic colors.
        @objc public dynamic var routeAlternateColor: UIColor {
            get {
                congestionConfiguration.colors.alternativeRouteColors.unknown
            }
            set {
                congestionConfiguration.colors.alternativeRouteColors.unknown = newValue
                congestionConfiguration.colors.alternativeRouteColors.low = newValue
            }
        }

        /// Configures the casing route line color for the main route.
        @objc public dynamic var routeCasingColor: UIColor = .defaultRouteCasing
        /// Configures the casing route line color for alternative routes.
        @objc public dynamic var routeAlternateCasingColor: UIColor = .defaultAlternateLineCasing
        /// Configures the color for restricted areas on the route line.
        @objc public dynamic var routeRestrictedAreaColor: UIColor = .defaultRouteRestrictedAreaColor
        /// Configures the color for the traversed part of the main route. The traversed part is rendered only if the color
        /// is not `nil`.
        /// Defaults to `nil`.
        @objc public dynamic var traversedRouteColor: UIColor? = nil
        /// Configures the color of the maneuver arrow.
        @objc public dynamic var maneuverArrowColor: UIColor = .defaultManeuverArrow
        /// Configures the stroke color of the maneuver arrow.
        @objc public dynamic var maneuverArrowStrokeColor: UIColor = .defaultManeuverArrowStroke

        // MARK: Route Annotations Customization

        /// Configures the color of the route annotation for the main route.
        @objc public dynamic var routeAnnotationSelectedColor: UIColor =
            .defaultSelectedRouteAnnotationColor
        /// Configures the color of the route annotation for alternative routes.
        @objc public dynamic var routeAnnotationColor: UIColor = .defaultRouteAnnotationColor
        /// Configures the text color of the route annotation for the main route.
        @objc public dynamic var routeAnnotationSelectedTextColor: UIColor = .defaultSelectedRouteAnnotationTextColor
        /// Configures the text color of the route annotation for alternative routes.
        @objc public dynamic var routeAnnotationTextColor: UIColor = .defaultRouteAnnotationTextColor
        /// Configures the text color of the route annotation for alternative routes when relative duration is greater then
        /// the main route.
        @objc public dynamic var routeAnnotationMoreTimeTextColor: UIColor = .defaultRouteAnnotationMoreTimeTextColor
        /// Configures the text color of the route annotation for alternative routes when relative duration is lesser then
        /// the main route.
        @objc public dynamic var routeAnnotationLessTimeTextColor: UIColor = .defaultRouteAnnotationLessTimeTextColor
        /// Configures the text font of the route annotations.
        @objc public dynamic var routeAnnotationTextFont: UIFont = .defaultRouteAnnotationTextFont
        /// Configures the waypoint color.
        @objc public dynamic var waypointColor: UIColor = .defaultWaypointColor
        /// Configures the waypoint stroke color.
        @objc public dynamic var waypointStrokeColor: UIColor = .defaultWaypointStrokeColor
    
    public func update(navigationCameraState: MapboxNavigationCore.NavigationCameraState) {
        guard cameraState != navigationCamera.currentCameraState else { return }
            navigationCamera.update(cameraState: navigationCameraState)
        }
    
    /// Represents a set of ``RoadAlertType`` values that should be hidden from the map display.
       /// By default, this is an empty set, which indicates that all road alerts will be displayed.
       ///
       /// - Note: If specific `RoadAlertType` values are added to this set, those alerts will be
       ///   excluded from the map rendering.
       public var excludedRouteAlertTypes: RoadAlertType = [] {
           didSet {
               guard let navigationRoutes = routes else {
                   return
               }

               mapStyleManager.updateRouteAlertsAnnotations(
                   navigationRoutes: navigationRoutes,
                   excludedRouteAlertTypes: excludedRouteAlertTypes
               )
           }
       }
    
    /// Visualizes the given routes and it's alternatives, removing any existing from the map.
    ///
    /// Each route is visualized as a line. Each line is color-coded by traffic congestion, if congestion
    /// levels are present. To also visualize waypoints and zoom the map to fit,
    /// use the ``showcase(_:routesPresentationStyle:routeAnnotationKinds:animated:duration:)`` method.
    ///
    /// To undo the effects of this method, use ``removeRoutes()`` method.
    /// - Parameters:
    ///   - navigationRoutes: ``NavigationRoutes`` to be displayed on the map.
    ///   - routeAnnotationKinds: A set of ``RouteAnnotationKind`` that should be displayed.
    public func show(
        _ navigationRoutes: NavigationRoutes,
        routeAnnotationKinds: Set<RouteAnnotationKind>
    ) {
        removeRoutes()
        routes = navigationRoutes
        self.routeAnnotationKinds = routeAnnotationKinds
        let mainRoute = navigationRoutes.mainRoute.route
        if routeLineTracksTraversal {
            initPrimaryRoutePoints(route: mainRoute)
        }
        mapStyleManager.updateRoutes(
            navigationRoutes,
            config: mapStyleConfig,
            featureProvider: customRouteLineFeatureProvider
        )
        updateWaypointsVisiblity()
        
        mapStyleManager.updateRouteAnnotations(
            navigationRoutes: navigationRoutes,
            annotationKinds: routeAnnotationKinds,
            config: mapStyleConfig
        )
        mapStyleManager.updateRouteAlertsAnnotations(
            navigationRoutes: navigationRoutes,
            excludedRouteAlertTypes: excludedRouteAlertTypes
        )
    }
    
    /// Removes routes and all visible annotations from the map.
        public func removeRoutes() {
            routes = nil
            routeLineGranularDistances = nil
            routeRemainingDistancesIndex = nil
            mapStyleManager.removeAllFeatures()
        }

    func updateArrow(routeProgress: MapboxNavigationCore.RouteProgress) {
            if routeProgress.currentLegProgress.followOnStep != nil {
                mapStyleManager.updateArrows(
                    route: routeProgress.route,
                    legIndex: routeProgress.legIndex,
                    stepIndex: routeProgress.currentLegProgress.stepIndex + 1,
                    config: mapStyleConfig
                )
            } else {
                removeArrows()
            }
        }
    
    /// Removes the `RouteStep` arrow from the `MapView`.
        func removeArrows() {
            mapStyleManager.removeArrows()
        }

        // MARK: - Camera

        private func updateCameraPadding() {
            let padding = viewportPadding
            let safeAreaInsets = mapView.safeAreaInsets

            navigationCamera.viewportPadding = .init(
                top: safeAreaInsets.top + padding.top,
                left: safeAreaInsets.left + padding.left,
                bottom: safeAreaInsets.bottom + padding.bottom,
                right: safeAreaInsets.right + padding.right
            )
        }
    
    private func fitCamera(
            routes: NavigationRoutes,
            routesPresentationStyle: RoutesPresentationStyle,
            animated: Bool = false,
            duration: TimeInterval
        ) {
            navigationCamera.stop()
            let coordinates: [CLLocationCoordinate2D]
            switch routesPresentationStyle {
            case .main, .all(shouldFit: false):
                coordinates = routes.mainRoute.route.shape?.coordinates ?? []
            case .all(true):
                let routes = [routes.mainRoute.route] + routes.alternativeRoutes.map(\.route)
                coordinates = MultiLineString(routes.compactMap(\.shape?.coordinates)).coordinates.flatMap { $0 }
            }
            let initialCameraOptions = CameraOptions(
                padding: navigationCamera.viewportPadding,
                bearing: 0,
                pitch: 0
            )
            do {
                let cameraOptions = try mapView.mapboxMap.camera(
                    for: coordinates,
                    camera: initialCameraOptions,
                    coordinatesPadding: nil,
                    maxZoom: nil,
                    offset: nil
                )
                mapView.camera.ease(to: cameraOptions, duration: animated ? duration : 0.0)
            } catch {
                Log.error("Failed to fit the camera: \(error.localizedDescription)", category: .navigationUI)
            }
        }

    private var customRouteLineFeatureProvider: RouteLineFeatureProvider {
            .init { [weak self] identifier, sourceIdentifier in
                guard let self else { return nil }
                return delegate?.navigationMapView(
                    self,
                    routeLineLayerWithIdentifier: identifier,
                    sourceIdentifier: sourceIdentifier
                )
            } customRouteCasingLineLayer: { [weak self] identifier, sourceIdentifier in
                guard let self else { return nil }
                return delegate?.navigationMapView(
                    self,
                    routeCasingLineLayerWithIdentifier: identifier,
                    sourceIdentifier: sourceIdentifier
                )
            } customRouteRestrictedAreasLineLayer: { [weak self] identifier, sourceIdentifier in
                guard let self else { return nil }
                return delegate?.navigationMapView(
                    self,
                    routeRestrictedAreasLineLayerWithIdentifier: identifier,
                    sourceIdentifier: sourceIdentifier
                )
            }
        }
    
    private var waypointsFeatureProvider: WaypointFeatureProvider {
           .init { [weak self] waypoints, legIndex in
               guard let self else { return nil }
               return delegate?.navigationMapView(self, shapeFor: waypoints, legIndex: legIndex)
           } customCirleLayer: { [weak self] identifier, sourceIdentifier in
               guard let self else { return nil }
               return delegate?.navigationMapView(
                   self,
                   waypointCircleLayerWithIdentifier: identifier,
                   sourceIdentifier: sourceIdentifier
               )
           } customSymbolLayer: { [weak self] identifier, sourceIdentifier in
               guard let self else { return nil }
               return delegate?.navigationMapView(
                   self,
                   waypointSymbolLayerWithIdentifier: identifier,
                   sourceIdentifier: sourceIdentifier
               )
           }
       }
    
    private func updateWaypointsVisiblity() {
        guard let mainRoute = routes?.mainRoute.route else {
                mapStyleManager.removeWaypoints()
                return
            }

            mapStyleManager.updateWaypoints(
                route: mainRoute,
                legIndex: routeProgress?.legIndex ?? 0,
                config: mapStyleConfig,
                featureProvider: waypointsFeatureProvider
            )
        }
    
    // MARK: Configuring Cache and Tiles Storage

        private var predictiveCacheMapObserver: MapboxMaps.Cancelable? = nil

        /// Setups the Predictive Caching mechanism using provided Options.
        ///
        /// This will handle all the required manipulations to enable the feature and maintain it during the navigations.
        /// Once enabled, it will be present as long as `NavigationMapView` is retained.
        ///
        /// - parameter options: options, controlling caching parameters like area radius and concurrent downloading
        /// threads.
        private func enablePredictiveCaching(with predictiveCacheManager: PredictiveCacheManager?) {
            predictiveCacheMapObserver?.cancel()

            guard let predictiveCacheManager else {
                predictiveCacheMapObserver = nil
                return
            }

            predictiveCacheManager.updateMapControllers(mapView: mapView)
            predictiveCacheMapObserver = mapView.mapboxMap.onStyleLoaded.observe { [
                weak self,
                predictiveCacheManager
            ] _ in
                guard let self else { return }

                predictiveCacheManager.updateMapControllers(mapView: mapView)
            }
        }

        private var mapStyleConfig: MapStyleConfig {
            .init(
                routeCasingColor: routeCasingColor,
                routeAlternateCasingColor: routeAlternateCasingColor,
                routeRestrictedAreaColor: routeRestrictedAreaColor,
                traversedRouteColor: traversedRouteColor,
                maneuverArrowColor: maneuverArrowColor,
                maneuverArrowStrokeColor: maneuverArrowStrokeColor,
                routeAnnotationSelectedColor: routeAnnotationSelectedColor,
                routeAnnotationColor: routeAnnotationColor,
                routeAnnotationSelectedTextColor: routeAnnotationSelectedTextColor,
                routeAnnotationTextColor: routeAnnotationTextColor,
                routeAnnotationMoreTimeTextColor: routeAnnotationMoreTimeTextColor,
                routeAnnotationLessTimeTextColor: routeAnnotationLessTimeTextColor,
                routeAnnotationTextFont: routeAnnotationTextFont,
                routeLineTracksTraversal: routeLineTracksTraversal,
                isRestrictedAreaEnabled: showsRestrictedAreasOnRoute,
                showsTrafficOnRouteLine: showsTrafficOnRouteLine,
                showsAlternatives: showsAlternatives,
                showsIntermediateWaypoints: showsIntermediateWaypoints,
                occlusionFactor: .constant(routeLineOcclusionFactor),
                congestionConfiguration: congestionConfiguration,
                waypointColor: waypointColor,
                waypointStrokeColor: waypointStrokeColor
            )
        }
    
    func startFreeDrive() {
        core.tripSession().startFreeDrive()
    }

    func cancelPreview() {
        waypoints = []
        currentPreviewRoutes = nil
        update(navigationCameraState: .following)
    }

    func startActiveNavigation() {
        guard let previewRoutes = currentPreviewRoutes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
        currentPreviewRoutes = nil
        waypoints = []
        update(navigationCameraState: .following)
    }

    func stopActiveNavigation() {
        core.tripSession().startFreeDrive()
        update(navigationCameraState: .following)
    }

    func requestRoutes(points: [Point]) async throws {
        guard !isInActiveNavigation, let currentLocation else { return }
        
        self.waypoints = points.map { Waypoint(coordinate: LocationCoordinate2D(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)) }
        
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
        update(navigationCameraState: .idle)
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
        
        update(navigationCameraState: .overview)
        completion(.success(Void()))
    }

    func startTripSession(withForegroundService: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let previewRoutes = currentPreviewRoutes else { return }
        core.tripSession().startActiveGuidance(with: previewRoutes, startLegIndex: 0)
        update(navigationCameraState: .following)
        currentPreviewRoutes = nil
        waypoints = []
        completion(.success(Void()))
    }

    func requestNavigationCameraToFollowing(completion: @escaping (Result<Void, Error>) -> Void) {
        update(navigationCameraState: .following)
        completion(.success(Void()))
    }

    func requestNavigationCameraToOverview(completion: @escaping (Result<Void, Error>) -> Void) {
        update(navigationCameraState: .overview)
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
