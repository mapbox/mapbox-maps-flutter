package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.graphics.Bitmap
import com.google.gson.Gson
import com.mapbox.geojson.*
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.light.LightPosition
import com.mapbox.maps.extension.style.light.generated.ambientLight
import com.mapbox.maps.extension.style.light.generated.directionalLight
import com.mapbox.maps.extension.style.light.generated.flatLight
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.extension.style.types.StyleTransition
import com.mapbox.maps.mapbox_maps.pigeons.*
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream

// FLT to Android

fun GlyphsRasterizationMode.toGlyphsRasterizationMode(): com.mapbox.maps.GlyphsRasterizationMode {
  return when (this) {
    GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY
    GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY
    GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY -> com.mapbox.maps.GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY
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

fun RenderedQueryGeometry.toRenderedQueryGeometry(context: Context): com.mapbox.maps.RenderedQueryGeometry {
  return when (type) {
    Type.SCREEN_BOX -> {
      val screenBoxArray = Gson().fromJson(
        value,
        Array<Array<Double>>::class.java
      )
      val minCoord = screenBoxArray[0]
      val maxCoord = screenBoxArray[1]
      com.mapbox.maps.RenderedQueryGeometry.valueOf(
        com.mapbox.maps.ScreenBox(
          com.mapbox.maps.ScreenCoordinate(
            minCoord[0].toDevicePixels(context).toDouble(),
            minCoord[1].toDevicePixels(context).toDouble()
          ),
          com.mapbox.maps.ScreenCoordinate(
            maxCoord[0].toDevicePixels(context).toDouble(),
            maxCoord[1].toDevicePixels(context).toDouble()
          )
        )
      )
    }
    Type.LIST -> {
      val array: Array<Array<Double>> =
        Gson().fromJson(value, Array<Array<Double>>::class.java)
      com.mapbox.maps.RenderedQueryGeometry.valueOf(
        array.map {
          com.mapbox.maps.ScreenCoordinate(it[0].toDevicePixels(context).toDouble(), it[1].toDevicePixels(context).toDouble())
        }.toList()
      )
    }
    Type.SCREEN_COORDINATE -> {
      val pointArray = Gson().fromJson(
        value,
        Array<Double>::class.java
      )

      com.mapbox.maps.RenderedQueryGeometry.valueOf(
        com.mapbox.maps.ScreenCoordinate(
          pointArray[0].toDevicePixels(context).toDouble(),
          pointArray[1].toDevicePixels(context).toDouble()
        )
      )
    }
  }
}

fun RenderedQueryOptions.toRenderedQueryOptions(): com.mapbox.maps.RenderedQueryOptions {
  return com.mapbox.maps.RenderedQueryOptions(layerIds, filter?.toValue())
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

fun com.mapbox.maps.QueriedRenderedFeature.toFLTQueriedRenderedFeature(): QueriedRenderedFeature {
  return QueriedRenderedFeature(queriedFeature.toFLTQueriedFeature(), layers)
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

fun Number.toLogicalPixels(context: Context): Double {
  return this.toDouble() / context.resources.displayMetrics.density
}

fun Bitmap.toMbxImage(): MbxImage {
  val outputStream = ByteArrayOutputStream(byteCount)
  compress(Bitmap.CompressFormat.PNG, 100, outputStream)
  return MbxImage(width.toLong(), height.toLong(), outputStream.toByteArray())
}