package com.mapbox.maps.mapbox_maps.offline

import com.mapbox.maps.OfflineManager
import com.mapbox.maps.StylePackLoadProgress
import com.mapbox.maps.StylePackLoadProgressCallback
import com.mapbox.maps.mapbox_maps.ProxyBinaryMessenger
import com.mapbox.maps.mapbox_maps.pigeons.StylePack
import com.mapbox.maps.mapbox_maps.pigeons.StylePackLoadOptions
import com.mapbox.maps.mapbox_maps.pigeons._OfflineManager
import com.mapbox.maps.mapbox_maps.toFLTStylePack
import com.mapbox.maps.mapbox_maps.toStylePackLoadOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import kotlin.math.exp

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
      },
      { expected ->
        progressHandlers[styleURI]?.endOfStream()
        expected.value?.let {
          callback(Result.success(it.toFLTStylePack()))
        }
        expected.error?.let {
          callback(Result.failure(Throwable(it.message ?: "Unknown error")))
        }
      }
    )
  }

  override fun removeStylePack(styleURI: String, callback: (Result<StylePack>) -> Unit) {
    offlineManager.removeStylePack(
      styleURI
    ) { expected ->
      expected.value?.let {
        callback(Result.success(it.toFLTStylePack()))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }

  override fun addStylePackLoadProgressListener(styleURI: String) {
    val eventChannel = EventChannel(messenger, "com.mapbox.maps.flutter/offline/${styleURI}")
    eventChannel.setStreamHandler(
      object: StreamHandler {
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
      expected.value?.let {
        callback(Result.success(it.toFLTStylePack()))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }

  override fun stylePackMetadata(styleURI: String, callback: (Result<String?>) -> Unit) {
    offlineManager.getStylePackMetadata(styleURI) { expected ->
      expected.value?.let {
        callback(Result.success(it.toString()))
      }
      expected.error?.let {
        callback(Result.failure(Throwable(it.message ?: "Unknown error")))
      }
    }
  }
}