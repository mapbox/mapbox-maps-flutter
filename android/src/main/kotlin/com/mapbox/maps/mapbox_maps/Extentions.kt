package com.mapbox.maps.mapbox_maps

import com.google.gson.Gson
import com.mapbox.geojson.*
import com.mapbox.maps.*
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.animation.MapAnimationOptions
import org.json.JSONArray
import org.json.JSONObject

// FLT to Android
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

fun FLTMapInterfaces.MapMemoryBudgetInMegabytes.toMapMemoryBudgetInMegabytes(): MapMemoryBudgetInMegabytes {
  return MapMemoryBudgetInMegabytes(size)
}

fun FLTMapInterfaces.MapMemoryBudgetInTiles.toMapMemoryBudgetInTiles(): MapMemoryBudgetInTiles {
  return MapMemoryBudgetInTiles(size)
}

fun FLTMapInterfaces.SourceQueryOptions.toSourceQueryOptions(): SourceQueryOptions {
  return SourceQueryOptions(sourceLayerIds, filter.toValue())
}

fun FLTMapInterfaces.RenderedQueryGeometry.toRenderedQueryGeometry(): RenderedQueryGeometry {
  return when (type) {
    FLTMapInterfaces.Type.SCREEN_BOX -> RenderedQueryGeometry.valueOf(
      Gson().fromJson(
        value,
        ScreenBox::class.java
      )
    )
    FLTMapInterfaces.Type.LIST -> {
      val array: Array<ScreenCoordinate> =
        Gson().fromJson(value, Array<ScreenCoordinate>::class.java)
      RenderedQueryGeometry.valueOf(array.toList())
    }
    FLTMapInterfaces.Type.SCREEN_COORDINATE -> RenderedQueryGeometry.valueOf(
      Gson().fromJson(
        value,
        ScreenCoordinate::class.java
      )
    )
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

fun FLTMapInterfaces.MbxEdgeInsets.toEdgeInsets() = EdgeInsets(top, left, bottom, right)

fun FLTMapInterfaces.ScreenCoordinate.toScreenCoordinate() = ScreenCoordinate(x, y)

fun FLTMapInterfaces.CameraOptions.toCameraOptions(): CameraOptions = CameraOptions.Builder()
  .anchor(anchor?.toScreenCoordinate())
  .bearing(bearing)
  .center(center?.toPoint())
  .padding(padding?.toEdgeInsets())
  .zoom(zoom)
  .pitch(pitch)
  .build()

fun FLTMapInterfaces.ScreenBox.toScreenBox(): ScreenBox =
  ScreenBox(min.toScreenCoordinate(), max.toScreenCoordinate())

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
    else -> throw(RuntimeException("Unsupported Geometry: ${Gson().toJson(this)}"))
  }
}

// Android to FLT
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

fun TileStoreUsageMode.toFLTTileStoreUsageMode(): FLTMapInterfaces.TileStoreUsageMode {
  return FLTMapInterfaces.TileStoreUsageMode.values()[ordinal]
}

fun ResourceOptions.toFLTResourceOptions(): FLTMapInterfaces.ResourceOptions {
  val builder = FLTMapInterfaces.ResourceOptions.Builder()
    .setAccessToken(accessToken)
    .setTileStoreUsageMode(tileStoreUsageMode.toFLTTileStoreUsageMode())
  baseURL?.let {
    builder.setBaseURL(it)
  }
  dataPath?.let {
    builder.setDataPath(it)
  }
  assetPath?.let {
    builder.setAssetPath(it)
  }
  return builder.build()
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

fun MapOptions.toFLTMapOptions(): FLTMapInterfaces.MapOptions {
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
  optimizeForTerrain?.let {
    builder.setOptimizeForTerrain(it)
  }
  size?.let {
    builder.setSize(it.toFLTSize())
  }
  glyphsRasterizationOptions?.let {
    builder.setGlyphsRasterizationOptions(it.toFLTGlyphsRasterizationOptions())
  }
  return builder
    .setPixelRatio(pixelRatio.toDouble())
    .build()
}

fun Size.toFLTSize(): FLTMapInterfaces.Size {
  return FLTMapInterfaces.Size.Builder().setHeight(height.toDouble())
    .setWidth(width.toDouble())
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

fun ScreenCoordinate.toFLTScreenCoordinate(): FLTMapInterfaces.ScreenCoordinate {
  return FLTMapInterfaces.ScreenCoordinate.Builder()
    .setX(x)
    .setY(y)
    .build()
}

fun EdgeInsets.toFLTEdgeInsets(): FLTMapInterfaces.MbxEdgeInsets = FLTMapInterfaces.MbxEdgeInsets.Builder()
  .setLeft(left)
  .setTop(top)
  .setBottom(bottom)
  .setRight(right)
  .build()

fun CameraState.toCameraState(): FLTMapInterfaces.CameraState = FLTMapInterfaces.CameraState.Builder()
  .setBearing(bearing)
  .setPadding(padding.toFLTEdgeInsets())
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

fun CameraOptions.toFLTCameraOptions(): FLTMapInterfaces.CameraOptions {
  val builder = FLTMapInterfaces.CameraOptions.Builder()
  anchor?.let { anchor ->
    builder.setAnchor(anchor.toFLTScreenCoordinate())
  }
  center?.let { center ->
    val centerMap = mutableMapOf<String, Any>()
    centerMap["coordinates"] = listOf(center.longitude(), center.latitude())
    builder.setCenter(centerMap)
  }
  padding?.let { padding ->
    val fLTPadding = FLTMapInterfaces.MbxEdgeInsets.Builder()
      .setBottom(padding.bottom)
      .setLeft(padding.left)
      .setRight(padding.right)
      .setTop(padding.top)
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