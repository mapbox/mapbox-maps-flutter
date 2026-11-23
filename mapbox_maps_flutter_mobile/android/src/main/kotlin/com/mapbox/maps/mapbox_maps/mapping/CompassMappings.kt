// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.ImageHolder
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.compass.generated.CompassSettingsInterface
import java.io.ByteArrayOutputStream

fun CompassSettingsInterface.applyFromFLT(settings: CompassSettings, context: Context) {
  updateSettings {
    settings.enabled?.let { this.enabled = it }
    settings.position?.let { this.position = it.toPosition() }
    settings.marginLeft?.let { this.marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { this.marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { this.marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { this.marginBottom = it.toDevicePixels(context) }
    settings.opacity?.let { this.opacity = it.toFloat() }
    settings.rotation?.let { this.rotation = it.toFloat() }
    settings.visibility?.let { this.visibility = it }
    settings.fadeWhenFacingNorth?.let { this.fadeWhenFacingNorth = it }
    settings.clickable?.let { this.clickable = it }
    settings.image?.let { this.image = if (it.isNotEmpty()) ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) else null }
  }
}

fun CompassSettingsInterface.toFLT(context: Context) = CompassSettings(
  enabled = enabled,
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
  opacity = opacity.toDouble(),
  rotation = rotation.toDouble(),
  visibility = visibility,
  fadeWhenFacingNorth = fadeWhenFacingNorth,
  clickable = clickable,
  image = image?.bitmap?.let { bitmap ->
    ByteArrayOutputStream().also { stream ->
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
    }.toByteArray()
  },
)

// End of generated file.