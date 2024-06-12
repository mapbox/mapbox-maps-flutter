package com.mapbox.maps.mapbox_maps.offline

import android.os.Handler
import android.os.Looper
import com.mapbox.maps.OfflineManager
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTStylePack
import com.mapbox.maps.mapbox_maps.toFLTStylePackLoadProgress
import com.mapbox.maps.mapbox_maps.toFLTValue
import com.mapbox.maps.mapbox_maps.toResult
import com.mapbox.maps.mapbox_maps.toStylePackLoadOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

private const val EVENT_CHANNEL_PREFIX = "com.mapbox.maps.flutter/offline"

class OfflineController(
  private val messenger: BinaryMessenger
) : _OfflineManager {

  private val offlineManager = OfflineManager()
  private var progressHandlers = HashMap<String, EventChannel.EventSink>()
  override fun loadStylePack(
    styleURI: String,
    loadOptions: StylePackLoadOptions,
    callback: (Result<StylePack>) -> Unit
  ) {
    offlineManager.loadStylePack(
      styleURI,
      loadOptions.toStylePackLoadOptions(),
      { progress ->
        Handler(Looper.getMainLooper()).post {
          progressHandlers[styleURI]?.success(progress.toFLTStylePackLoadProgress().toList())
          if (progress.completedResourceCount == progress.requiredResourceCount) {
            progressHandlers[styleURI]?.endOfStream()
          }
        }
      },
      { expected ->
        callback(expected.toResult { it.toFLTStylePack() })
      }
    )
  }

  override fun removeStylePack(styleURI: String, callback: (Result<StylePack>) -> Unit) {
    offlineManager.removeStylePack(
      styleURI
    ) { expected ->
      callback(expected.toResult { it.toFLTStylePack() })
    }
  }

  override fun addStylePackLoadProgressListener(styleURI: String) {
    val eventChannel = EventChannel(messenger, "com.mapbox.maps.flutter/offline/$styleURI")
    eventChannel.setStreamHandler(
      object : StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          events?.let { progressHandlers[styleURI] = it }
        }

        override fun onCancel(arguments: Any?) {
          progressHandlers.remove(styleURI)
        }
      }
    )
  }

  override fun stylePack(styleURI: String, callback: (Result<StylePack>) -> Unit) {
    offlineManager.getStylePack(styleURI) { expected ->
      callback(expected.toResult { it.toFLTStylePack() })
    }
  }

  override fun stylePackMetadata(styleURI: String, callback: (Result<Map<String, Any>>) -> Unit) {
    offlineManager.getStylePackMetadata(styleURI) { expected ->
      callback(expected.toResult { it.toFLTValue() as? kotlin.collections.Map<kotlin.String, kotlin.Any> ?: kotlin.collections.emptyMap() })
    }
  }

  override fun allStylePacks(callback: (Result<List<StylePack>>) -> Unit) {
    offlineManager.getAllStylePacks { expected ->
      callback(expected.toResult { it.map { stylePack -> stylePack.toFLTStylePack() } })
    }
  }
}