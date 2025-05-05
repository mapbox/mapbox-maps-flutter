package com.mapbox.maps.mapbox_maps

import android.content.Context
import androidx.lifecycle.Lifecycle
import com.mapbox.maps.mapbox_maps.offline.OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.offline.OfflineSwitch
import com.mapbox.maps.mapbox_maps.pigeons._MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons._MapboxOptions
import com.mapbox.maps.mapbox_maps.pigeons._OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._OfflineSwitch
import com.mapbox.maps.mapbox_maps.pigeons._SnapshotterInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._TileStoreInstanceManager
import com.mapbox.maps.mapbox_maps.snapshot.SnapshotterInstanceManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.BinaryMessenger

/** MapboxMapsPlugin */
class MapboxMapsPlugin : FlutterPlugin, ActivityAware {
  private var lifecycle: Lifecycle? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        "plugins.flutter.io/mapbox_maps",
        MapboxMapFactory(
          flutterPluginBinding.binaryMessenger,
          flutterPluginBinding.flutterAssets,
          object : LifecycleProvider {
            override fun getLifecycle(): Lifecycle? {
              return lifecycle
            }
          }
        )
      )
    setupStaticChannels(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger, flutterPluginBinding.flutterAssets)
  }

  private fun setupStaticChannels(context: Context, binaryMessenger: BinaryMessenger, flutterAssets: FlutterAssets) {
    val optionsController = MapboxOptionsController(flutterAssets)
    val snapshotterInstanceManager = SnapshotterInstanceManager(context, binaryMessenger)
    val offlineMapInstanceManager = OfflineMapInstanceManager(context, binaryMessenger)
    val offlineSwitch = OfflineSwitch()
    // static options handling should be setup upon attachment,
    // as options can before configured before the map view is setup
    _MapboxMapsOptions.setUp(binaryMessenger, optionsController)
    _MapboxOptions.setUp(binaryMessenger, optionsController)
    _SnapshotterInstanceManager.setUp(binaryMessenger, snapshotterInstanceManager)
    _OfflineMapInstanceManager.setUp(binaryMessenger, offlineMapInstanceManager)
    _TileStoreInstanceManager.setUp(binaryMessenger, offlineMapInstanceManager)
    _OfflineSwitch.setUp(binaryMessenger, offlineSwitch)
    LoggingController.setup(binaryMessenger)
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