package com.mapbox.maps.mapbox_maps

import com.mapbox.common.MapboxOptions
import com.mapbox.maps.MapboxMapsOptions
import com.mapbox.maps.pigeons.FLTMapInterfaces

class MapboxOptionsController : FLTMapInterfaces._MapboxMapsOptions, FLTMapInterfaces._MapboxOptions {
  override fun getAccessToken(): String {
    return MapboxOptions.accessToken
  }

  override fun setAccessToken(token: String) {
    MapboxOptions.accessToken = token
  }

  override fun getBaseUrl(): String {
    return MapboxMapsOptions.baseUrl
  }

  override fun setBaseUrl(url: String) {
    MapboxMapsOptions.baseUrl = url
  }

  override fun getDataPath(): String {
    return MapboxMapsOptions.dataPath
  }

  override fun setDataPath(path: String) {
    MapboxMapsOptions.dataPath = path
  }

  override fun getAssetPath(): String {
    return ""
  }

  override fun setAssetPath(path: String) {
    // ignored on Android
  }

  override fun getTileStoreUsageMode(): FLTMapInterfaces.TileStoreUsageMode {
    return MapboxMapsOptions.tileStoreUsageMode.toFLTTileStoreUsageMode()
  }

  override fun setTileStoreUsageMode(mode: FLTMapInterfaces.TileStoreUsageMode) {
    MapboxMapsOptions.tileStoreUsageMode = mode.toTileStoreUsageMode()
  }
}