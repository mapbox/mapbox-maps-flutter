// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.indoorselector.generated.IndoorSelectorSettingsInterface

fun IndoorSelectorSettingsInterface.applyFromFLT(settings: IndoorSelectorSettings, context: Context) {
  updateSettings {
    settings.enabled?.let { this.enabled = it }
    settings.position?.let { this.position = it.toPosition() }
    settings.marginLeft?.let { this.marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { this.marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { this.marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { this.marginBottom = it.toDevicePixels(context) }
  }
}

fun IndoorSelectorSettingsInterface.toFLT(context: Context) = IndoorSelectorSettings(
  enabled = enabled,
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
)

// End of generated file.