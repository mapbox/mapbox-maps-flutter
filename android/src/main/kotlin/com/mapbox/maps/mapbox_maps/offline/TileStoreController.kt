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
import com.mapbox.maps.mapbox_maps.toResult
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

  override fun loadTileRegion(
    id: String,
    loadOptions: TileRegionLoadOptions,
    callback: (Result<TileRegion>) -> Unit
  ) {
    tileStore.loadTileRegion(
      id, offlineManager.tileRegionLoadOptions(loadOptions),
      { progress ->
        Handler(Looper.getMainLooper()).post {
          tileRegionLoadProgressHandlers[id]?.success(progress.toFLTTileRegionLoadProgress().toList())
          if (progress.completedResourceCount == progress.requiredResourceCount) {
            tileRegionLoadProgressHandlers[id]?.endOfStream()
          }
        }
      },
      { expected ->
        callback(expected.toResult { it.toFLTTileRegion() })
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
        Handler(Looper.getMainLooper()).post {
          tileRegionEstimateProgressHandlers[id]?.success(
            progress.toFLTTileRegionEstimateProgress().toList()
          )
          if (progress.completedResourceCount == progress.requiredResourceCount) {
            tileRegionEstimateProgressHandlers[id]?.endOfStream()
          }
        }
      },
      { expected ->
        callback(expected.toResult { it.toFLTTileRegionEstimateResult() })
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

  override fun tileRegionMetadata(id: String, callback: (Result<Map<String, Any>>) -> Unit) {
    tileStore.getTileRegionMetadata(id) { expected ->
      callback(expected.toResult { it.toFLTValue() as? Map<String, Any> ?: emptyMap() })
    }
  }

  override fun tileRegionContainsDescriptor(id: String, options: List<TilesetDescriptorOptions>, callback: (Result<Boolean>) -> Unit) {
    val descriptors = options.map { offlineManager.createTilesetDescriptor(it.toTilesetDescriptorOptions()) }
    tileStore.tileRegionContainsDescriptors(id, descriptors) { expected ->
      callback(expected.toResult { it })
    }
  }

  override fun allTileRegions(callback: (Result<List<TileRegion>>) -> Unit) {
    tileStore.getAllTileRegions { expected ->
      callback(expected.toResult { it.map { region -> region.toFLTTileRegion() } })
    }
  }

  override fun tileRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.getTileRegion(id) { expected ->
      callback(expected.toResult { it.toFLTTileRegion() })
    }
  }

  override fun removeRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.removeTileRegion(
      id,
      { expected ->
        callback(expected.toResult { it.toFLTTileRegion() })
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