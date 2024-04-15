package com.mapbox.maps.mapbox_maps

import androidx.lifecycle.Lifecycle
import com.mapbox.maps.mapbox_maps.pigeons._MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons._MapboxOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter

/** MapboxMapsPlugin */
class MapboxMapsPlugin : FlutterPlugin, ActivityAware {
  private val optionsController = MapboxOptionsController()

  private var lifecycle: Lifecycle? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // static options handling should be setup upon attachment,
    // as options can before configured before the map view is setup
    _MapboxMapsOptions.setUp(flutterPluginBinding.binaryMessenger, optionsController)
    _MapboxOptions.setUp(flutterPluginBinding.binaryMessenger, optionsController)

    LoggingController.setup(flutterPluginBinding.binaryMessenger)

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        "plugins.flutter.io/mapbox_maps",
        MapboxMapFactory(
          flutterPluginBinding.binaryMessenger,
          object : LifecycleProvider {
            override fun getLifecycle(): Lifecycle? {
              return lifecycle
            }
          }
        )
      )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    lifecycle = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
  }

  override fun onDetachedFromActivity() {
    lifecycle = null
  }

  interface LifecycleProvider {
    fun getLifecycle(): Lifecycle?
  }
}