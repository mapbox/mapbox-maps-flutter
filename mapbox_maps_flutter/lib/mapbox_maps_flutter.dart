library;

export 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart'
    hide Disposable, DisposeBag, AddToDisposeBag;
export 'package:turf/turf.dart';

export 'src/attribution_settings.dart';
export 'src/camera_state_extensions.dart';
export 'src/compass_settings.dart';
export 'src/gestures_settings.dart';
export 'src/indoor_selector_settings.dart';
export 'src/location_settings.dart';
export 'src/logo_settings.dart';
export 'src/map_widget.dart';
export 'src/viewport_controller.dart';
export 'src/scale_bar_settings.dart';
export 'src/mapbox_maps_options.dart';
export 'src/mapbox_options.dart';
export 'src/http_service.dart';
export 'src/annotations_manager.dart';
export 'src/annotation/circle_annotation_manager_facade.dart';
export 'src/annotation/point_annotation_manager_facade.dart';
export 'src/annotation/polygon_annotation_manager_facade.dart';
export 'src/annotation/polyline_annotation_manager_facade.dart';
export 'src/offline_switch.dart';
export 'src/offline/offline_manager.dart';
export 'src/offline/tile_store.dart';
export 'src/log_configuration.dart';
export 'src/map_recorder.dart';
export 'src/projection.dart';
export 'src/snapshotter.dart';
export 'src/style_manager.dart';
export 'src/interactions.dart';
export 'src/mapbox_map.dart';
export 'src/mapbox_styles.dart';
export 'src/interactive_features/standard_buildings.dart';
export 'src/interactive_features/standard_place_labels.dart';
export 'src/interactive_features/standard_poi.dart';

// ===== Style layers / sources =====
//
// Hand-written style infrastructure (Layer / Source base classes, shared
// enums lifted from mobile's old src/style/style.dart, LayerSlot) is in
// style_types.dart plus the layer/source base files. Typed generated
// layer/source classes come from the style codegen. Codegen-produced
// enums are declared in codegen/pigeons/platform_interface_data_types.dart
// and re-exported through the platform-interface package.
export 'src/style/style_types.dart';
export 'src/style/layer/layer.dart';
export 'src/style/layer/background_layer.dart';
export 'src/style/layer/circle_layer.dart';
export 'src/style/layer/clip_layer.dart';
export 'src/style/layer/fill_extrusion_layer.dart';
export 'src/style/layer/fill_layer.dart';
export 'src/style/layer/heatmap_layer.dart';
export 'src/style/layer/hillshade_layer.dart';
export 'src/style/layer/line_layer.dart';
export 'src/style/layer/location_indicator_layer.dart';
export 'src/style/layer/model_layer.dart';
export 'src/style/layer/raster_layer.dart';
export 'src/style/layer/raster_particle_layer.dart';
export 'src/style/layer/sky_layer.dart';
export 'src/style/layer/slot_layer.dart';
export 'src/style/layer/symbol_layer.dart';
export 'src/style/source/source.dart';
export 'src/style/source/geojson_source.dart';
export 'src/style/source/image_source.dart';
export 'src/style/source/raster_source.dart';
export 'src/style/source/rasterarray_source.dart';
export 'src/style/source/rasterdem_source.dart';
export 'src/style/source/vector_source.dart';

/// Version of the `mapbox_maps_flutter` plugin.
const String mapboxPluginVersion = '3.0.0-beta.1';
