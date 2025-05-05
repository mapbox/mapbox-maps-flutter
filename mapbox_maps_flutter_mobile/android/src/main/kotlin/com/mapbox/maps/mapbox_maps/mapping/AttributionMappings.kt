// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.attribution.generated.AttributionSettingsInterface

fun AttributionSettingsInterface.applyFromFLT(settings: AttributionSettings, context: Context) {
  updateSettings {
    settings.enabled?.let { this.enabled = it }
    settings.iconColor?.let { this.iconColor = it.toInt() }
    settings.position?.let { this.position = it.toPosition() }
    settings.marginLeft?.let { this.marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { this.marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { this.marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { this.marginBottom = it.toDevicePixels(context) }
    settings.clickable?.let { this.clickable = it }
  }
}

fun AttributionSettingsInterface.toFLT(context: Context) = AttributionSettings(
  enabled = enabled,
  iconColor = iconColor.toUInt().toLong(),
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
  clickable = clickable,
)

// End of generated file.