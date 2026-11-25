package com.mapbox.maps.mapbox_maps.offline

import android.content.Context
import android.os.Handler
import com.mapbox.maps.OfflineManager
import com.mapbox.maps.mapbox_maps.CancelableOperationRegistry
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTStylePack
import com.mapbox.maps.mapbox_maps.toFLTStylePackLoadProgress
import com.mapbox.maps.mapbox_maps.toFLTValue
import com.mapbox.maps.mapbox_maps.toResult
import com.mapbox.maps.mapbox_maps.toStylePackLoadOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

class OfflineController(
  private val context: Context,
  private val messenger: BinaryMessenger,
  private val channelSuffix: String,
  private val operationRegistry: CancelableOperationRegistry,
) : _OfflineManager {

  private val offlineManager = OfflineManager()
  private val progressHandlers = HashMap<Long, EventChannel.EventSink>()
  private val mainHandler = Handler(context.mainLooper)

  override fun loadStylePack(
    styleURI: String,
    loadOptions: StylePackLoadOptions,
    operationId: Long,
    callback: (Result<StylePack>) -> Unit
  ) {
    val cancelable = offlineManager.loadStylePack(
      styleURI,
      loadOptions.toStylePackLoadOptions(),
      { progress ->
        mainHandler.post {
          progressHandlers[operationId]?.success(progress.toFLTStylePackLoadProgress().toList())
        }
      },
      { expected ->
        mainHandler.post {
          operationRegistry.unregister(operationId)
          callback(expected.toResult { it.toFLTStylePack() })
          progressHandlers.remove(operationId)?.endOfStream()
        }
      }
    )
    operationRegistry.register(operationId, cancelable)
  }

  override fun removeStylePack(styleURI: String, callback: (Result<StylePack>) -> Unit) {
    offlineManager.removeStylePack(
      styleURI
    ) { expected ->
      mainHandler.post {
        callback(expected.toResult { it.toFLTStylePack() })
      }
    }
  }

  override fun addStylePackLoadProgressListener(styleURI: String, operationId: Long) {
    val eventChannel = EventChannel(messenger, "com.mapbox.maps.flutter/$channelSuffix/style-pack-$operationId")
    eventChannel.setStreamHandler(
      object : StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { progressHandlers[operationId] = it }
        }

        override fun onCancel(arguments: Any?) {
          progressHandlers.remove(operationId)
          eventChannel.setStreamHandler(null)
        }
      }
    )
  }

  override fun stylePack(styleURI: String, callback: (Result<StylePack>) -> Unit) {
    offlineManager.getStylePack(styleURI) { expected ->
      mainHandler.post {
        callback(expected.toResult { it.toFLTStylePack() })
      }
    }
  }

  override fun stylePackMetadata(styleURI: String, callback: (Result<Map<String, Any>>) -> Unit) {
    offlineManager.getStylePackMetadata(styleURI) { expected ->
      mainHandler.post {
        callback(expected.toResult { it.toFLTValue() as? kotlin.collections.Map<kotlin.String, kotlin.Any> ?: kotlin.collections.emptyMap() })
      }
    }
  }

  override fun allStylePacks(callback: (Result<List<StylePack>>) -> Unit) {
    offlineManager.getAllStylePacks { expected ->
      mainHandler.post {
        callback(expected.toResult { it.map { stylePack -> stylePack.toFLTStylePack() } })
      }
    }
  }
}