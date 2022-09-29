// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.LocationPuck3D
import com.mapbox.maps.plugin.PuckBearingSource
import com.mapbox.maps.plugin.locationcomponent.generated.LocationComponentSettingsInterface2
import java.io.ByteArrayOutputStream

fun LocationComponentSettingsInterface2.applyFromFLT(settings: FLTSettings.LocationComponentSettings, context: Context) {
  settings.enabled?.let { enabled = it }
  settings.pulsingEnabled?.let { pulsingEnabled = it }
  settings.pulsingColor?.let { pulsingColor = it.toInt() }
  settings.pulsingMaxRadius?.let { pulsingMaxRadius = it.toFloat() }
  settings.showAccuracyRing?.let { showAccuracyRing = it }
  settings.accuracyRingColor?.let { accuracyRingColor = it.toInt() }
  settings.accuracyRingBorderColor?.let { accuracyRingBorderColor = it.toInt() }
  settings.layerAbove?.let { layerAbove = it }
  settings.layerBelow?.let { layerBelow = it }
  settings.puckBearingEnabled?.let { puckBearingEnabled = it }
  settings.puckBearingSource?.let {
    puckBearingSource = PuckBearingSource.values()[it.ordinal]
  }
  settings.locationPuck?.let {
    val puck2D = it.locationPuck2D
    val puck3D = it.locationPuck3D
    locationPuck = if (puck3D != null) {
      LocationPuck3D(
        puck3D.modelUri!!
      ).apply {
        puck3D.modelUri?.let { modelUri = it }
        puck3D.position?.let { position = it.map { it.toFloat() } }
        puck3D.modelOpacity?.let { modelOpacity = it.toFloat() }
        puck3D.modelScale?.let { modelScale = it.map { it.toFloat() } }
        puck3D.modelScaleExpression?.let { modelScaleExpression = it }
        puck3D.modelTranslation?.let { modelTranslation = it.map { it.toFloat() } }
        puck3D.modelRotation?.let { modelRotation = it.map { it.toFloat() } }
      }
    } else {
      LocationPuck2D().apply {
        puck2D?.topImage?.let { topImage = BitmapDrawable(context.resources, BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.bearingImage?.let { bearingImage = BitmapDrawable(context.resources, BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.shadowImage?.let { shadowImage = BitmapDrawable(context.resources, BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.scaleExpression?.let { scaleExpression = it }
      }
    }
  }
}

fun LocationComponentSettingsInterface2.toFLT() = FLTSettings.LocationComponentSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPulsingEnabled(pulsingEnabled)
  settings.setPulsingColor(pulsingColor.toLong())
  settings.setPulsingMaxRadius(pulsingMaxRadius.toDouble())
  settings.setShowAccuracyRing(showAccuracyRing)
  settings.setAccuracyRingColor(accuracyRingColor.toLong())
  settings.setAccuracyRingBorderColor(accuracyRingBorderColor.toLong())
  settings.setLayerAbove(layerAbove)
  settings.setLayerBelow(layerBelow)
  settings.setPuckBearingEnabled(puckBearingEnabled)
  settings.setPuckBearingSource(FLTSettings.PuckBearingSource.values()[puckBearingSource.ordinal])
  settings.setLocationPuck(
    FLTSettings.LocationPuck().also {
      (locationPuck as? LocationPuck2D)?.let { puck2D ->
        it.locationPuck2D = FLTSettings.LocationPuck2D().also {
          it.topImage = (puck2D.topImage as? BitmapDrawable)?.let { drawable ->
            ByteArrayOutputStream().also { stream ->
              drawable.bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.bearingImage = (puck2D.bearingImage as? BitmapDrawable)?.let { drawable ->
            ByteArrayOutputStream().also { stream ->
              drawable.bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.shadowImage = (puck2D.shadowImage as? BitmapDrawable)?.let { drawable ->
            ByteArrayOutputStream().also { stream ->
              drawable.bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.scaleExpression = puck2D.scaleExpression
        }
      }
      (locationPuck as? LocationPuck3D)?.let { puck3D ->
        it.locationPuck3D = FLTSettings.LocationPuck3D().also {
          it.modelUri = puck3D.modelUri
          it.position = puck3D.position.map { it.toDouble() }
          it.modelOpacity = puck3D.modelOpacity.toDouble()
          it.modelScale = puck3D.modelScale.map { it.toDouble() }
          it.modelScaleExpression = puck3D.modelScaleExpression
          it.modelTranslation = puck3D.modelTranslation.map { it.toDouble() }
          it.modelRotation = puck3D.modelRotation.map { it.toDouble() }
        }
      }
    }
  )
  settings.build()
}

// End of generated file.