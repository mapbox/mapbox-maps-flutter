package com.mapbox.maps.mapbox_maps

import com.google.gson.Gson
import com.mapbox.geojson.Feature
import com.mapbox.maps.*
import com.mapbox.maps.extension.observable.eventdata.MapLoadingErrorEventData
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.delegates.listeners.OnMapLoadErrorListener

class MapInterfaceController(private val mapboxMap: MapboxMap) : FLTMapInterfaces._MapInterface {
  override fun loadStyleURI(
    styleURI: String,
    result: FLTMapInterfaces.Result<Void>?
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
    result: FLTMapInterfaces.Result<Void>?
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

  override fun clearData(result: FLTMapInterfaces.Result<Void>?) {
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
    mapMemoryBudgetInMegabytes: FLTMapInterfaces.MapMemoryBudgetInMegabytes?,
    mapMemoryBudgetInTiles: FLTMapInterfaces.MapMemoryBudgetInTiles?
  ) {
    if (mapMemoryBudgetInMegabytes != null) {
      mapboxMap.setMemoryBudget(MapMemoryBudget.valueOf(mapMemoryBudgetInMegabytes.toMapMemoryBudgetInMegabytes()))
    } else if (mapMemoryBudgetInTiles != null) {
      mapboxMap.setMemoryBudget(MapMemoryBudget.valueOf(mapMemoryBudgetInTiles.toMapMemoryBudgetInTiles()))
    }
  }

  override fun getSize(): FLTMapInterfaces.Size {
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

  override fun setNorthOrientation(orientation: FLTMapInterfaces.NorthOrientation) {
    mapboxMap.setNorthOrientation(NorthOrientation.values()[orientation.ordinal])
  }

  override fun setConstrainMode(mode: FLTMapInterfaces.ConstrainMode) {
    mapboxMap.setConstrainMode(ConstrainMode.values()[mode.ordinal])
  }

  override fun setViewportMode(mode: FLTMapInterfaces.ViewportMode) {
    mapboxMap.setViewportMode(ViewportMode.values()[mode.ordinal])
  }

  override fun getMapOptions(): FLTMapInterfaces.MapOptions {
    return mapboxMap.getMapOptions().toFLTMapOptions()
  }

  override fun getDebug(): MutableList<FLTMapInterfaces.MapDebugOptions> {
    return mapboxMap.getDebug().map { it.toFLTMapDebugOptions() }.toMutableList()
  }

  override fun setDebug(debugOptions: MutableList<FLTMapInterfaces.MapDebugOptions>, value: Boolean) {
    mapboxMap.setDebug(debugOptions.map { it.toMapDebugOptions() }, value)
  }

  override fun queryRenderedFeatures(
    geometry: FLTMapInterfaces.RenderedQueryGeometry,
    options: FLTMapInterfaces.RenderedQueryOptions,
    result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.QueriedFeature>>?
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
    options: FLTMapInterfaces.SourceQueryOptions,
    result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.QueriedFeature>>?
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
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>?
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
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>?
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
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>?
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
    result: FLTMapInterfaces.Result<String>?
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

  override fun getResourceOptions(): FLTMapInterfaces.ResourceOptions {
    return mapboxMap.getResourceOptions().toFLTResourceOptions()
  }

  override fun getElevation(coordinate: MutableMap<String, Any>): Double? {
    return mapboxMap.getElevation(coordinate.toPoint())
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