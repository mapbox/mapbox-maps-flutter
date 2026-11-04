import CoreLocation
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var locationSession: AnyObject?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    createLocationSession()
    // Granting Always in the prompt or in Settings makes the app active again.
    NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
    ) { [weak self] _ in self?.createLocationSession() }
    // Shows notifications while the app is in the foreground.
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // On iOS 18+, Always authorization is only effective while a session holds it.
  // Without it, geofences stop once the app is terminated. Only created once Always
  // is granted, so it never prompts.
  private func createLocationSession() {
    if #available(iOS 18.0, *), locationSession == nil,
      CLLocationManager().authorizationStatus == .authorizedAlways
    {
      locationSession = CLServiceSession(authorization: .always)
    }
  }
}
