package com.mapbox.maps.mapbox_maps.snapshot

import android.annotation.SuppressLint
import android.content.Context
import com.mapbox.maps.MapboxStyleManager
import com.mapbox.maps.Snapshotter
import com.mapbox.maps.mapbox_maps.MapboxEventHandler
import com.mapbox.maps.mapbox_maps.ProxyBinaryMessenger
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

  private var proxyMessengers = HashMap<String, ProxyBinaryMessenger>()

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
    val proxyBinaryMessenger = ProxyBinaryMessenger(messenger, suffix)
    val styleManager: com.mapbox.maps.StyleManager = snapshotter.styleManager() // TODO: expose this on Android
    val eventHandler = MapboxEventHandler(styleManager, proxyBinaryMessenger, eventTypes.map { it.toInt() })
    val snapshotterController = SnapshotterController(context, snapshotter, eventHandler)
    val mapboxStyleManager = MapboxStyleManager(
      styleManager,
      options.pixelRatio.toFloat(),
      mapLoadingErrorDelegate = {}
    )
    val snapshotterStyleController = StyleController(context, mapboxStyleManager)

    _SnapshotterMessenger.setUp(proxyBinaryMessenger, snapshotterController)
    StyleManager.setUp(proxyBinaryMessenger, snapshotterStyleController)

    proxyMessengers[suffix] = proxyBinaryMessenger
  }

  override fun tearDownSnapshotterForSuffix(suffix: String) {
    val proxyBinaryMessenger = proxyMessengers[suffix] ?: return

    _SnapshotterMessenger.setUp(proxyBinaryMessenger, null)
    StyleManager.setUp(proxyBinaryMessenger, null)
  }
}