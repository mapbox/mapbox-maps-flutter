package com.mapbox.maps.mapbox_maps.offline

import android.os.Handler
import android.os.Looper
import com.mapbox.common.TileStore
import com.mapbox.maps.OfflineManager
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTTileRegion
import com.mapbox.maps.mapbox_maps.toFLTTileRegionEstimateProgress
import com.mapbox.maps.mapbox_maps.toFLTTileRegionEstimateResult
import com.mapbox.maps.mapbox_maps.toFLTTileRegionLoadProgress
import com.mapbox.maps.mapbox_maps.toFLTValue
import com.mapbox.maps.mapbox_maps.toGeometry
import com.mapbox.maps.mapbox_maps.toNetworkRestriction
import com.mapbox.maps.mapbox_maps.toTileRegionEstimateOptions
import com.mapbox.maps.mapbox_maps.toTilesetDescriptorOptions
import com.mapbox.maps.mapbox_maps.toValue
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

private const val EVENT_CHANNEL_PREFIX = "com.mapbox.maps.flutter/tilestore"

class TileStoreController(
  private val binaryMessenger: BinaryMessenger,
  private val tileStore: TileStore
) : _TileStore {

  private val offlineManager = OfflineManager()
  private var tileRegionLoadProgressHandlers = HashMap<String, EventChannel.EventSink>()
  private var tileRegionEstimateProgressHandlers = HashMap<String, EventChannel.EventSink>()
  private val mainHandler = Handler(Looper.getMainLooper())

  override fun loadTileRegion(
    id: String,
    loadOptions: TileRegionLoadOptions,
    callback: (Result<TileRegion>) -> Unit
  ) {
    tileStore.loadTileRegion(
      id, offlineManager.tileRegionLoadOptions(loadOptions),
      { progress ->
        mainHandler.post {
          tileRegionLoadProgressHandlers[id]?.success(progress.toFLTTileRegionLoadProgress().toList())
        }
      },
      { expected ->
        expected.value?.let {
          callback(Result.success(it.toFLTTileRegion()))
        }
        expected.error?.let {
          callback(Result.failure(Throwable(it.message ?: "Unknown error")))
        }
      }
    )
  }

  override fun addTileRegionLoadProgressListener(id: String) {
    val eventChannel = EventChannel(binaryMessenger, "com.mapbox.maps.flutter/tilestore/tile-region-$id")
    eventChannel.setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { tileRegionLoadProgressHandlers[id] = it }
        }
        override fun onCancel(arguments: Any?) {
          tileRegionLoadProgressHandlers.remove(id)
        }
      }
    )
  }

  override fun estimateTileRegion(
    id: String,
    loadOptions: TileRegionLoadOptions,
    estimateOptions: TileRegionEstimateOptions?,
    callback: (Result<TileRegionEstimateResult>) -> Unit
  ) {
    tileStore.estimateTileRegion(
      id,
      offlineManager.tileRegionLoadOptions(loadOptions),
      estimateOptions?.toTileRegionEstimateOptions() ?: com.mapbox.common.TileRegionEstimateOptions(null),
      { progress ->
        tileRegionEstimateProgressHandlers[id]?.success(progress.toFLTTileRegionEstimateProgress().toList())
      },
      { expected ->
        expected.value?.let {
          callback(Result.success(it.toFLTTileRegionEstimateResult()))
        }
        expected.error?.let {
          callback(Result.failure(Throwable(it.message ?: "Unknown error")))
        }
      }
    )
  }

  override fun addTileRegionEstimateProgressListener(id: String) {
    val eventChannel = EventChannel(binaryMessenger, "com.mapbox.maps.flutter/tilestore/tile-region-estimate$id")
    eventChannel.setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { tileRegionEstimateProgressHandlers[id] = it }
        }
        override fun onCancel(arguments: Any?) {
          tileRegionEstimateProgressHandlers.remove(id)
        }
      }
    )
  }

  override fun tileRegionMetadata(id: String, callback: (Result<Map<String?, Any?>>) -> Unit) {
    tileStore.getTileRegionMetadata(id) { expected ->
      expected.value?.let {
        callback(Result.success(it.toFLTValue() as Map<String?, Any?>))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }

  override fun allTileRegions(callback: (Result<List<TileRegion>>) -> Unit) {
    tileStore.getAllTileRegions { expected ->
      expected.value?.let { tileRegions ->
        callback(Result.success(tileRegions.map { it.toFLTTileRegion() }))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }

  override fun tileRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.getTileRegion(id) { expected ->
      expected.value?.let {
        callback(Result.success(it.toFLTTileRegion()))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }

  override fun removeRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.removeTileRegion(
      id,
      { expected ->
        expected.value?.let {
          callback(Result.success(it.toFLTTileRegion()))
        }
        expected.error?.let {
          callback(Result.failure(Throwable(it.message ?: "Unknown error")))
        }
      }
    )
  }
}

private fun OfflineManager.tileRegionLoadOptions(fltValue: TileRegionLoadOptions): com.mapbox.common.TileRegionLoadOptions {
  val builder = com.mapbox.common.TileRegionLoadOptions.Builder()
    .geometry(fltValue.geometry?.toGeometry())
    .metadata(fltValue.metadata?.toValue())
    .acceptExpired(fltValue.acceptExpired)
    .networkRestriction(fltValue.networkRestriction.toNetworkRestriction())
    .startLocation(fltValue.startLocation)
    .averageBytesPerSecond(fltValue.averageBytesPerSecond?.toInt())
    .extraOptions(fltValue.extraOptions?.toValue())

  fltValue.descriptorsOptions?.let { options ->
    val descriptors: List<TilesetDescriptorOptions> = options.filterNotNull()
    builder.descriptors(
      descriptors.map { createTilesetDescriptor(it.toTilesetDescriptorOptions()) }
    )
  }

  return builder.build()
}