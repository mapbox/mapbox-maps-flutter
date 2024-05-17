package com.mapbox.maps.mapbox_maps.offline

import android.annotation.SuppressLint
import android.content.Context
import com.mapbox.maps.mapbox_maps.ProxyBinaryMessenger
import com.mapbox.maps.mapbox_maps.pigeons._OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._OfflineManager
import io.flutter.plugin.common.BinaryMessenger

class OfflineMapInstanceManager(
  private val context: Context,
  private val messenger: BinaryMessenger,
) : _OfflineMapInstanceManager {

  private  var proxies = HashMap<String, ProxyBinaryMessenger>()
  override fun setupOfflineManager(channelSuffix: String) {
    val proxy = ProxyBinaryMessenger(messenger, channelSuffix)
    val offlineControler = OfflineController(messenger)
    _OfflineManager.setUp(proxy, offlineControler)
    proxies[channelSuffix] = proxy
  }

  override fun tearDownOfflineManager(channelSuffix: String) {
    val proxy = proxies[channelSuffix] ?: return
    _OfflineManager.setUp(proxy, null)
  }
}