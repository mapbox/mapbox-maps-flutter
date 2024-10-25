package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import com.mapbox.bindgen.Expected
import com.mapbox.bindgen.None
import com.mapbox.bindgen.Value
import com.mapbox.common.TileRegionError
import com.mapbox.geojson.*
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.MapboxExperimental
import com.mapbox.maps.StylePackError
import com.mapbox.maps.applyDefaultParams
import com.mapbox.maps.debugoptions.MapViewDebugOptions
import com.mapbox.maps.extension.style.expressions.generated.Expression
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.light.LightPosition
import com.mapbox.maps.extension.style.light.generated.ambientLight
import com.mapbox.maps.extension.style.light.generated.directionalLight
import com.mapbox.maps.extension.style.light.generated.flatLight
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.extension.style.types.StyleTransition
import com.mapbox.maps.interactions.FeatureState
import com.mapbox.maps.interactions.TypedFeaturesetDescriptor
import com.mapbox.maps.logE
import com.mapbox.maps.mapbox_maps.pigeons.*
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream

// FLT to Android

fun _MapWidgetDebugOptions.toMapViewDebugOptions(): MapViewDebugOptions {
  return when (this) {
    _MapWidgetDebugOptions.TILE_BORDERS -> MapViewDebugOptions.TILE_BORDERS
    _MapWidgetDebugOptions.PARSE_STATUS -> MapViewDebugOptions.PARSE_STATUS
    _MapWidgetDebugOptions.TIMESTAMPS -> MapViewDebugOptions.TIMESTAMPS
    _MapWidgetDebugOptions.COLLISION -> MapViewDebugOptions.COLLISION
    _MapWidgetDebugOptions.OVERDRAW -> MapViewDebugOptions.OVERDRAW
    _MapWidgetDebugOptions.STENCIL_CLIP -> MapViewDebugOptions.STENCIL_CLIP
    _MapWidgetDebugOptions.DEPTH_BUFFER -> MapViewDebugOptions.DEPTH_BUFFER
    _MapWidgetDebugOptions.MODEL_BOUNDS -> MapViewDebugOptions.MODEL_BOUNDS
    _MapWidgetDebugOptions.TERRAIN_WIREFRAME -> MapViewDebugOptions.TERRAIN_WIREFRAME
    _MapWidgetDebugOptions.LAYERS2DWIREFRAME -> MapViewDebugOptions.LAYERS2_DWIREFRAME
    _MapWidgetDebugOptions.LAYERS3DWIREFRAME -> MapViewDebugOptions.LAYERS3_DWIREFRAME
    _MapWidgetDebugOptions.LIGHT -> MapViewDebugOptions.LIGHT
    _MapWidgetDebugOptions.CAMERA -> MapViewDebugOptions.CAMERA
    _MapWidgetDebugOptions.PADDING -> MapViewDebugOptions.PADDING
  }
}

fun GlyphsRasterizationMode.toGlyphsRasterizationMode(): com.mapbox.maps.GlyphsRasterizationMode {
  return when (this) {
    GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY
    GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY
    GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY
  }
}

fun com.mapbox.maps.GlyphsRasterizationMode.toFLTGlyphsRasterizationMode(): GlyphsRasterizationMode {
  return when (this) {
    com.mapbox.maps.GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY -> GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY
    com.mapbox.maps.GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY -> GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY
    com.mapbox.maps.GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY -> GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY
  }
}
fun GlyphsRasterizationOptions.toGlyphsRasterizationOptions(): com.mapbox.maps.GlyphsRasterizationOptions {
  return com.mapbox.maps.GlyphsRasterizationOptions.Builder()
    .rasterizationMode(rasterizationMode.toGlyphsRasterizationMode())
    .fontFamily(fontFamily)
    .build()
}
fun MapSnapshotOptions.toSnapshotOptions(context: Context): com.mapbox.maps.MapSnapshotOptions {
  return com.mapbox.maps.MapSnapshotOptions.Builder()
    .size(size.toSize(context))
    .pixelRatio(pixelRatio.toFloat())
    .glyphsRasterizationOptions(glyphsRasterizationOptions?.toGlyphsRasterizationOptions())
    .build()
}

fun MapSnapshotOptions.toSnapshotOverlayOptions(): com.mapbox.maps.SnapshotOverlayOptions {
  return com.mapbox.maps.SnapshotOverlayOptions(
    showLogo = showsLogo ?: true,
    showAttributes = showsAttribution ?: true
  )
}
fun Size.toSize(context: Context): com.mapbox.maps.Size {
  return com.mapbox.maps.Size(width.toDevicePixels(context), height.toDevicePixels(context))
}
fun TileCoverOptions.toTileCoverOptions(): com.mapbox.maps.TileCoverOptions {
  return com.mapbox.maps.TileCoverOptions.Builder()
    .tileSize(tileSize?.toShort())
    .maxZoom(maxZoom?.toByte())
    .minZoom(minZoom?.toByte())
    .roundZoom(roundZoom)
    .build()
}
fun ModelScaleMode.toModelScaleMode(): com.mapbox.maps.plugin.ModelScaleMode {
  return when (this) {
    ModelScaleMode.VIEWPORT -> com.mapbox.maps.plugin.ModelScaleMode.VIEWPORT
    ModelScaleMode.MAP -> com.mapbox.maps.plugin.ModelScaleMode.MAP
  }
}

fun TileStoreUsageMode.toTileStoreUsageMode(): com.mapbox.maps.TileStoreUsageMode {
  return when (this) {
    TileStoreUsageMode.DISABLED -> com.mapbox.maps.TileStoreUsageMode.DISABLED
    TileStoreUsageMode.READ_AND_UPDATE -> com.mapbox.maps.TileStoreUsageMode.READ_AND_UPDATE
    TileStoreUsageMode.READ_ONLY -> com.mapbox.maps.TileStoreUsageMode.READ_ONLY
  }
}

fun StyleProjectionName.toProjectionName(): ProjectionName {
  return when (this) {
    StyleProjectionName.GLOBE -> ProjectionName.GLOBE
    StyleProjectionName.MERCATOR -> ProjectionName.MERCATOR
  }
}

fun StyleProjection.toProjection(): com.mapbox.maps.extension.style.projection.generated.Projection {
  return com.mapbox.maps.extension.style.projection.generated.Projection(name.toProjectionName())
}
fun TransitionOptions.toStyleTransition(): StyleTransition {
  val builder = StyleTransition.Builder()
  duration?.let {
    builder.duration(it)
  }
  delay?.let {
    builder.delay(it)
  }

  return builder.build()
}
fun Anchor.toAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.Anchor {
  return when (this) {
    Anchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.Anchor.MAP
    Anchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.Anchor.VIEWPORT
  }
}
fun FlatLight.toFlatLight(): com.mapbox.maps.extension.style.light.generated.FlatLight {
  return flatLight(id) {
    anchor?.let {
      anchor(it.toAnchor())
    }
    color?.let {
      color(it.toInt())
    }
    colorTransition?.let {
      colorTransition(it.toStyleTransition())
    }
    intensity?.let {
      intensity(it)
    }
    intensityTransition?.let {
      intensityTransition(it.toStyleTransition())
    }
    position?.let {
      if (it.size == 3) {
        position(LightPosition(it[0]!!, it[1]!!, it[2]!!))
      }
    }
    positionTransition?.let {
      positionTransition(it.toStyleTransition())
    }
  }
}

fun AmbientLight.toAmbientLight(): com.mapbox.maps.extension.style.light.generated.AmbientLight {
  return ambientLight(id) {
    color?.let {
      color(it.toInt())
    }
    colorTransition?.let {
      colorTransition(it.toStyleTransition())
    }
    intensity?.let {
      intensity(it)
    }
    intensityTransition?.let {
      intensityTransition(it.toStyleTransition())
    }
  }
}

fun DirectionalLight.toDirectionalLight(): com.mapbox.maps.extension.style.light.generated.DirectionalLight {
  return directionalLight(id) {
    castShadows?.let {
      castShadows(it)
    }
    color?.let {
      color(it.toInt())
    }
    colorTransition?.let {
      colorTransition(it.toStyleTransition())
    }
    direction?.let {
      direction(it as List<Double>)
    }
    directionTransition?.let {
      directionTransition(it.toStyleTransition())
    }
    intensity?.let {
      intensity(it)
    }
    intensityTransition?.let {
      intensityTransition(it.toStyleTransition())
    }
    shadowIntensity?.let {
      shadowIntensity(it)
    }
    shadowIntensityTransition?.let {
      shadowIntensityTransition(it.toStyleTransition())
    }
  }
}

fun MapAnimationOptions.toMapAnimationOptions(): com.mapbox.maps.plugin.animation.MapAnimationOptions {
  val builder = com.mapbox.maps.plugin.animation.MapAnimationOptions.Builder()
  duration?.let {
    builder.duration(it)
  }
  startDelay?.let {
    builder.startDelay(it)
  }
  return builder.build()
}

fun TileCacheBudgetInMegabytes.toMapMemoryBudgetInMegabytes(): com.mapbox.maps.TileCacheBudgetInMegabytes {
  return com.mapbox.maps.TileCacheBudgetInMegabytes(size)
}

fun TileCacheBudgetInTiles.toMapMemoryBudgetInTiles(): com.mapbox.maps.TileCacheBudgetInTiles {
  return com.mapbox.maps.TileCacheBudgetInTiles(size)
}

fun SourceQueryOptions.toSourceQueryOptions(): com.mapbox.maps.SourceQueryOptions {
  return com.mapbox.maps.SourceQueryOptions(sourceLayerIds, filter.toValue())
}

fun _RenderedQueryGeometry.toRenderedQueryGeometry(context: Context): com.mapbox.maps.RenderedQueryGeometry {
  return when (type) {
    Type.SCREEN_BOX -> com.mapbox.maps.RenderedQueryGeometry.valueOf(
      Gson().fromJson(
        value,
        ScreenBox::class.java
      ).toScreenBox(context)
    )

    Type.LIST -> com.mapbox.maps.RenderedQueryGeometry.valueOf(
      Gson().fromJson(
        value,
        Array<ScreenCoordinate>::class.java
      ).map { it.toScreenCoordinate(context) }
    )

    Type.SCREEN_COORDINATE -> com.mapbox.maps.RenderedQueryGeometry.valueOf(
      Gson().fromJson(
        value,
        ScreenCoordinate::class.java
      ).toScreenCoordinate(context)
    )
  }
}

fun RenderedQueryOptions.toRenderedQueryOptions(): com.mapbox.maps.RenderedQueryOptions {
  return com.mapbox.maps.RenderedQueryOptions(layerIds, filter?.toValue())
}

fun FeaturesetFeatureId.toFeaturesetFeatureId(): com.mapbox.maps.FeaturesetFeatureId {
  return com.mapbox.maps.FeaturesetFeatureId(id, namespace)
}

fun FeaturesetDescriptor.toFeatureSetDescriptor(): com.mapbox.maps.FeaturesetDescriptor {
  return com.mapbox.maps.FeaturesetDescriptor(featuresetId, importId, layerId)
}

@OptIn(MapboxExperimental::class)
fun FeaturesetDescriptor.toTypedFeaturesetDescriptor(): TypedFeaturesetDescriptor<*, *> {
  featuresetId?.let {
    return TypedFeaturesetDescriptor.Featureset(
      featuresetId, importId
    )
  }
  return TypedFeaturesetDescriptor.Layer(
    layerId!! // If there is not a featuresetId there will be a layerId
  )
}

fun FeaturesetQueryTarget.toFeaturesetQueryTarget(): com.mapbox.maps.FeaturesetQueryTarget {
  return com.mapbox.maps.FeaturesetQueryTarget(featureset.toFeatureSetDescriptor(), filter?.let { Expression.fromRaw(filter) }, id)
}

@OptIn(MapboxExperimental::class)
fun Map<String, Any?>.toFeatureState(): com.mapbox.maps.interactions.FeatureState {
  val map = this
  return FeatureState {
    for ((key, value) in map) {
      when (value) {
        is String -> {
          addStringState(key, value)
        }
        is Long -> {
          addLongState(key, value)
        }
        is Double -> {
          addDoubleState(key, value)
        }
        is Boolean -> {
          addBooleanState(key, value)
        }
        else -> throw (RuntimeException("Unsupported (key, value): ($key, $value)"))
      }
    }
  }
}

@OptIn(MapboxExperimental::class)
@SuppressLint("RestrictedApi")
fun FeaturesetFeature.toFeaturesetFeature(): com.mapbox.maps.interactions.FeaturesetFeature<FeatureState> {
  val jsonObject: JsonObject = JsonParser.parseString(properties.toString()).getAsJsonObject()
  featureset.featuresetId?.let {
    return com.mapbox.maps.interactions.FeaturesetFeature(
      id?.toFeaturesetFeatureId(),
      featureset.toTypedFeaturesetDescriptor() as TypedFeaturesetDescriptor.Featureset,
      state.toFeatureState(),
      Feature.fromGeometry(geometry.toGeometry(), jsonObject)
    )
  }
  return com.mapbox.maps.interactions.FeaturesetFeature(
    id?.toFeaturesetFeatureId(),
    featureset.toTypedFeaturesetDescriptor() as TypedFeaturesetDescriptor.Layer,
    state.toFeatureState(),
    Feature.fromGeometry(geometry.toGeometry(), jsonObject)
  )
}

fun MapDebugOptions.toMapDebugOptions(): com.mapbox.maps.MapDebugOptions {
  return com.mapbox.maps.MapDebugOptions.values()[data.ordinal]
}

fun MercatorCoordinate.toMercatorCoordinate(): com.mapbox.maps.MercatorCoordinate {
  return com.mapbox.maps.MercatorCoordinate(x, y)
}

fun ProjectedMeters.toProjectedMeters(): com.mapbox.maps.ProjectedMeters {
  return com.mapbox.maps.ProjectedMeters(northing, easting)
}

fun Map<String?, Any?>.toPoint(): Point {
  var longitude: Double
  var latitude: Double
  (this["coordinates"] as List<Double>).let { coordinates ->
    longitude = coordinates.first()
    latitude = coordinates.last()
  }

  var boundingBox: BoundingBox? = null
  (this["bbox"] as List<Double>?)?.let { bbox ->
    assert(bbox.size == 4 || bbox.size == 6)
    val southwest = Point.fromLngLat(bbox[0], bbox[1])
    val northeast = if (bbox.size == 4) Point.fromLngLat(
      bbox[2],
      bbox[3]
    ) else Point.fromLngLat(bbox[3], bbox[4])

    boundingBox = BoundingBox.fromPoints(southwest, northeast)
  }
  return Point.fromLngLat(longitude, latitude, boundingBox)
}

fun CoordinateBounds.toCoordinateBounds() =
  com.mapbox.maps.CoordinateBounds(southwest, northeast, infiniteBounds)

fun MbxEdgeInsets.toEdgeInsets(context: Context): EdgeInsets {
  return EdgeInsets(
    top.toDevicePixels(context).toDouble(),
    left.toDevicePixels(context).toDouble(),
    bottom.toDevicePixels(context).toDouble(),
    right.toDevicePixels(context).toDouble()
  )
}

fun ScreenCoordinate.toScreenCoordinate(context: Context): com.mapbox.maps.ScreenCoordinate {
  return com.mapbox.maps.ScreenCoordinate(x.toDevicePixels(context).toDouble(), y.toDevicePixels(context).toDouble())
}

fun CameraOptions.toCameraOptions(context: Context): com.mapbox.maps.CameraOptions = com.mapbox.maps.CameraOptions.Builder()
  .anchor(anchor?.toScreenCoordinate(context))
  .bearing(bearing)
  .center(center)
  .padding(padding?.toEdgeInsets(context))
  .zoom(zoom)
  .pitch(pitch)
  .build()

fun ContextMode.toContextMode(): com.mapbox.maps.ContextMode {
  return when (this) {
    ContextMode.SHARED -> com.mapbox.maps.ContextMode.SHARED
    ContextMode.UNIQUE -> com.mapbox.maps.ContextMode.UNIQUE
  }
}

fun ConstrainMode.toConstrainMode(): com.mapbox.maps.ConstrainMode {
  return when (this) {
    ConstrainMode.NONE -> com.mapbox.maps.ConstrainMode.NONE
    ConstrainMode.HEIGHT_ONLY -> com.mapbox.maps.ConstrainMode.HEIGHT_ONLY
    ConstrainMode.WIDTH_AND_HEIGHT -> com.mapbox.maps.ConstrainMode.WIDTH_AND_HEIGHT
  }
}

fun ViewportMode.toViewportMode(): com.mapbox.maps.ViewportMode {
  return when (this) {
    ViewportMode.DEFAULT -> com.mapbox.maps.ViewportMode.DEFAULT
    ViewportMode.FLIPPED_Y -> com.mapbox.maps.ViewportMode.FLIPPED_Y
  }
}

fun NorthOrientation.toNorthOrientation(): com.mapbox.maps.NorthOrientation {
  return when (this) {
    NorthOrientation.UPWARDS -> com.mapbox.maps.NorthOrientation.UPWARDS
    NorthOrientation.DOWNWARDS -> com.mapbox.maps.NorthOrientation.DOWNWARDS
    NorthOrientation.LEFTWARDS -> com.mapbox.maps.NorthOrientation.LEFTWARDS
    NorthOrientation.RIGHTWARDS -> com.mapbox.maps.NorthOrientation.RIGHTWARDS
  }
}
fun MapOptions.toMapOptions(context: Context): com.mapbox.maps.MapOptions {
  val builder = com.mapbox.maps.MapOptions.Builder().applyDefaultParams(context)

  contextMode?.let { builder.contextMode(it.toContextMode()) }
  constrainMode?.let { builder.constrainMode(it.toConstrainMode()) }
  viewportMode?.let { builder.viewportMode(it.toViewportMode()) }
  orientation?.let { builder.orientation(it.toNorthOrientation()) }
  crossSourceCollisions?.let { builder.crossSourceCollisions(it) }
  size?.let { builder.size(it.toSize(context)) }
  builder.pixelRatio(pixelRatio.toFloat())
  glyphsRasterizationOptions?.let { builder.glyphsRasterizationOptions(it.toGlyphsRasterizationOptions()) }

  return builder.build()
}

fun ScreenBox.toScreenBox(context: Context): com.mapbox.maps.ScreenBox =
  com.mapbox.maps.ScreenBox(min.toScreenCoordinate(context), max.toScreenCoordinate(context))

fun CameraBoundsOptions.toCameraBoundsOptions(): com.mapbox.maps.CameraBoundsOptions =
  com.mapbox.maps.CameraBoundsOptions.Builder()
    .maxPitch(maxPitch)
    .bounds(bounds?.toCoordinateBounds())
    .maxZoom(maxZoom)
    .minPitch(minPitch)
    .minZoom(minZoom)
    .build()

fun Geometry.toMap(): Map<String?, Any?> {
  return when (this) {
    is Point -> mapOf(
      "coordinates" to listOf(this.latitude(), this.longitude())
    )
    is LineString -> mapOf(
      "coordinates" to this.coordinates().map { listOf(it.latitude(), it.longitude()) }
    )
    is Polygon -> mapOf(
      "coordinates" to this.coordinates().map { ring ->
        ring.map { listOf(it.latitude(), it.longitude()) }
      }
    )
    is MultiPoint -> mapOf(
      "coordinates" to this.coordinates().map { listOf(it.latitude(), it.longitude()) }
    )
    is MultiLineString -> mapOf(
      "coordinates" to this.coordinates().map { line ->
        line.map { listOf(it.latitude(), it.longitude()) }
      }
    )
    is MultiPolygon -> mapOf(
      "coordinates" to this.coordinates().map { polygon ->
        polygon.map { ring ->
          ring.map { listOf(it.latitude(), it.longitude()) }
        }
      }
    )
    else -> throw IllegalArgumentException("Unsupported geometry type")
  }
}

fun Map<String?, Any?>.toGeometry(): Geometry {
  when {
    this["type"] == "Point" -> {
      return Point.fromJson(Gson().toJson(this))
    }

    this["type"] == "Polygon" -> {
      return Polygon.fromJson(Gson().toJson(this))
    }

    this["type"] == "MultiPolygon" -> {
      return MultiPolygon.fromJson(Gson().toJson(this))
    }

    this["type"] == "MultiPoint" -> {
      return MultiPoint.fromJson(Gson().toJson(this))
    }

    this["type"] == "MultiLineString" -> {
      return MultiLineString.fromJson(Gson().toJson(this))
    }

    this["type"] == "LineString" -> {
      return LineString.fromJson(Gson().toJson(this))
    }

    this["type"] == "GeometryCollection" -> {
      return GeometryCollection.fromJson(Gson().toJson(this))
    }

    else -> throw (RuntimeException("Unsupported Geometry: ${Gson().toJson(this)}"))
  }
}

fun Number.toDevicePixels(context: Context): Float {
  return this.toFloat() * context.resources.displayMetrics.density
}

// Android to FLT

fun MapViewDebugOptions.toFLTDebugOptions(): _MapWidgetDebugOptions? {
  return when (this) {
    MapViewDebugOptions.TILE_BORDERS -> _MapWidgetDebugOptions.TILE_BORDERS
    MapViewDebugOptions.PARSE_STATUS -> _MapWidgetDebugOptions.PARSE_STATUS
    MapViewDebugOptions.TIMESTAMPS -> _MapWidgetDebugOptions.TIMESTAMPS
    MapViewDebugOptions.COLLISION -> _MapWidgetDebugOptions.COLLISION
    MapViewDebugOptions.OVERDRAW -> _MapWidgetDebugOptions.OVERDRAW
    MapViewDebugOptions.STENCIL_CLIP -> _MapWidgetDebugOptions.STENCIL_CLIP
    MapViewDebugOptions.DEPTH_BUFFER -> _MapWidgetDebugOptions.DEPTH_BUFFER
    MapViewDebugOptions.MODEL_BOUNDS -> _MapWidgetDebugOptions.MODEL_BOUNDS
    MapViewDebugOptions.TERRAIN_WIREFRAME -> _MapWidgetDebugOptions.TERRAIN_WIREFRAME
    MapViewDebugOptions.LAYERS2_DWIREFRAME -> _MapWidgetDebugOptions.LAYERS2DWIREFRAME
    MapViewDebugOptions.LAYERS3_DWIREFRAME -> _MapWidgetDebugOptions.LAYERS3DWIREFRAME
    MapViewDebugOptions.LIGHT -> _MapWidgetDebugOptions.LIGHT
    MapViewDebugOptions.CAMERA -> _MapWidgetDebugOptions.CAMERA
    MapViewDebugOptions.PADDING -> _MapWidgetDebugOptions.PADDING
    else -> null
  }
}

fun com.mapbox.maps.CanonicalTileID.toFLTCanonicalTileID(): CanonicalTileID {
  return CanonicalTileID(z = z.toLong(), x = x.toLong(), y = y.toLong())
}

fun com.mapbox.common.LoggingLevel.toFLTLoggingLevel(): LoggingLevel {
  return when (this) {
    com.mapbox.common.LoggingLevel.DEBUG -> LoggingLevel.DEBUG
    com.mapbox.common.LoggingLevel.INFO -> LoggingLevel.INFO
    com.mapbox.common.LoggingLevel.WARNING -> LoggingLevel.WARNING
    com.mapbox.common.LoggingLevel.ERROR -> LoggingLevel.ERROR
  }
}
fun StyleTransition.toFLTTransitionOptions(): TransitionOptions {
  return TransitionOptions(delay, duration)
}
fun com.mapbox.maps.plugin.ModelScaleMode.toFLTModelScaleMode(): ModelScaleMode {
  return when (this) {
    com.mapbox.maps.plugin.ModelScaleMode.VIEWPORT -> ModelScaleMode.VIEWPORT
    com.mapbox.maps.plugin.ModelScaleMode.MAP -> ModelScaleMode.MAP
    else -> { throw java.lang.RuntimeException("Scale mode not supported: $this") }
  }
}
fun com.mapbox.maps.StylePropertyValue.toFLTStylePropertyValue(): StylePropertyValue {
  return StylePropertyValue(value.toJson(), StylePropertyValueKind.values()[kind.ordinal])
}

fun ProjectionName.toFLTProjectionName(): StyleProjectionName {
  return when (this) {
    ProjectionName.GLOBE -> StyleProjectionName.GLOBE
    ProjectionName.MERCATOR -> StyleProjectionName.MERCATOR
    else -> {
      throw java.lang.RuntimeException("Projection $this is not supported.")
    }
  }
}

fun Projection.toFLTProjection(): StyleProjection {
  return StyleProjection(name.toFLTProjectionName())
}

fun com.mapbox.maps.StyleObjectInfo.toFLTStyleObjectInfo(): StyleObjectInfo {
  return StyleObjectInfo(id, type)
}

fun com.mapbox.maps.MercatorCoordinate.toFLTMercatorCoordinate(): MercatorCoordinate {
  return MercatorCoordinate(x, y)
}

fun com.mapbox.maps.ProjectedMeters.toFLTProjectedMeters(): ProjectedMeters {
  return ProjectedMeters(northing, easting)
}

fun com.mapbox.maps.FeatureExtensionValue.toFLTFeatureExtensionValue(): FeatureExtensionValue {
  val map = featureCollection?.map { JSONObject(it.toJson()).toMap() }
  return FeatureExtensionValue(value?.toJson(), map)
}

fun com.mapbox.maps.QueriedFeature.toFLTQueriedFeature(): QueriedFeature {
  return QueriedFeature(JSONObject(this.feature.toJson()).toMap(), source, sourceLayer, state.toJson())
}

fun com.mapbox.maps.FeaturesetQueryTarget.toFLTFeaturesetQueryTarget(): FeaturesetQueryTarget {
  return FeaturesetQueryTarget(featureset.toFLTFeaturesetDescriptor(), filter?.toString(), id)
}

fun com.mapbox.maps.QueriedRenderedFeature.toFLTQueriedRenderedFeature(): QueriedRenderedFeature {
  val queryTargets = targets.map { it.toFLTFeaturesetQueryTarget() }
  return QueriedRenderedFeature(queriedFeature.toFLTQueriedFeature(), layers, queryTargets)
}

fun com.mapbox.maps.FeaturesetFeatureId.toFLTFeaturesetFeatureId(): FeaturesetFeatureId {
  return FeaturesetFeatureId(featureId, featureNamespace)
}

fun com.mapbox.maps.FeaturesetDescriptor.toFLTFeaturesetDescriptor(): FeaturesetDescriptor {
  return FeaturesetDescriptor(featuresetId, importId, layerId)
}

@SuppressLint("RestrictedApi")
@OptIn(MapboxExperimental::class)
fun com.mapbox.maps.interactions.FeaturesetFeature<FeatureState>.toFLTFeaturesetFeature(): FeaturesetFeature {
  return FeaturesetFeature(
    id?.toFLTFeaturesetFeatureId(),
    descriptor.toFeaturesetDescriptor().toFLTFeaturesetDescriptor(),
    geometry.toMap(),
    properties.toFilteredMap(),
    JSONObject(state.asJsonString()).toFilteredMap()
  )
}

fun com.mapbox.maps.QueriedSourceFeature.toFLTQueriedSourceFeature(): QueriedSourceFeature {
  return QueriedSourceFeature(queriedFeature.toFLTQueriedFeature())
}

fun com.mapbox.maps.TileStoreUsageMode.toFLTTileStoreUsageMode(): TileStoreUsageMode {
  return TileStoreUsageMode.values()[ordinal]
}

fun com.mapbox.maps.MapDebugOptions.toFLTMapDebugOptions(): MapDebugOptions {
  return MapDebugOptions(MapDebugOptionsData.values()[ordinal])
}

fun com.mapbox.maps.GlyphsRasterizationOptions.toFLTGlyphsRasterizationOptions(): GlyphsRasterizationOptions {
  return GlyphsRasterizationOptions(GlyphsRasterizationMode.values()[rasterizationMode.ordinal], fontFamily)
}

fun com.mapbox.maps.MapOptions.toFLTMapOptions(context: Context): MapOptions {
  return MapOptions(
    contextMode = contextMode?.let { ContextMode.values()[it.ordinal] },
    constrainMode = constrainMode?.let { ConstrainMode.values()[it.ordinal] },
    viewportMode = viewportMode?.let { ViewportMode.values()[it.ordinal] },
    orientation = orientation?.let { NorthOrientation.values()[it.ordinal] },
    crossSourceCollisions = crossSourceCollisions,
    size = size?.toFLTSize(context),
    pixelRatio = pixelRatio.toDouble(),
    glyphsRasterizationOptions = glyphsRasterizationOptions?.toFLTGlyphsRasterizationOptions()
  )
}

fun com.mapbox.maps.Size.toFLTSize(context: Context): Size {
  return Size(width.toLogicalPixels(context), height.toLogicalPixels(context))
}

fun com.mapbox.maps.ScreenCoordinate.toFLTScreenCoordinate(context: Context): ScreenCoordinate {
  return ScreenCoordinate(x.toLogicalPixels(context), y.toLogicalPixels(context))
}

fun com.mapbox.maps.EdgeInsets.toFLTEdgeInsets(context: Context): MbxEdgeInsets = MbxEdgeInsets(
  left = left.toLogicalPixels(context),
  top = top.toLogicalPixels(context),
  bottom = bottom.toLogicalPixels(context),
  right = right.toLogicalPixels(context)
)

fun com.mapbox.maps.CameraState.toCameraState(context: Context): CameraState = CameraState(
  bearing = bearing,
  padding = padding.toFLTEdgeInsets(context),
  pitch = pitch,
  zoom = zoom,
  center = center
)

fun com.mapbox.maps.CoordinateBounds.toFLTCoordinateBounds(): CoordinateBounds =
  CoordinateBounds(southwest, northeast, infiniteBounds)

fun com.mapbox.maps.CoordinateBoundsZoom.toFLTCoordinateBoundsZoom(): CoordinateBoundsZoom =
  CoordinateBoundsZoom(bounds.toFLTCoordinateBounds(), zoom)

fun com.mapbox.maps.CameraBounds.toFLTCameraBounds() = CameraBounds(
  maxPitch = maxPitch,
  minPitch = minPitch,
  maxZoom = maxZoom,
  minZoom = minZoom,
  bounds = bounds.toFLTCoordinateBounds()
)

fun com.mapbox.maps.CameraOptions.toFLTCameraOptions(context: Context): CameraOptions {
  return CameraOptions(
    center = center,
    anchor = anchor?.toFLTScreenCoordinate(context),
    padding = padding?.toFLTEdgeInsets(context),
    zoom = zoom,
    pitch = pitch,
    bearing = bearing
  )
}

fun JSONObject.toMap(): Map<String?, Any?> = keys().asSequence().associateWith {
  when (val value = this[it]) {
    is JSONArray -> {
      val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
      JSONObject(map).toMap().values.toList()
    }

    is JSONObject -> value.toMap()
    JSONObject.NULL -> null
    else -> value
  }
}

@OptIn(MapboxExperimental::class)
fun JSONObject.toFilteredMap(): Map<String, Any?> {
  return this.toMap()
    .filterKeys { it != null } // Filter out null keys
    .mapKeys { it.key!! }
}

fun Number.toLogicalPixels(context: Context): Double {
  return this.toDouble() / context.resources.displayMetrics.density
}

fun Bitmap.toMbxImage(): MbxImage {
  val outputStream = ByteArrayOutputStream(byteCount)
  compress(Bitmap.CompressFormat.PNG, 100, outputStream)
  return MbxImage(width.toLong(), height.toLong(), outputStream.toByteArray())
}

fun StylePackLoadOptions.toStylePackLoadOptions(): com.mapbox.maps.StylePackLoadOptions {
  return com.mapbox.maps.StylePackLoadOptions.Builder()
    .glyphsRasterizationMode(glyphsRasterizationMode?.toGlyphsRasterizationMode())
    .metadata(metadata?.toValue())
    .acceptExpired(acceptExpired)
    .build()
}

fun com.mapbox.maps.StylePack.toFLTStylePack(): StylePack {
  return StylePack(
    styleURI = this.styleURI,
    glyphsRasterizationMode = this.glyphsRasterizationMode.toFLTGlyphsRasterizationMode(),
    requiredResourceCount = this.requiredResourceCount,
    completedResourceSize = this.completedResourceCount,
    completedResourceCount = this.completedResourceCount,
    expires = this.expires?.time
  )
}

fun com.mapbox.maps.StylePackLoadProgress.toFLTStylePackLoadProgress(): StylePackLoadProgress {
  return StylePackLoadProgress(
    this.completedResourceCount,
    this.completedResourceSize,
    this.erroredResourceCount,
    this.requiredResourceCount,
    this.loadedResourceCount,
    this.loadedResourceSize
  )
}

fun TilesetDescriptorOptions.toTilesetDescriptorOptions(context: Context): com.mapbox.maps.TilesetDescriptorOptions {
  val builder = com.mapbox.maps.TilesetDescriptorOptions.Builder()
    .styleURI(styleURI)
    .minZoom(minZoom.toByte())
    .maxZoom(maxZoom.toByte())
    .pixelRatio(pixelRatio?.toFloat() ?: context.resources.displayMetrics.density)
  tilesets?.let { builder.tilesets(it) }
  stylePackOptions?.let { builder.stylePackOptions(it.toStylePackLoadOptions()) }
  extraOptions?.let { builder.extraOptions(it.toValue()) }
  return builder.build()
}

fun NetworkRestriction.toNetworkRestriction(): com.mapbox.common.NetworkRestriction {
  return when (this) {
    NetworkRestriction.DISALLOW_ALL -> com.mapbox.common.NetworkRestriction.DISALLOW_ALL
    NetworkRestriction.DISALLOW_EXPENSIVE -> com.mapbox.common.NetworkRestriction.DISALLOW_EXPENSIVE
    NetworkRestriction.NONE -> com.mapbox.common.NetworkRestriction.NONE
  }
}

fun com.mapbox.common.TileRegion.toFLTTileRegion(): TileRegion {
  return TileRegion(
    this.id,
    this.requiredResourceCount,
    this.completedResourceCount,
    this.completedResourceSize
  )
}

fun TileRegionEstimateOptions.toTileRegionEstimateOptions(): com.mapbox.common.TileRegionEstimateOptions {
  return com.mapbox.common.TileRegionEstimateOptions(
    this.errorMargin.toFloat(),
    this.preciseEstimationTimeout.toLong(),
    this.preciseEstimationTimeout.toLong(),
    this.extraOptions?.toValue()
  )
}

fun com.mapbox.common.TileRegionEstimateResult.toFLTTileRegionEstimateResult(): TileRegionEstimateResult {
  return TileRegionEstimateResult(
    this.errorMargin, this.transferSize, this.storageSize,
  )
}

fun com.mapbox.common.TileRegionLoadProgress.toFLTTileRegionLoadProgress(): TileRegionLoadProgress {
  return TileRegionLoadProgress(
    this.completedResourceCount,
    this.completedResourceSize,
    this.erroredResourceCount,
    this.requiredResourceCount,
    this.loadedResourceCount,
    this.loadedResourceSize
  )
}

fun com.mapbox.common.TileRegionEstimateProgress.toFLTTileRegionEstimateProgress(): TileRegionEstimateProgress {
  return TileRegionEstimateProgress(
    this.requiredResourceCount, this.completedResourceCount, this.erroredResourceCount
  )
}

fun _TileStoreOptionsKey.toTileStoreOptionsKey(): String {
  return when (this) {
    _TileStoreOptionsKey.DISK_QUOTA -> com.mapbox.common.TileStoreOptions.DISK_QUOTA
    _TileStoreOptionsKey.MAPBOX_API_URL -> com.mapbox.common.TileStoreOptions.MAPBOX_APIURL
    _TileStoreOptionsKey.TILE_URL_TEMPLATE -> com.mapbox.common.TileStoreOptions.TILE_URLTEMPLATE
  }
}

fun TileDataDomain.toTileDataDomain(): com.mapbox.common.TileDataDomain {
  return when (this) {
    TileDataDomain.MAPS -> com.mapbox.common.TileDataDomain.MAPS
    TileDataDomain.NAVIGATION -> com.mapbox.common.TileDataDomain.NAVIGATION
    TileDataDomain.SEARCH -> com.mapbox.common.TileDataDomain.SEARCH
    TileDataDomain.ADAS -> com.mapbox.common.TileDataDomain.ADAS
  }
}

fun Expected<String, None>.handleResult(callback: (Result<Unit>) -> Unit) {
  if (this.isError) {
    callback(Result.failure(Throwable(this.error)))
  } else {
    callback(Result.success(Unit))
  }
}

@JvmName("toStylePackResult")
fun <V : Any, NewValue> Expected<StylePackError, V>.toResult(valueTransform: (V) -> NewValue): Result<NewValue> {
  return fold(
    {
      Result.failure(Throwable(it.message))
    },
    {
      Result.success(valueTransform(it))
    }
  )
}

@JvmName("toTileRegionResult")
fun <V : Any, NewValue> Expected<TileRegionError, V>.toResult(valueTransform: (V) -> NewValue): Result<NewValue> {
  return fold(
    {
      Result.failure(Throwable(it.message))
    },
    {
      Result.success(valueTransform(it))
    }
  )
}

fun Value.toFLTValue(): Any? {
  return when (contents) {
    is List<*> -> {
      (contents as List<*>).map { (it as? Value)?.toFLTValue() ?: it }
    }

    is Map<*, *> -> {
      (contents as Map<*, *>)
        .mapKeys { (it.key as? Value)?.toFLTValue() ?: it.key }
        .mapValues { (it.value as? Value)?.toFLTValue() ?: it.value }
    }

    else -> {
      contents
    }
  }
}

fun Any.toValue(): Value {
  return if (this is String) {
    if (this.startsWith("{") || this.startsWith("[")) {
      Value.fromJson(this).value!!
    } else {
      val number = this.toDoubleOrNull()
      if (number != null) {
        Value.valueOf(number)
      } else {
        Value.valueOf(this)
      }
    }
  } else if (this is Double) {
    Value.valueOf(this)
  } else if (this is Long) {
    Value.valueOf(this)
  } else if (this is Int) {
    Value.valueOf(this.toLong())
  } else if (this is Boolean) {
    Value.valueOf(this)
  } else if (this is IntArray) {
    val valueArray = this.map { Value(it.toLong()) }
    Value(valueArray)
  } else if (this is BooleanArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is DoubleArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is FloatArray) {
    val valueArray = this.map { Value(it.toDouble()) }
    Value(valueArray)
  } else if (this is LongArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is Array<*>) {
    val valueArray = this.map { it?.toValue() }
    Value(valueArray)
  } else if (this is List<*>) {
    val valueArray = this.map { it?.toValue() }
    Value(valueArray)
  } else if (this is HashMap<*, *>) {
    val valueMap = this
      .mapKeys { it.key as? String }
      .mapValues { it.value.toValue() }
    Value.valueOf(kotlin.collections.HashMap(valueMap))
  } else {
    logE(
      "StyleController",
      "Can not map value, type is not supported: ${this::class.java.canonicalName}"
    )
    Value.valueOf("")
  }
}