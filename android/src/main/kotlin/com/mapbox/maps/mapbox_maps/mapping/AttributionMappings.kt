// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.attribution.generated.AttributionSettingsInterface

fun AttributionSettingsInterface.applyFromFLT(settings: AttributionSettings, context: Context) {
  settings.iconColor?.let { iconColor = it.toInt() }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
  settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
  settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
  settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
  settings.clickable?.let { clickable = it }
}

fun AttributionSettingsInterface.toFLT(context: Context) = AttributionSettings(
  iconColor = iconColor.toUInt().toLong(),
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
  clickable = clickable,
)

// End of generated file.