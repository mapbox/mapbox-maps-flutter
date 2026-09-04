/// The full API of this package: the public subset from
/// `mapbox_maps_flutter_platform_interface.dart`, plus the implementation
/// contracts (everything under `src/interfaces/`) and platform-registration
/// internals (everything under `src/internal/`) that other packages in this
/// federated plugin need.
///
/// Platform implementation packages (mobile, web) import this file. App
/// developers get only the public subset, through `package:mapbox_maps_flutter`.
library;

export 'mapbox_maps_flutter_platform_interface.dart';

export 'src/internal/disposable.dart';
export 'src/internal/mapbox_maps_flutter_platform.dart';
export 'src/internal/style_image_conversions.dart';
export 'src/internal/style_image_format.dart';

export 'src/interfaces/annotations_interface.dart';
export 'src/interfaces/circle_annotation_manager_interface.dart';
export 'src/interfaces/http_service_interface.dart';
export 'src/interfaces/location_settings_interface.dart';
export 'src/interfaces/log_configuration_interface.dart';
export 'src/interfaces/map_recorder_interface.dart';
export 'src/interfaces/mapbox_map_interface.dart';
export 'src/interfaces/mapbox_maps_options_interface.dart';
export 'src/interfaces/mapbox_options_interface.dart';
export 'src/interfaces/offline_interface.dart';
export 'src/interfaces/point_annotation_manager_interface.dart';
export 'src/interfaces/polygon_annotation_manager_interface.dart';
export 'src/interfaces/polyline_annotation_manager_interface.dart';
export 'src/interfaces/projection_interface.dart';
export 'src/interfaces/settings_interfaces.dart';
export 'src/interfaces/snapshotter_interface.dart';
export 'src/interfaces/style_interface.dart';
export 'src/interfaces/viewport/viewport_interface.dart';
