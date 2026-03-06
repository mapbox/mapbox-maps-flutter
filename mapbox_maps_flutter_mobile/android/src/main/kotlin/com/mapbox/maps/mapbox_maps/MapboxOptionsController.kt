package com.mapbox.maps.mapbox_maps

import com.mapbox.bindgen.Value
import com.mapbox.common.MapboxCommonSettings
import com.mapbox.common.MapboxOptions
import com.mapbox.common.SettingsServiceFactory
import com.mapbox.common.SettingsServiceStorageType
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons.*
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets

class MapboxOptionsController(
  private val flutterAssets: FlutterAssets
) : _MapboxMapsOptions, _MapboxOptions {
  private val settingsService = SettingsServiceFactory.getInstance(SettingsServiceStorageType.PERSISTENT)

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

  override fun getFlutterAssetPath(flutterAssetUri: String?): String? {
    return flutterAssetUri?.replace("""^asset://(.+)""".toRegex(), "asset://${flutterAssets.getAssetFilePathBySubpath("$1")}")
  }

  override fun setAssetPath(path: String) {
    // ignored on Android
  }

  override fun getTileStoreUsageMode(): TileStoreUsageMode {
    return MapboxMapsOptions.tileStoreUsageMode.toFLTTileStoreUsageMode()
  }

  override fun setTileStoreUsageMode(mode: TileStoreUsageMode) {
    MapboxMapsOptions.tileStoreUsageMode = mode.toTileStoreUsageMode()
  }

  override fun getWorldview(): String? {
    val result = settingsService.get(MapboxCommonSettings.WORLDVIEW)
    return result.value?.contents as? String
  }

  override fun setWorldview(worldview: String?) {
    if (worldview != null) {
      settingsService.set(MapboxCommonSettings.WORLDVIEW, Value.valueOf(worldview))
    } else {
      settingsService.erase(MapboxCommonSettings.WORLDVIEW)
    }
  }

  override fun getLanguage(): String? {
    val result = settingsService.get(MapboxCommonSettings.LANGUAGE)
    return result.value?.contents as? String
  }

  override fun setLanguage(language: String?) {
    if (language != null) {
      settingsService.set(MapboxCommonSettings.LANGUAGE, Value.valueOf(language))
    } else {
      settingsService.erase(MapboxCommonSettings.LANGUAGE)
    }
  }

  override fun clearData(callback: (Result<Unit>) -> Unit) {
    MapboxMap.clearData {
      it.handleResult(callback)
    }
  }
}