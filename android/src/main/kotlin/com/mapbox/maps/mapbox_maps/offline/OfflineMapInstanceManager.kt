package com.mapbox.maps.mapbox_maps.offline

import android.content.Context
import com.mapbox.common.TileStore
import com.mapbox.maps.MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons._OfflineManager
import com.mapbox.maps.mapbox_maps.pigeons._OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._TileStore
import com.mapbox.maps.mapbox_maps.pigeons._TileStoreInstanceManager
import io.flutter.plugin.common.BinaryMessenger

class OfflineMapInstanceManager(
  private val context: Context,
  private val messenger: BinaryMessenger,
) : _OfflineMapInstanceManager, _TileStoreInstanceManager {

  private var proxies = HashMap<String, BinaryMessenger>()
  override fun setupOfflineManager(channelSuffix: String) {
    val proxy = messenger
    val offlineControler = OfflineController(context, channelSuffix, messenger)
    _OfflineManager.setUp(proxy, offlineControler, channelSuffix)
    proxies[channelSuffix] = proxy
  }

  override fun tearDownOfflineManager(channelSuffix: String) {
    val proxy = proxies[channelSuffix] ?: return
    _OfflineManager.setUp(proxy, null, channelSuffix)
  }

  override fun setupTileStore(channelSuffix: String, filePath: String?) {
    val proxy = messenger
    val tileStore = filePath?.let { TileStore.create(it) } ?: TileStore.create()
    MapboxMapsOptions.tileStore = tileStore
    val tileStoreController = TileStoreController(context, channelSuffix, messenger, tileStore)
    _TileStore.setUp(proxy, tileStoreController, channelSuffix)
    proxies[channelSuffix] = proxy
  }

  override fun tearDownTileStore(channelSuffix: String) {
    val proxy = proxies[channelSuffix] ?: return
    _TileStore.setUp(proxy, null, channelSuffix)
    MapboxMapsOptions.tileStore = null
  }
}