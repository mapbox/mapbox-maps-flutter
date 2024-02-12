import UIKit
import mapbox_maps_flutter
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      SwiftMapboxMapsPlugin.register(with: registrar(forPlugin: "MapboxMapsPlugin")!)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
