package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.google.gson.Gson
import com.mapbox.geojson.Feature
import com.mapbox.maps.*
import com.mapbox.maps.extension.observable.eventdata.MapLoadingErrorEventData
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.delegates.listeners.OnMapLoadErrorListener

class MapInterfaceController(private val mapboxMap: MapboxMap, private val context: Context) : FLTMapInterfaces._MapInterface {
  override fun loadStyleURI(
    styleURI: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.loadStyleUri(
      styleURI,
      { result.success() },
      object : OnMapLoadErrorListener {
        override fun onMapLoadError(eventData: MapLoadingErrorEventData) {
          result.error(Throwable(eventData.message))
        }
      }
    )
  }

  override fun loadStyleJson(
    styleJson: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.loadStyleJson(
      styleJson,
      { result.success() },
      object : OnMapLoadErrorListener {
        override fun onMapLoadError(eventData: MapLoadingErrorEventData) {
          result.error(Throwable(eventData.message))
        }
      }
    )
  }

  override fun clearData(result: FLTMapInterfaces.VoidResult) {
    MapboxMap.clearData {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success()
      }
    }
  }

  @OptIn(MapboxExperimental::class)
  override fun setTileCacheBudget(
    tileCacheBudgetInMegabytes: FLTMapInterfaces.TileCacheBudgetInMegabytes?,
    tileCacheBudgetInTiles: FLTMapInterfaces.TileCacheBudgetInTiles?
  ) {
    if (tileCacheBudgetInMegabytes != null) {
      mapboxMap.setTileCacheBudget(TileCacheBudget.valueOf(tileCacheBudgetInMegabytes.toMapMemoryBudgetInMegabytes()))
    } else if (tileCacheBudgetInTiles != null) {
      mapboxMap.setTileCacheBudget(TileCacheBudget.valueOf(tileCacheBudgetInTiles.toMapMemoryBudgetInTiles()))
    }
  }

  override fun getSize(): FLTMapInterfaces.Size {
    return mapboxMap.getSize().toFLTSize(context)
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
    return mapboxMap.getMapOptions().toFLTMapOptions(context)
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
    result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.QueriedRenderedFeature>>
  ) {
    mapboxMap.queryRenderedFeatures(
      geometry.toRenderedQueryGeometry(context),
      options.toRenderedQueryOptions()
    ) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success(
          it.value!!.map { feature -> feature.toFLTQueriedRenderedFeature() }.toMutableList()
        )
      }
    }
  }

  override fun querySourceFeatures(
    sourceId: String,
    options: FLTMapInterfaces.SourceQueryOptions,
    result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.QueriedSourceFeature>>
  ) {
    mapboxMap.querySourceFeatures(sourceId, options.toSourceQueryOptions()) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success(
          it.value!!.map { feature -> feature.toFLTQueriedSourceFeature() }.toMutableList()
        )
      }
    }
  }

  override fun getGeoJsonClusterLeaves(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    limit: Long?,
    offset: Long?,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>
  ) {
    mapboxMap.getGeoJsonClusterLeaves(
      sourceIdentifier, Feature.fromJson(Gson().toJson(cluster)),
      limit ?: 10, offset ?: 0
    ) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success(it.value!!.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun getGeoJsonClusterChildren(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>
  ) {
    mapboxMap.getGeoJsonClusterChildren(
      sourceIdentifier,
      Feature.fromJson(Gson().toJson(cluster))
    ) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success(it.value!!.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun getGeoJsonClusterExpansionZoom(
    sourceIdentifier: String,
    cluster: MutableMap<String, Any>,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.FeatureExtensionValue>
  ) {
    mapboxMap.getGeoJsonClusterExpansionZoom(
      sourceIdentifier,
      Feature.fromJson(Gson().toJson(cluster))
    ) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success(it.value!!.toFLTFeatureExtensionValue())
      }
    }
  }

  override fun setFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    state: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.setFeatureState(sourceId, sourceLayerId, featureId, state.toValue()) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success()
      }
    }
  }

  override fun getFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    result: FLTMapInterfaces.Result<String>
  ) {
    mapboxMap.getFeatureState(sourceId, sourceLayerId, featureId) { expected ->
      result.let {
        if (expected.isError) {
          it.error(Throwable(expected.error))
        } else {
          it.success(expected.value!!.toJson())
        }
      }
    }
  }

  override fun removeFeatureState(
    sourceId: String,
    sourceLayerId: String?,
    featureId: String,
    stateKey: String?,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.removeFeatureState(sourceId, sourceLayerId, featureId, stateKey) {
      if (it.isError) {
        result.error(Throwable(it.error))
      } else {
        result.success()
      }
    }
  }

  override fun reduceMemoryUse() {
    mapboxMap.reduceMemoryUse()
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