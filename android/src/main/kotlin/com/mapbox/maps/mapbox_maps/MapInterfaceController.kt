package com.mapbox.maps.mapbox_maps

import com.google.gson.Gson
import com.mapbox.geojson.Feature
import com.mapbox.maps.*
import com.mapbox.maps.extension.observable.eventdata.MapLoadingErrorEventData
import com.mapbox.maps.pigeons.FLTMapboxMap
import com.mapbox.maps.plugin.delegates.listeners.OnMapLoadErrorListener

class MapInterfaceController(private val mapboxMap: MapboxMap) : FLTMapboxMap._MapInterface {
  override fun loadStyleURI(
    styleURI: String,
    result: FLTMapboxMap.Result<Void>?
  ) {
    mapboxMap.loadStyleUri(
      styleURI,
      { result?.success(null) },
      object : OnMapLoadErrorListener {
        override fun onMapLoadError(eventData: MapLoadingErrorEventData) {
          result?.error(Throwable(eventData.message))
        }
      }
    )
  }

  override fun loadStyleJson(
    styleJson: String,
    result: FLTMapboxMap.Result<Void>?
  ) {
    mapboxMap.loadStyleJson(
      styleJson,
      { result?.success(null) },
      object : OnMapLoadErrorListener {
        override fun onMapLoadError(eventData: MapLoadingErrorEventData) {
          result?.error(Throwable(eventData.message))
        }
      }
    )
  }

  override fun clearData(result: FLTMapboxMap.Result<Void>?) {
    mapboxMap.clearData {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(null)
      }
    }
  }

  @OptIn(MapboxExperimental::class)
  override fun setMemoryBudget(
    mapMemoryBudgetInMegabytes: FLTMapboxMap.MapMemoryBudgetInMegabytes?,
    mapMemoryBudgetInTiles: FLTMapboxMap.MapMemoryBudgetInTiles?
  ) {
    if (mapMemoryBudgetInMegabytes != null) {
      mapboxMap.setMemoryBudget(MapMemoryBudget.valueOf(mapMemoryBudgetInMegabytes.toMapMemoryBudgetInMegabytes()))
    } else if (mapMemoryBudgetInTiles != null) {
      mapboxMap.setMemoryBudget(MapMemoryBudget.valueOf(mapMemoryBudgetInTiles.toMapMemoryBudgetInTiles()))
    }
  }

  override fun getSize(): FLTMapboxMap.Size {
    return mapboxMap.getSize().toFLTSize()
  }

  override fun triggerRepaint() {
    mapboxMap.triggerRepaint()
  }

  override fun isGestureInProgress(): Boolean {
    return mapboxMap.isGestureInProgress()
  }

  override fun isUserAnimationInProgress(): Boolean {
    return mapboxMap.isUserAnimationInProgress()
  }

  override fun getPrefetchZoomDelta(): Long {
    return mapboxMap.getPrefetchZoomDelta().toLong()
  }

  override fun setNorthOrientation(orientation: FLTMapboxMap.NorthOrientation) {
    mapboxMap.setNorthOrientation(NorthOrientation.values()[orientation.ordinal])
  }

  override fun setConstrainMode(mode: FLTMapboxMap.ConstrainMode) {
    mapboxMap.setConstrainMode(ConstrainMode.values()[mode.ordinal])
  }

  override fun setViewportMode(mode: FLTMapboxMap.ViewportMode) {
    mapboxMap.setViewportMode(ViewportMode.values()[mode.ordinal])
  }

  override fun getMapOptions(): FLTMapboxMap.MapOptions {
    return mapboxMap.getMapOptions().toFLTMapOptions()
  }

  override fun getDebug(): MutableList<FLTMapboxMap.MapDebugOptions> {
    return mapboxMap.getDebug().map { it.toFLTMapDebugOptions() }.toMutableList()
  }

  override fun setDebug(debugOptions: MutableList<FLTMapboxMap.MapDebugOptions>, value: Boolean) {
    mapboxMap.setDebug(debugOptions.map { it.toMapDebugOptions() }, value)
  }

  override fun queryRenderedFeatures(
    geometry: FLTMapboxMap.RenderedQueryGeometry,
    options: FLTMapboxMap.RenderedQueryOptions,
    result: FLTMapboxMap.Result<MutableList<FLTMapboxMap.QueriedFeature>>?
  ) {
    mapboxMap.queryRenderedFeatures(
      geometry.toRenderedQueryGeometry(),
      options.toRenderedQueryOptions()
    ) {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(
          it.value?.map { feature -> feature.toFLTQueriedFeature() }
            ?.toMutableList()
        )
      }
    }
  }

  override fun querySourceFeatures(
    sourceId: String,
    options: FLTMapboxMap.SourceQueryOptions,
    result: FLTMapboxMap.Result<MutableList<FLTMapboxMap.QueriedFeature>>?
  ) {
    mapboxMap.querySourceFeatures(sourceId, options.toSourceQueryOptions()) {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(
          it.value?.map { feature -> feature.toFLTQueriedFeature() }
            ?.toMutableList()
        )
      }
    }
  }

  override fun getGeoJsonClusterLeaves(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    limit: Long?,
    offset: Long?,
    result: FLTMapboxMap.Result<FLTMapboxMap.FeatureExtensionValue>?
  ) {
    mapboxMap.getGeoJsonClusterLeaves(
      sourceIdentifier, Feature.fromJson(Gson().toJson(cluster)),
      limit ?: 10, offset ?: 0
    ) {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(it.value?.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun getGeoJsonClusterChildren(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    result: FLTMapboxMap.Result<FLTMapboxMap.FeatureExtensionValue>?
  ) {
    mapboxMap.getGeoJsonClusterChildren(
      sourceIdentifier,
      Feature.fromJson(Gson().toJson(cluster))
    ) {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(it.value?.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun getGeoJsonClusterExpansionZoom(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    result: FLTMapboxMap.Result<FLTMapboxMap.FeatureExtensionValue>?
  ) {
    mapboxMap.getGeoJsonClusterExpansionZoom(
      sourceIdentifier,
      Feature.fromJson(Gson().toJson(cluster))
    ) {
      if (it.isError) {
        result?.error(Throwable(it.error))
      } else {
        result?.success(it.value?.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun setFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    state: String
  ) {
    mapboxMap.setFeatureState(sourceId, sourceLayerId, featureId, state.toValue())
  }

  override fun getFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    result: FLTMapboxMap.Result<String>?
  ) {
    return mapboxMap.getFeatureState(sourceId, sourceLayerId, featureId) { expected ->
      result?.let {
        if (expected.isError) {
          it.error(Throwable(expected.error))
        } else {
          it.success(expected.value?.toJson())
        }
      }
    }
  }

  override fun removeFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    stateKey: String?
  ) {
    mapboxMap.removeFeatureState(sourceId, sourceLayerId, featureId, stateKey)
  }

  override fun reduceMemoryUse() {
    mapboxMap.reduceMemoryUse()
  }

  override fun getResourceOptions(): FLTMapboxMap.ResourceOptions {
    return mapboxMap.getResourceOptions().toFLTResourceOptions()
  }

  override fun getElevation(coordinate: MutableMap<String, Any>): Double? {
    return mapboxMap.getElevation(coordinate.toPoint())
  }

  @OptIn(MapboxExperimental::class)
  override fun setRenderCacheOptions(options: FLTMapboxMap.RenderCacheOptions) {
    mapboxMap.setRenderCacheOptions(options.toRenderCacheOptions())
  }

  @OptIn(MapboxExperimental::class)
  override fun getRenderCacheOptions(): FLTMapboxMap.RenderCacheOptions {
    return mapboxMap.getRenderCacheOptions().toFLTRenderCacheOptions()
  }

  override fun setPrefetchZoomDelta(delta: Long) {
    mapboxMap.setPrefetchZoomDelta(delta.toByte())
  }

  override fun setUserAnimationInProgress(inProgress: Boolean) {
    mapboxMap.setUserAnimationInProgress(inProgress)
  }

  override fun setGestureInProgress(inProgress: Boolean) {
    mapboxMap.setGestureInProgress(inProgress)
  }
}