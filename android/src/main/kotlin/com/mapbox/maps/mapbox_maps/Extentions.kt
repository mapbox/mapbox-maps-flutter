package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.graphics.Bitmap
import com.google.gson.Gson
import com.mapbox.bindgen.DataRef
import com.mapbox.geojson.*
import com.mapbox.maps.*
import com.mapbox.maps.extension.style.layers.properties.generated.Anchor
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.light.LightPosition
import com.mapbox.maps.extension.style.light.generated.AmbientLight
import com.mapbox.maps.extension.style.light.generated.DirectionalLight
import com.mapbox.maps.extension.style.light.generated.FlatLight
import com.mapbox.maps.extension.style.light.generated.ambientLight
import com.mapbox.maps.extension.style.light.generated.directionalLight
import com.mapbox.maps.extension.style.light.generated.flatLight
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.extension.style.types.StyleTransition
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.pigeons.FLTMapInterfaces.MbxImage
import com.mapbox.maps.pigeons.FLTMapInterfaces.StyleProjection
import com.mapbox.maps.pigeons.FLTMapInterfaces.StyleProjectionName
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.ModelScaleMode
import com.mapbox.maps.plugin.animation.MapAnimationOptions
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream

// FLT to Android

fun FLTSettings.ModelScaleMode.toModelScaleMode(): ModelScaleMode {
  return when (this) {
    FLTSettings.ModelScaleMode.VIEWPORT -> ModelScaleMode.VIEWPORT
    FLTSettings.ModelScaleMode.MAP -> ModelScaleMode.MAP
    else -> {
      throw java.lang.RuntimeException("Scale mode not supported: $this")
    }
  }
}

fun FLTMapInterfaces.TileStoreUsageMode.toTileStoreUsageMode(): TileStoreUsageMode {
  return when (this) {
    FLTMapInterfaces.TileStoreUsageMode.DISABLED -> TileStoreUsageMode.DISABLED
    FLTMapInterfaces.TileStoreUsageMode.READ_AND_UPDATE -> TileStoreUsageMode.READ_AND_UPDATE
    FLTMapInterfaces.TileStoreUsageMode.READ_ONLY -> TileStoreUsageMode.READ_ONLY
  }
}

fun StyleProjectionName.toProjectionName(): ProjectionName {
  return when (this) {
    StyleProjectionName.GLOBE -> ProjectionName.GLOBE
    StyleProjectionName.MERCATOR -> ProjectionName.MERCATOR
  }
}

fun StyleProjection.toProjection(): com.mapbox.maps.extension.style.projection.generated.Projection {
  return Projection(name.toProjectionName())
}

fun FLTMapInterfaces.TransitionOptions.toStyleTransition(): StyleTransition {
  val builder = StyleTransition.Builder()
  duration?.let {
    builder.duration(it)
  }
  delay?.let {
    builder.delay(it)
  }

  return builder.build()
}

fun FLTMapInterfaces.Anchor.toAnchor(): Anchor {
  return when (this) {
    FLTMapInterfaces.Anchor.MAP -> Anchor.MAP
    FLTMapInterfaces.Anchor.VIEWPORT -> Anchor.VIEWPORT
  }
}

fun FLTMapInterfaces.FlatLight.toFlatLight(): FlatLight {
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
        position(LightPosition(it[0], it[1], it[2]))
      }
    }
    positionTransition?.let {
      positionTransition(it.toStyleTransition())
    }
  }
}

fun FLTMapInterfaces.AmbientLight.toAmbientLight(): AmbientLight {
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

fun FLTMapInterfaces.DirectionalLight.toDirectionalLight(): DirectionalLight {
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
      direction(it)
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

fun FLTMapInterfaces.MapAnimationOptions.toMapAnimationOptions(): MapAnimationOptions {
  val builder = MapAnimationOptions.Builder()
  duration?.let {
    builder.duration(it)
  }
  startDelay?.let {
    builder.startDelay(it)
  }
  return builder.build()
}

fun FLTMapInterfaces.TileCacheBudgetInMegabytes.toMapMemoryBudgetInMegabytes(): TileCacheBudgetInMegabytes {
  return TileCacheBudgetInMegabytes(size)
}

fun FLTMapInterfaces.TileCacheBudgetInTiles.toMapMemoryBudgetInTiles(): TileCacheBudgetInTiles {
  return TileCacheBudgetInTiles(size)
}

fun FLTMapInterfaces.SourceQueryOptions.toSourceQueryOptions(): SourceQueryOptions {
  return SourceQueryOptions(sourceLayerIds, filter.toValue())
}

fun FLTMapInterfaces.RenderedQueryGeometry.toRenderedQueryGeometry(context: Context): RenderedQueryGeometry {
  return when (type) {
    FLTMapInterfaces.Type.SCREEN_BOX -> {
      val screenBoxArray = Gson().fromJson(
        value,
        Array<Array<Double>>::class.java
      )
      val minCoord = screenBoxArray[0]
      val maxCoord = screenBoxArray[1]
      RenderedQueryGeometry.valueOf(
        ScreenBox(
          ScreenCoordinate(
            minCoord[0].toDevicePixels(context).toDouble(),
            minCoord[1].toDevicePixels(context).toDouble()
          ),
          ScreenCoordinate(
            maxCoord[0].toDevicePixels(context).toDouble(),
            maxCoord[1].toDevicePixels(context).toDouble()
          )
        )
      )
    }

    FLTMapInterfaces.Type.LIST -> {
      val array: Array<Array<Double>> =
        Gson().fromJson(value, Array<Array<Double>>::class.java)
      RenderedQueryGeometry.valueOf(
        array.map {
          ScreenCoordinate(
            it[0].toDevicePixels(context).toDouble(),
            it[1].toDevicePixels(context).toDouble()
          )
        }.toList()
      )
    }

    FLTMapInterfaces.Type.SCREEN_COORDINATE -> {
      val pointArray = Gson().fromJson(
        value,
        Array<Double>::class.java
      )

      RenderedQueryGeometry.valueOf(
        ScreenCoordinate(
          pointArray[0].toDevicePixels(context).toDouble(),
          pointArray[1].toDevicePixels(context).toDouble()
        )
      )
    }
  }
}

fun FLTMapInterfaces.RenderedQueryOptions.toRenderedQueryOptions(): RenderedQueryOptions {
  return RenderedQueryOptions(layerIds, filter?.toValue())
}

fun FLTMapInterfaces.MapDebugOptions.toMapDebugOptions(): MapDebugOptions {
  return MapDebugOptions.values()[data.ordinal]
}

fun FLTMapInterfaces.MercatorCoordinate.toMercatorCoordinate(): MercatorCoordinate {
  return MercatorCoordinate(x, y)
}

fun FLTMapInterfaces.ProjectedMeters.toProjectedMeters(): ProjectedMeters {
  return ProjectedMeters(northing, easting)
}

fun Map<String, Any>.toPoint(): Point {
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

fun Map<String, Any>.toPoints(): List<Point> {
  return (this["coordinates"] as List<List<Double>>).map {
    Point.fromLngLat(it.first(), it.last())
  }
}

fun Map<String, Any>.toPointsList(): List<List<Point>> {
  return (this["coordinates"] as List<List<List<Double>>>).map {
    it.map {
      Point.fromLngLat(it.first(), it.last())
    }
  }
}

fun Map<String, Any>.toLineString(): LineString {
  return LineString.fromLngLats(
    (this["coordinates"] as List<List<Double>>).map {
      Point.fromLngLat(it.first(), it.last())
    }
  )
}

fun Map<String, Any>.toPolygon(): Polygon {
  return Polygon.fromLngLats(
    (this["coordinates"] as List<List<List<Double>>>).map {
      it.map { Point.fromLngLat(it.first(), it.last()) }
    }
  )
}

fun FLTMapInterfaces.CoordinateBounds.toCoordinateBounds() =
  CoordinateBounds(southwest.toPoint(), northeast.toPoint(), infiniteBounds)

fun FLTMapInterfaces.MbxEdgeInsets.toEdgeInsets(context: Context): EdgeInsets {
  return EdgeInsets(
    top.toDevicePixels(context).toDouble(),
    left.toDevicePixels(context).toDouble(),
    bottom.toDevicePixels(context).toDouble(),
    right.toDevicePixels(context).toDouble()
  )
}

fun FLTMapInterfaces.ScreenCoordinate.toScreenCoordinate(context: Context): ScreenCoordinate {
  return ScreenCoordinate(
    x.toDevicePixels(context).toDouble(),
    y.toDevicePixels(context).toDouble()
  )
}

fun FLTMapInterfaces.CameraOptions.toCameraOptions(context: Context): CameraOptions =
  CameraOptions.Builder()
    .anchor(anchor?.toScreenCoordinate(context))
    .bearing(bearing)
    .center(center?.toPoint())
    .padding(padding?.toEdgeInsets(context))
    .zoom(zoom)
    .pitch(pitch)
    .build()

fun FLTMapInterfaces.ScreenBox.toScreenBox(context: Context): ScreenBox =
  ScreenBox(min.toScreenCoordinate(context), max.toScreenCoordinate(context))

fun FLTMapInterfaces.CameraBoundsOptions.toCameraBoundsOptions(): CameraBoundsOptions =
  CameraBoundsOptions.Builder()
    .maxPitch(maxPitch)
    .bounds(bounds?.toCoordinateBounds())
    .maxZoom(maxZoom)
    .minPitch(minPitch)
    .minZoom(minZoom)
    .build()

fun Map<String, Any>.toGeometry(): Geometry {
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

fun StyleTransition.toFLTTransitionOptions(): FLTMapInterfaces.TransitionOptions {
  return FLTMapInterfaces.TransitionOptions.Builder()
    .setDelay(delay)
    .setDuration(duration)
    .build()
}

fun ModelScaleMode.toFLTModelScaleMode(): FLTSettings.ModelScaleMode {
  return when (this) {
    ModelScaleMode.VIEWPORT -> FLTSettings.ModelScaleMode.VIEWPORT
    ModelScaleMode.MAP -> FLTSettings.ModelScaleMode.MAP
    else -> {
      throw java.lang.RuntimeException("Scale mode not supported: $this")
    }
  }
}

fun StylePropertyValue.toFLTStylePropertyValue(): FLTMapInterfaces.StylePropertyValue {
  return FLTMapInterfaces.StylePropertyValue.Builder()
    .setValue(value.toJson())
    .setKind(FLTMapInterfaces.StylePropertyValueKind.values()[kind.ordinal])
    .build()
}

fun ProjectionName.toFLTProjectionName(): FLTMapInterfaces.StyleProjectionName {
  return when (this) {
    ProjectionName.GLOBE -> StyleProjectionName.GLOBE
    ProjectionName.MERCATOR -> StyleProjectionName.MERCATOR
    else -> {
      throw java.lang.RuntimeException("Projection $this is not supported.")
    }
  }
}

fun Projection.toFLTProjection(): StyleProjection {
  return StyleProjection.Builder()
    .setName(name.toFLTProjectionName())
    .build()
}

fun StyleObjectInfo.toFLTStyleObjectInfo(): FLTMapInterfaces.StyleObjectInfo {
  return FLTMapInterfaces.StyleObjectInfo.Builder()
    .setId(id)
    .setType(type)
    .build()
}

fun MercatorCoordinate.toFLTMercatorCoordinate(): FLTMapInterfaces.MercatorCoordinate {
  return FLTMapInterfaces.MercatorCoordinate.Builder()
    .setX(x)
    .setY(y)
    .build()
}

fun ProjectedMeters.toFLTProjectedMeters(): FLTMapInterfaces.ProjectedMeters {
  return FLTMapInterfaces.ProjectedMeters.Builder()
    .setEasting(easting)
    .setNorthing(northing)
    .build()
}

fun FeatureExtensionValue.toFLTFeatureExtensionValue(): FLTMapInterfaces.FeatureExtensionValue {
  val map = featureCollection?.map { JSONObject(it.toJson()).toMap() }
  return FLTMapInterfaces.FeatureExtensionValue.Builder()
    .setFeatureCollection(map)
    .setValue(value?.toJson())
    .build()
}

fun QueriedFeature.toFLTQueriedFeature(): FLTMapInterfaces.QueriedFeature {
  return FLTMapInterfaces.QueriedFeature.Builder()
    .setFeature(JSONObject(this.feature.toJson()).toMap())
    .setSource(this.source)
    .setSourceLayer(this.sourceLayer)
    .setState(this.state.toJson())
    .build()
}

fun QueriedRenderedFeature.toFLTQueriedRenderedFeature(): FLTMapInterfaces.QueriedRenderedFeature {
  return FLTMapInterfaces.QueriedRenderedFeature.Builder()
    .setQueriedFeature(this.queriedFeature.toFLTQueriedFeature())
    .setLayers(this.layers)
    .build()
}

fun QueriedSourceFeature.toFLTQueriedSourceFeature(): FLTMapInterfaces.QueriedSourceFeature {
  return FLTMapInterfaces.QueriedSourceFeature.Builder()
    .setQueriedFeature(this.queriedFeature.toFLTQueriedFeature())
    .build()
}

fun TileStoreUsageMode.toFLTTileStoreUsageMode(): FLTMapInterfaces.TileStoreUsageMode {
  return FLTMapInterfaces.TileStoreUsageMode.values()[ordinal]
}

fun MapDebugOptions.toFLTMapDebugOptions(): FLTMapInterfaces.MapDebugOptions {
  return FLTMapInterfaces.MapDebugOptions.Builder()
    .setData(FLTMapInterfaces.MapDebugOptionsData.values()[ordinal]).build()
}

fun GlyphsRasterizationOptions.toFLTGlyphsRasterizationOptions(): FLTMapInterfaces.GlyphsRasterizationOptions {
  return FLTMapInterfaces.GlyphsRasterizationOptions.Builder()
    .setFontFamily(fontFamily)
    .setRasterizationMode(
      FLTMapInterfaces.GlyphsRasterizationMode.values()[rasterizationMode.ordinal]
    )
    .build()
}

fun MapOptions.toFLTMapOptions(context: Context): FLTMapInterfaces.MapOptions {
  val builder = FLTMapInterfaces.MapOptions.Builder()
  constrainMode?.let {
    val values = FLTMapInterfaces.ConstrainMode.values()
    builder.setConstrainMode(
      values[it.ordinal]
    )
  }
  contextMode?.let {
    builder.setContextMode(
      FLTMapInterfaces.ContextMode.values()[it.ordinal]
    )
  }
  viewportMode?.let {
    builder.setViewportMode(
      FLTMapInterfaces.ViewportMode.values()[it.ordinal]
    )
  }
  orientation?.let {
    builder.setOrientation(
      FLTMapInterfaces.NorthOrientation.values()[it.ordinal]
    )
  }
  crossSourceCollisions?.let {
    builder.setCrossSourceCollisions(it)
  }
  size?.let {
    builder.setSize(it.toFLTSize(context))
  }
  glyphsRasterizationOptions?.let {
    builder.setGlyphsRasterizationOptions(it.toFLTGlyphsRasterizationOptions())
  }
  return builder
    .setPixelRatio(pixelRatio.toDouble())
    .build()
}

fun Size.toFLTSize(context: Context): FLTMapInterfaces.Size {
  return FLTMapInterfaces.Size.Builder()
    .setHeight(height.toLogicalPixels(context))
    .setWidth(width.toLogicalPixels(context))
    .build()
}

fun Point.toMap(): Map<String, Any> {
  val map = mutableMapOf<String, Any>()
  map["coordinates"] = coordinates()
  bbox()?.let {
    map["bbox"] = mapOf(Pair("southwest", it.southwest()), Pair("northeast", it.northeast()))
  }
  return map
}

fun Polygon.toMap(): Map<String, Any> {
  val map = mutableMapOf<String, Any>()
  map["coordinates"] = coordinates().map { it.map { it.coordinates() } }
  bbox()?.let {
    map["bbox"] = mapOf(Pair("southwest", it.southwest()), Pair("northeast", it.northeast()))
  }
  return map
}

fun LineString.toMap(): Map<String, Any> {
  val map = mutableMapOf<String, Any>()
  map["coordinates"] = coordinates().map { it.coordinates() }
  bbox()?.let {
    map["bbox"] = mapOf(Pair("southwest", it.southwest()), Pair("northeast", it.northeast()))
  }
  return map
}

fun ScreenCoordinate.toFLTScreenCoordinate(context: Context): FLTMapInterfaces.ScreenCoordinate {
  return FLTMapInterfaces.ScreenCoordinate.Builder()
    .setX(x.toLogicalPixels(context))
    .setY(y.toLogicalPixels(context))
    .build()
}

fun EdgeInsets.toFLTEdgeInsets(context: Context): FLTMapInterfaces.MbxEdgeInsets =
  FLTMapInterfaces.MbxEdgeInsets.Builder()
    .setLeft(left.toLogicalPixels(context))
    .setTop(top.toLogicalPixels(context))
    .setBottom(bottom.toLogicalPixels(context))
    .setRight(right.toLogicalPixels(context))
    .build()

fun CameraState.toCameraState(context: Context): FLTMapInterfaces.CameraState =
  FLTMapInterfaces.CameraState.Builder()
    .setBearing(bearing)
    .setPadding(padding.toFLTEdgeInsets(context))
    .setPitch(pitch)
    .setZoom(zoom)
    .setCenter(center.toMap())
    .build()

fun CoordinateBounds.toFLTCoordinateBounds(): FLTMapInterfaces.CoordinateBounds =
  FLTMapInterfaces.CoordinateBounds.Builder()
    .setNortheast(northeast.toMap())
    .setSouthwest(southwest.toMap())
    .setInfiniteBounds(infiniteBounds)
    .build()

fun CoordinateBoundsZoom.toFLTCoordinateBoundsZoom(): FLTMapInterfaces.CoordinateBoundsZoom =
  FLTMapInterfaces.CoordinateBoundsZoom.Builder()
    .setBounds(bounds.toFLTCoordinateBounds())
    .setZoom(zoom)
    .build()

fun CameraBounds.toFLTCameraBounds() = FLTMapInterfaces.CameraBounds.Builder().setMaxPitch(maxPitch)
  .setMinPitch(minPitch)
  .setMaxZoom(maxZoom)
  .setMinZoom(minZoom)
  .setBounds(bounds.toFLTCoordinateBounds())
  .build()

fun CameraOptions.toFLTCameraOptions(context: Context): FLTMapInterfaces.CameraOptions {
  val builder = FLTMapInterfaces.CameraOptions.Builder()
  anchor?.let { anchor ->
    builder.setAnchor(anchor.toFLTScreenCoordinate(context))
  }
  center?.let { center ->
    val centerMap = mutableMapOf<String, Any>()
    centerMap["coordinates"] = listOf(center.longitude(), center.latitude())
    builder.setCenter(centerMap)
  }
  padding?.let { padding ->
    val fLTPadding = FLTMapInterfaces.MbxEdgeInsets.Builder()
      .setBottom(padding.bottom.toLogicalPixels(context))
      .setLeft(padding.left.toLogicalPixels(context))
      .setRight(padding.right.toLogicalPixels(context))
      .setTop(padding.top.toLogicalPixels(context))
      .build()
    builder.setPadding(fLTPadding)
  }
  return builder
    .setZoom(zoom)
    .setPitch(pitch)
    .setBearing(bearing)
    .build()
}

fun JSONObject.toMap(): Map<String, *> = keys().asSequence().associateWith {
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
  return MbxImage.Builder().setWidth(width.toLong()).setHeight(height.toLong())
    .setData(outputStream.toByteArray()).build()
}