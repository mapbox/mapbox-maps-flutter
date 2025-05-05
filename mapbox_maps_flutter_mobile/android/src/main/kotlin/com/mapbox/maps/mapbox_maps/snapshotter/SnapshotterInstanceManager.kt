package com.mapbox.maps.mapbox_maps.snapshot

import android.annotation.SuppressLint
import android.content.Context
import com.mapbox.maps.MapboxStyleManager
import com.mapbox.maps.Snapshotter
import com.mapbox.maps.mapbox_maps.MapboxEventHandler
import com.mapbox.maps.mapbox_maps.StyleController
import com.mapbox.maps.mapbox_maps.pigeons.MapSnapshotOptions
import com.mapbox.maps.mapbox_maps.pigeons.StyleManager
import com.mapbox.maps.mapbox_maps.pigeons._SnapshotterInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._SnapshotterMessenger
import com.mapbox.maps.mapbox_maps.styleManager
import com.mapbox.maps.mapbox_maps.toSnapshotOptions
import com.mapbox.maps.mapbox_maps.toSnapshotOverlayOptions
import io.flutter.plugin.common.BinaryMessenger

class SnapshotterInstanceManager(
  private val context: Context,
  private val messenger: BinaryMessenger,
) : _SnapshotterInstanceManager {

  @SuppressLint("RestrictedApi")
  override fun setupSnapshotterForSuffix(
    suffix: String,
    eventTypes: List<Long>,
    options: MapSnapshotOptions
  ) {
    val snapshotter = Snapshotter(
      context,
      options = options.toSnapshotOptions(context),
      overlayOptions = options.toSnapshotOverlayOptions()
    )
    val styleManager: com.mapbox.maps.StyleManager = snapshotter.styleManager() // TODO: expose this on Android
    val eventHandler = MapboxEventHandler(styleManager, messenger, eventTypes.map { it }, suffix)
    val snapshotterController = SnapshotterController(context, snapshotter, eventHandler)
    val mapboxStyleManager = MapboxStyleManager(
      styleManager,
      options.pixelRatio.toFloat(),
      mapLoadingErrorDelegate = {}
    )
    val snapshotterStyleController = StyleController(context, mapboxStyleManager)

    _SnapshotterMessenger.setUp(messenger, snapshotterController, suffix)
    StyleManager.setUp(messenger, snapshotterStyleController, suffix)
  }

  override fun tearDownSnapshotterForSuffix(suffix: String) {
    _SnapshotterMessenger.setUp(messenger, null, suffix)
    StyleManager.setUp(messenger, null, suffix)
  }
}