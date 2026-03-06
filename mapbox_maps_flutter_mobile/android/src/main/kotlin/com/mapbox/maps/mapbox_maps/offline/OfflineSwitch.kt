package com.mapbox.maps.mapbox_maps.offline

import com.mapbox.maps.mapbox_maps.pigeons._OfflineSwitch

class OfflineSwitch : _OfflineSwitch {

  private val switcher = com.mapbox.common.OfflineSwitch.getInstance()

  override fun setMapboxStackConnected(connected: Boolean) {
    switcher.isMapboxStackConnected = connected
  }

  override fun isMapboxStackConnected(): Boolean {
    return switcher.isMapboxStackConnected
  }
}