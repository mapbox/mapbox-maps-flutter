package com.mapbox.maps.mapbox_maps.offline

import android.content.Context
import com.mapbox.common.TileStore
import com.mapbox.maps.MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.ProxyBinaryMessenger
import com.mapbox.maps.mapbox_maps.pigeons.*
import io.flutter.plugin.common.BinaryMessenger

class OfflineMapInstanceManager(
  private val context: Context,
  private val messenger: BinaryMessenger,
) : _OfflineMapInstanceManager, _TileStoreInstanceManager {

  private var proxies = HashMap<String, ProxyBinaryMessenger>()
  override fun setupOfflineManager(channelSuffix: String) {
    val proxy = ProxyBinaryMessenger(messenger, channelSuffix)
    val offlineControler = OfflineController(context, messenger)
    _OfflineManager.setUp(proxy, offlineControler)
    proxies["offline-manager/$channelSuffix"] = proxy
  }

  override fun tearDownOfflineManager(channelSuffix: String) {
    val proxy = proxies["offline-manager/$channelSuffix"] ?: return
    _OfflineManager.setUp(proxy, null)
  }

  override fun setupTileStore(channelSuffix: String, filePath: String?) {
    val proxy = ProxyBinaryMessenger(messenger, channelSuffix)
    val tileStore = filePath?.let { TileStore.create(it) } ?: TileStore.create()
    MapboxMapsOptions.tileStore = tileStore
    val tileStoreController = TileStoreController(context, messenger, tileStore)
    _TileStore.setUp(proxy, tileStoreController)
    proxies["tilestore/$channelSuffix"] = proxy
  }

  override fun tearDownTileStore(channelSuffix: String) {
    val proxy = proxies["tilestore/$channelSuffix"] ?: return
    _TileStore.setUp(proxy, null)
    MapboxMapsOptions.tileStore = null
  }
}