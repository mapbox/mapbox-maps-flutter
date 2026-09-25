@_spi(Experimental) import MapboxMaps
import Foundation

/// A `LocationProvider`/`HeadingProvider` whose data comes from outside Mapbox's
/// own location stack. Dart pushes updates into it via `LocationController`'s
/// `setExternalLocation`/`clearExternalLocation` platform-channel handlers
/// (see `LocationController.swift`) instead of Mapbox reading CoreLocation
/// itself through `AppleLocationProvider`.
///
/// Registered with `mapView.location.override(provider:)` the first time
/// `setExternalLocation` is called. Until then, the map behaves exactly as it
/// does today (default `AppleLocationProvider`, unmodified).
final class ExternalLocationProvider: NSObject {
    // Held weakly, matching the contract documented on `MBXLocationProvider`/
    // `LocationProvider`: observers come and go with puck visibility, and we
    // must not be the reason one leaks.
    private final class WeakLocationObserverBox {
        weak var observer: LocationObserver?
        init(_ observer: LocationObserver) { self.observer = observer }
    }
    private final class WeakHeadingObserverBox {
        weak var observer: HeadingObserver?
        init(_ observer: HeadingObserver) { self.observer = observer }
    }

    private var locationObservers: [WeakLocationObserverBox] = []
    private var headingObservers: [WeakHeadingObserverBox] = []
    private var lastLocation: Location?
    private var lastHeading: Heading?

    /// Pushes a new location to every registered observer (called from
    /// `LocationController`'s `setExternalLocation` channel handler).
    func update(location: Location) {
        lastLocation = location
        pruneLocationObservers()
        for box in locationObservers {
            box.observer?.onLocationUpdateReceived(for: [location])
        }
    }

    /// Pushes a new heading/bearing to every registered observer. Only
    /// relevant while the puck's `puckBearing` is configured as `.heading`
    /// (the default `LocationComponentSettings` — see Mapbox's own puck
    /// configuration docs).
    func update(heading: Heading) {
        lastHeading = heading
        pruneHeadingObservers()
        for box in headingObservers {
            box.observer?.onHeadingUpdate(heading)
        }
    }

    /// Drops cached state. Called when Dart clears the override, so a stale
    /// location/heading doesn't linger if the override is later re-armed.
    func clear() {
        lastLocation = nil
        lastHeading = nil
    }

    private func pruneLocationObservers() {
        locationObservers.removeAll { $0.observer == nil }
    }

    private func pruneHeadingObservers() {
        headingObservers.removeAll { $0.observer == nil }
    }
}

extension ExternalLocationProvider: LocationProvider {
    func getLastObservedLocation() -> Location? {
        lastLocation
    }

    func addLocationObserver(for observer: LocationObserver) {
        pruneLocationObservers()
        locationObservers.append(WeakLocationObserverBox(observer))
    }

    func removeLocationObserver(for observer: LocationObserver) {
        locationObservers.removeAll { $0.observer == nil || $0.observer === observer }
    }
}

extension ExternalLocationProvider: HeadingProvider {
    var latestHeading: Heading? { lastHeading }

    func add(headingObserver: HeadingObserver) {
        pruneHeadingObservers()
        headingObservers.append(WeakHeadingObserverBox(headingObserver))
    }

    func remove(headingObserver: HeadingObserver) {
        headingObservers.removeAll { $0.observer == nil || $0.observer === headingObserver }
    }
}
