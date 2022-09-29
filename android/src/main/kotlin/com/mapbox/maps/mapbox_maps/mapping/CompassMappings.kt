// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.compass.generated.CompassSettingsInterface
import java.io.ByteArrayOutputStream

fun CompassSettingsInterface.applyFromFLT(settings: FLTSettings.CompassSettings, context: Context) {
  settings.enabled?.let { enabled = it }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toFloat() }
  settings.marginTop?.let { marginTop = it.toFloat() }
  settings.marginRight?.let { marginRight = it.toFloat() }
  settings.marginBottom?.let { marginBottom = it.toFloat() }
  settings.opacity?.let { opacity = it.toFloat() }
  settings.rotation?.let { rotation = it.toFloat() }
  settings.visibility?.let { visibility = it }
  settings.fadeWhenFacingNorth?.let { fadeWhenFacingNorth = it }
  settings.clickable?.let { clickable = it }
  settings.image?.let { image = BitmapDrawable(context.resources, BitmapFactory.decodeByteArray(it, 0, it.size)) }
}

fun CompassSettingsInterface.toFLT() = FLTSettings.CompassSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toDouble())
  settings.setMarginTop(marginTop.toDouble())
  settings.setMarginRight(marginRight.toDouble())
  settings.setMarginBottom(marginBottom.toDouble())
  settings.setOpacity(opacity.toDouble())
  settings.setRotation(rotation.toDouble())
  settings.setVisibility(visibility)
  settings.setFadeWhenFacingNorth(fadeWhenFacingNorth)
  settings.setClickable(clickable)
  settings.setImage(
    (image as? BitmapDrawable)?.let { drawable ->
      ByteArrayOutputStream().also { stream ->
        drawable.bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
      }.toByteArray()
    }
  )
  settings.build()
}

// End of generated file.