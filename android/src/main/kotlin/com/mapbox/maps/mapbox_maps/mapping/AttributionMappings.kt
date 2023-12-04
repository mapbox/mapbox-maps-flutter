// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.attribution.generated.AttributionSettingsInterface
import java.io.ByteArrayOutputStream

fun AttributionSettingsInterface.applyFromFLT(settings: FLTSettings.AttributionSettings, context: Context) {
  settings.iconColor?.let { iconColor = it.toInt() }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
  settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
  settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
  settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
  settings.clickable?.let { clickable = it }
}

fun AttributionSettingsInterface.toFLT(context: Context) = FLTSettings.AttributionSettings.Builder().let { settings ->
  settings.setIconColor(iconColor.toUInt().toLong())
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toLogicalPixels(context))
  settings.setMarginTop(marginTop.toLogicalPixels(context))
  settings.setMarginRight(marginRight.toLogicalPixels(context))
  settings.setMarginBottom(marginBottom.toLogicalPixels(context))
  settings.setClickable(clickable)
  settings.build()
}

// End of generated file.
