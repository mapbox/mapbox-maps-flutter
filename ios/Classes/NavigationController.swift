import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class NavigationController: NSObject, NavigationInterface {

    private var cancelables: Set<AnyCancelable> = []
    private var onNavigationListener: NavigationListener?    
    private let mapView: MapView

    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }

    func addListeners(messenger: SuffixBinaryMessenger) {
        removeListeners()


        onNavigationListener = NavigationListener(binaryMessenger: messenger.messenger, messageChannelSuffix: messenger.suffix)        
    }

    func removeListeners() {
        cancelables = []
    }
}
