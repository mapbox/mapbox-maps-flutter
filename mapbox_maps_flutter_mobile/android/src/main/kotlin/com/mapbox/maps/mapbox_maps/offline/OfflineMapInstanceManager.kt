package com.mapbox.maps.mapbox_maps.offline

import android.content.Context
import com.mapbox.common.TileStore
import com.mapbox.maps.MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons.*
import io.flutter.plugin.common.BinaryMessenger

class OfflineMapInstanceManager(
  private val context: Context,
  private val messenger: BinaryMessenger,
) : _OfflineMapInstanceManager, _TileStoreInstanceManager {

  override fun setupOfflineManager(channelSuffix: String) {
    val offlineControler = OfflineController(context, messenger, channelSuffix)
    _OfflineManager.setUp(messenger, offlineControler, channelSuffix)
  }

  override fun tearDownOfflineManager(channelSuffix: String) {
    _OfflineManager.setUp(messenger, null, channelSuffix)
  }

  override fun setupTileStore(channelSuffix: String, filePath: String?) {
    val tileStore = filePath?.let { TileStore.create(it) } ?: TileStore.create()
    MapboxMapsOptions.tileStore = tileStore
    val tileStoreController = TileStoreController(context, messenger, channelSuffix, tileStore)
    _TileStore.setUp(messenger, tileStoreController, channelSuffix)
  }

  override fun tearDownTileStore(channelSuffix: String) {
    _TileStore.setUp(messenger, null, channelSuffix)
    MapboxMapsOptions.tileStore = null
  }
}