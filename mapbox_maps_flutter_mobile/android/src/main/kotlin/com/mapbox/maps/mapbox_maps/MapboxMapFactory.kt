package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import com.mapbox.common.FeatureTelemetryCounter
import com.mapbox.maps.MapInitOptions
import com.mapbox.maps.MapOptions
import com.mapbox.maps.Style
import com.mapbox.maps.applyDefaultParams
import com.mapbox.maps.mapbox_maps.pigeons._MapInterface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapboxMapFactory(
  private val messenger: BinaryMessenger,
  private val flutterAssets: FlutterPlugin.FlutterAssets,
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider
) : PlatformViewFactory(_MapInterface.codec) {

  @SuppressLint("RestrictedApi")
  override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
    if (context == null) {
      throw RuntimeException("Context is null, can't create MapView!")
    }
    val params = args as Map<String, Any>
    val mapOptions = params["mapOptions"] as com.mapbox.maps.mapbox_maps.pigeons.MapOptions?
    val cameraOptions = params["cameraOptions"] as com.mapbox.maps.mapbox_maps.pigeons.CameraOptions?
    val channelSuffix = params["channelSuffix"] as Long
    val textureView = params["textureView"] as? Boolean ?: false
    val styleUri = params["styleUri"] as? String ?: Style.STANDARD
    val pluginVersion = params["mapboxPluginVersion"] as String
    val eventTypes = params["eventTypes"] as List<Long>

    val mapInitOptions = MapInitOptions(
      context = context,
      mapOptions = mapOptions?.toMapOptions(context) ?: MapOptions.Builder()
        .applyDefaultParams(context).build(),
      cameraOptions = cameraOptions?.toCameraOptions(context),
      textureView = textureView,
      styleUri = styleUri
    )
    mapCounter.increment()
    return MapboxMapController(
      context,
      mapInitOptions,
      lifecycleProvider,
      messenger,
      channelSuffix,
      pluginVersion,
      eventTypes
    )
  }

  companion object {
    @SuppressLint("RestrictedApi")
    private val mapCounter = FeatureTelemetryCounter.create("maps-mobile/flutter/map")
  }
}