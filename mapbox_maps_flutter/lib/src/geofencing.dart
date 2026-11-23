import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:turf/turf.dart';

/// Monitors GeoJSON features for entry, dwell, and exit.
///
/// {@macro supported_platforms_mobile}
///
/// Grant location permission before using [GeofencingService.instance].
/// Independent of [MapboxMap]. Features are stored on disk and remain
/// monitored across app launches.
///
/// To get events while the app is in the background, grant "Always" location
/// permission on iOS, and background location on Android.
///
/// Only iOS relaunches a terminated app for geofencing events. On Android,
/// events stop when the app is terminated.
///
/// Note: iOS 18 and later requires an active service session with Always
/// authorization. See
/// [CLServiceSession](https://developer.apple.com/documentation/corelocation/clservicesession).
///
/// ```dart
/// final service = GeofencingService.instance;
/// await service.addFeature(
///   GeofenceFeature.circle(
///     id: 'store',
///     center: Point(coordinates: Position(11.78, 48.35)),
///     radius: 100,
///     dwellTime: Duration(minutes: 10),
///   ),
/// );
/// service.entryEvents.listen((event) => print('Entered ${event.feature.id}'));
/// ```
final class GeofencingService {
  /// The process-wide service.
  static final GeofencingService instance = GeofencingService(
    MapboxMapsFlutterPlatform.instance.geofencing,
  );

  final GeofencingPlatformInterface _impl;

  @visibleForTesting
  GeofencingService(this._impl);

  /// The user entered a monitored feature.
  ///
  /// {@template geofencing_event_streams}
  /// The event streams are broadcast streams and do not buffer. Events raised
  /// before the first listener subscribes are lost, so listen on app launch.
  /// {@endtemplate}
  Stream<GeofencingEvent> get entryEvents => _impl.entryEvents;

  /// The user stayed inside a monitored feature for its dwell time.
  ///
  /// {@macro geofencing_event_streams}
  Stream<GeofencingEvent> get dwellEvents => _impl.dwellEvents;

  /// The user left a monitored feature.
  ///
  /// {@macro geofencing_event_streams}
  Stream<GeofencingEvent> get exitEvents => _impl.exitEvents;

  /// Problems while monitoring, such as revoked location permission or
  /// approximate accuracy, and failures to start observing.
  ///
  /// {@macro geofencing_event_streams}
  Stream<GeofencingError> get errors => _impl.errors;

  /// Sets how many features the service monitors.
  ///
  /// Throws a [GeofencingError] on failure.
  Future<void> configure(GeofencingOptions options) {
    return _impl.configure(options.maximumMonitoredFeatures);
  }

  /// The current geofencing options.
  ///
  /// Throws a [GeofencingError] on failure.
  Future<GeofencingOptions> getOptions() async {
    final maximumMonitoredFeatures = await _impl.getOptions();
    return GeofencingOptions(
      maximumMonitoredFeatures: maximumMonitoredFeatures,
    );
  }

  /// Monitors [feature]. Returns its id.
  ///
  /// See [GeofenceFeature] for an easy way to create circles and polygons for geofencing.
  ///
  /// An existing feature with the same id is overwritten and its state is reset.
  ///
  /// Throws a [GeofencingError] on failure, with
  /// [GeofencingErrorType.featureNotStored] if the dwell time is shorter than
  /// 1 minute, or if the radius of a [GeofenceFeature.circle] is smaller than
  /// 1 meter.
  Future<String> addFeature(Feature feature) {
    return _impl.addFeature(feature);
  }

  /// The monitored feature and, while the user is inside it, when they entered.
  ///
  /// Throws a [GeofencingError] on failure.
  Future<GeofenceState> getFeature(String identifier) {
    return _impl.getFeature(identifier);
  }

  /// Stops monitoring [identifier].
  ///
  /// Throws a [GeofencingError] on failure.
  Future<void> removeFeature(String identifier) {
    return _impl.removeFeature(identifier);
  }

  /// Removes every monitored feature and returns how many were removed.
  ///
  /// Throws a [GeofencingError] on failure.
  Future<int> clearFeatures() => _impl.clearFeatures();
}

/// Consent and activity for the geofencing service.
///
/// {@macro supported_platforms_mobile}
///
/// Does not grant consent or request location permission.
final class GeofencingUtils {
  /// Gets the geofencing user consent state.
  ///
  /// Returns `true` if the end user has given consent for geofencing, `false`
  /// otherwise.
  ///
  /// Note: User consent is independent of location permission. Geofencing
  /// requires both.
  static Future<bool> getUserConsent() {
    return MapboxMapsFlutterPlatform.instance.geofencing.consent;
  }

  /// Whether geofencing is currently monitoring features.
  static Future<bool> isActive() {
    return MapboxMapsFlutterPlatform.instance.geofencing.isActive;
  }

  /// Whether the user gave consent, each time it changes.
  ///
  /// A broadcast stream. Geofencing errors are not reported here.
  static Stream<bool> get userConsentChanges =>
      MapboxMapsFlutterPlatform.instance.geofencing.consentChanges;
}

/// Options for the geofencing service.
final class GeofencingOptions {
  /// Maximum number of monitored features. Default is 100000.
  final int maximumMonitoredFeatures;

  /// Creates geofencing options.
  const GeofencingOptions({this.maximumMonitoredFeatures = 100000});
}

/// Keys in a feature's properties that configure how it is monitored.
///
/// ```json
/// {
///   "type": "Feature",
///   "geometry": {"type": "Point", "coordinates": [11.78, 48.35]},
///   "properties": {"MBX_GEOFENCE_DWELL_TIME": 10, "MBX_GEOFENCE_POINT_RADIUS": 100}
/// }
/// ```
abstract final class GeofencingPropertiesKeys {
  /// The dwell time in minutes. Must be at least 1 minute.
  static const String dwellTimeKey = 'MBX_GEOFENCE_DWELL_TIME';

  /// The monitoring radius in meters around a [Point]. Rounded to whole
  /// meters.
  static const String pointRadiusKey = 'MBX_GEOFENCE_POINT_RADIUS';
}

/// Creates features to monitor from a circle, a polygon, or a multipolygon.
///
/// The radius and dwell time are written into the feature properties with
/// [GeofencingPropertiesKeys]. Without a dwell time, no dwell events are
/// reported.
abstract final class GeofenceFeature {
  /// The area within [radius] meters of [center]. [radius] is rounded to whole
  /// meters.
  static Feature circle({
    required String id,
    required Point center,
    required double radius,
    Duration? dwellTime,
    Map<String, dynamic> properties = const {},
  }) {
    return _feature(id, center, properties, dwellTime, radius);
  }

  /// The area inside [polygon].
  static Feature polygon({
    required String id,
    required Polygon polygon,
    Duration? dwellTime,
    Map<String, dynamic> properties = const {},
  }) {
    return _feature(id, polygon, properties, dwellTime, null);
  }

  /// The area inside any polygon of [multiPolygon].
  static Feature multiPolygon({
    required String id,
    required MultiPolygon multiPolygon,
    Duration? dwellTime,
    Map<String, dynamic> properties = const {},
  }) {
    return _feature(id, multiPolygon, properties, dwellTime, null);
  }

  static Feature _feature(
    String id,
    GeometryObject geometry,
    Map<String, dynamic> properties,
    Duration? dwellTime,
    double? radius,
  ) {
    return Feature(
      id: id,
      geometry: geometry,
      properties: {
        ...properties,
        if (dwellTime != null)
          GeofencingPropertiesKeys.dwellTimeKey:
              dwellTime.inMilliseconds / Duration.millisecondsPerMinute,
        GeofencingPropertiesKeys.pointRadiusKey: ?radius,
      },
    );
  }
}
