// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.ImageHolder
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.compass.generated.CompassSettingsInterface
import java.io.ByteArrayOutputStream

fun CompassSettingsInterface.applyFromFLT(settings: FLTSettings.CompassSettings, context: Context) {
  settings.enabled?.let { enabled = it }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
  settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
  settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
  settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
  settings.opacity?.let { opacity = it.toFloat() }
  settings.rotation?.let { rotation = it.toFloat() }
  settings.visibility?.let { visibility = it }
  settings.fadeWhenFacingNorth?.let { fadeWhenFacingNorth = it }
  settings.clickable?.let { clickable = it }
  settings.image?.let { image = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
}

fun CompassSettingsInterface.toFLT(context: Context) = FLTSettings.CompassSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toLogicalPixels(context))
  settings.setMarginTop(marginTop.toLogicalPixels(context))
  settings.setMarginRight(marginRight.toLogicalPixels(context))
  settings.setMarginBottom(marginBottom.toLogicalPixels(context))
  settings.setOpacity(opacity.toDouble())
  settings.setRotation(rotation.toDouble())
  settings.setVisibility(visibility)
  settings.setFadeWhenFacingNorth(fadeWhenFacingNorth)
  settings.setClickable(clickable)
  settings.setImage(
    image?.bitmap?.let { bitmap ->
      ByteArrayOutputStream().also { stream ->
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
      }.toByteArray()
    }
  )
  settings.build()
}

// End of generated file.