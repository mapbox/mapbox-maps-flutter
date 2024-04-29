// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.logo.generated.LogoSettingsInterface

fun LogoSettingsInterface.applyFromFLT(settings: LogoSettings, context: Context) {
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
  settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
  settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
  settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
}

fun LogoSettingsInterface.toFLT(context: Context) = LogoSettings(
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
)

// End of generated file.