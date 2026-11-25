package com.mapbox.maps.mapbox_maps.offline

import android.content.Context
import android.os.Handler
import com.mapbox.common.TileStore
import com.mapbox.maps.OfflineManager
import com.mapbox.maps.mapbox_maps.CancelableOperationRegistry
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTTileRegion
import com.mapbox.maps.mapbox_maps.toFLTTileRegionEstimateProgress
import com.mapbox.maps.mapbox_maps.toFLTTileRegionEstimateResult
import com.mapbox.maps.mapbox_maps.toFLTTileRegionLoadProgress
import com.mapbox.maps.mapbox_maps.toFLTValue
import com.mapbox.maps.mapbox_maps.toGeometry
import com.mapbox.maps.mapbox_maps.toNetworkRestriction
import com.mapbox.maps.mapbox_maps.toResult
import com.mapbox.maps.mapbox_maps.toTileDataDomain
import com.mapbox.maps.mapbox_maps.toTileRegionEstimateOptions
import com.mapbox.maps.mapbox_maps.toTileStoreOptionsKey
import com.mapbox.maps.mapbox_maps.toTilesetDescriptorOptions
import com.mapbox.maps.mapbox_maps.toValue
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

private const val EVENT_CHANNEL_PREFIX = "com.mapbox.maps.flutter/tilestore"

class TileStoreController(
  private val context: Context,
  private val binaryMessenger: BinaryMessenger,
  private val channelSuffix: String,
  private val tileStore: TileStore,
  private val operationRegistry: CancelableOperationRegistry
) : _TileStore {

  private val offlineManager = OfflineManager()
  private val tileRegionLoadProgressHandlers = HashMap<Long, EventChannel.EventSink>()
  private val tileRegionEstimateProgressHandlers = HashMap<Long, EventChannel.EventSink>()
  private val mainHandler = Handler(context.mainLooper)

  override fun loadTileRegion(
    id: String,
    loadOptions: TileRegionLoadOptions,
    operationId: Long,
    callback: (Result<TileRegion>) -> Unit
  ) {
    val cancelable = tileStore.loadTileRegion(
      id, offlineManager.tileRegionLoadOptions(loadOptions, context),
      { progress ->
        mainHandler.post {
          tileRegionLoadProgressHandlers[operationId]?.success(progress.toFLTTileRegionLoadProgress().toList())
        }
      },
      { expected ->
        mainHandler.post {
          operationRegistry.unregister(operationId)
          callback(expected.toResult { it.toFLTTileRegion() })
          tileRegionLoadProgressHandlers.remove(operationId)?.endOfStream()
        }
      }
    )
    operationRegistry.register(operationId, cancelable)
  }

  override fun addTileRegionLoadProgressListener(id: String, operationId: Long) {
    val eventChannel = EventChannel(binaryMessenger, "com.mapbox.maps.flutter/$channelSuffix/tile-region-$operationId")
    eventChannel.setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { tileRegionLoadProgressHandlers[operationId] = it }
        }
        override fun onCancel(arguments: Any?) {
          tileRegionLoadProgressHandlers.remove(operationId)
          eventChannel.setStreamHandler(null)
        }
      }
    )
  }

  override fun estimateTileRegion(
    id: String,
    loadOptions: TileRegionLoadOptions,
    estimateOptions: TileRegionEstimateOptions?,
    operationId: Long,
    callback: (Result<TileRegionEstimateResult>) -> Unit
  ) {
    val cancelable = tileStore.estimateTileRegion(
      id,
      offlineManager.tileRegionLoadOptions(loadOptions, context),
      estimateOptions?.toTileRegionEstimateOptions() ?: com.mapbox.common.TileRegionEstimateOptions(null),
      { progress ->
        mainHandler.post {
          tileRegionEstimateProgressHandlers[operationId]?.success(
            progress.toFLTTileRegionEstimateProgress().toList()
          )
        }
      },
      { expected ->
        mainHandler.post {
          operationRegistry.unregister(operationId)
          callback(expected.toResult { it.toFLTTileRegionEstimateResult() })
          tileRegionEstimateProgressHandlers.remove(operationId)?.endOfStream()
        }
      }
    )
    operationRegistry.register(operationId, cancelable)
  }

  override fun addTileRegionEstimateProgressListener(id: String, operationId: Long) {
    val eventChannel = EventChannel(binaryMessenger, "com.mapbox.maps.flutter/$channelSuffix/tile-region-estimate-$operationId")
    eventChannel.setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { tileRegionEstimateProgressHandlers[operationId] = it }
        }
        override fun onCancel(arguments: Any?) {
          tileRegionEstimateProgressHandlers.remove(operationId)
          eventChannel.setStreamHandler(null)
        }
      }
    )
  }

  override fun tileRegionMetadata(id: String, callback: (Result<Map<String, Any>>) -> Unit) {
    tileStore.getTileRegionMetadata(id) { expected ->
      mainHandler.post {
        callback(expected.toResult { it.toFLTValue() as? Map<String, Any> ?: emptyMap() })
      }
    }
  }

  override fun tileRegionContainsDescriptor(id: String, options: List<TilesetDescriptorOptions>, callback: (Result<Boolean>) -> Unit) {
    val descriptors = options.map { offlineManager.createTilesetDescriptor(it.toTilesetDescriptorOptions(context)) }
    tileStore.tileRegionContainsDescriptors(id, descriptors) { expected ->
      mainHandler.post {
        callback(expected.toResult { it })
      }
    }
  }

  override fun allTileRegions(callback: (Result<List<TileRegion>>) -> Unit) {
    tileStore.getAllTileRegions { expected ->
      mainHandler.post {
        callback(expected.toResult { it.map { region -> region.toFLTTileRegion() } })
      }
    }
  }

  override fun tileRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.getTileRegion(id) { expected ->
      mainHandler.post {
        callback(expected.toResult { it.toFLTTileRegion() })
      }
    }
  }

  override fun removeRegion(id: String, callback: (Result<TileRegion>) -> Unit) {
    tileStore.removeTileRegion(
      id,
      { expected ->
        mainHandler.post {
          callback(expected.toResult { it.toFLTTileRegion() })
        }
      }
    )
  }

  override fun setOptionForKey(key: _KeyedTileStoreOptions, domain: TileDataDomain?, value: Any?) {
    val keyString = when (key) {
      is _PredefinedTileStoreOptionsKey -> key.key.toTileStoreOptionsKey()
      is _CustomTileStoreOptionsKey -> key.key
    }
    domain?.also {
      tileStore.setOption(keyString, it.toTileDataDomain(), value?.toValue() ?: com.mapbox.bindgen.Value.nullValue())
    } ?: run {
      tileStore.setOption(keyString, value?.toValue() ?: com.mapbox.bindgen.Value.nullValue())
    }
  }
}

private fun OfflineManager.tileRegionLoadOptions(fltValue: TileRegionLoadOptions, context: Context): com.mapbox.common.TileRegionLoadOptions {
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
      descriptors.map { createTilesetDescriptor(it.toTilesetDescriptorOptions(context)) }
    )
  }

  return builder.build()
}