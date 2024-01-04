// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.ImageHolder
import com.mapbox.maps.mapbox_maps.toFLTModelScaleMode
import com.mapbox.maps.mapbox_maps.toModelScaleMode
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.LocationPuck3D
import com.mapbox.maps.plugin.PuckBearing
import com.mapbox.maps.plugin.locationcomponent.generated.LocationComponentSettingsInterface
import java.io.ByteArrayOutputStream

fun LocationComponentSettingsInterface.applyFromFLT(settings: FLTSettings.LocationComponentSettings, context: Context) {
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
  settings.puckBearing?.let {
    puckBearing = PuckBearing.values()[it.ordinal]
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
        puck3D.modelCastShadows?.let { modelCastShadows = it }
        puck3D.modelReceiveShadows?.let { modelReceiveShadows = it }
        puck3D.modelScaleMode?.let { modelScaleMode = it.toModelScaleMode() }
        puck3D.modelEmissiveStrength?.let { modelEmissiveStrength = it.toFloat() }
        puck3D.modelEmissiveStrengthExpression?.let { modelEmissiveStrengthExpression = it }
      }
    } else {
      LocationPuck2D().apply {
        puck2D?.topImage?.let { topImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.bearingImage?.let { bearingImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.shadowImage?.let { shadowImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.scaleExpression?.let { scaleExpression = it }
        puck2D?.opacity?.let { opacity = it.toFloat() }
      }
    }
  }
}

fun LocationComponentSettingsInterface.toFLT(context: Context) = FLTSettings.LocationComponentSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPulsingEnabled(pulsingEnabled)
  settings.setPulsingColor(pulsingColor.toUInt().toLong())
  settings.setPulsingMaxRadius(pulsingMaxRadius.toDouble())
  settings.setShowAccuracyRing(showAccuracyRing)
  settings.setAccuracyRingColor(accuracyRingColor.toUInt().toLong())
  settings.setAccuracyRingBorderColor(accuracyRingBorderColor.toUInt().toLong())
  settings.setLayerAbove(layerAbove)
  settings.setLayerBelow(layerBelow)
  settings.setPuckBearingEnabled(puckBearingEnabled)
  settings.setPuckBearing(FLTSettings.PuckBearing.values()[puckBearing.ordinal])
  settings.setLocationPuck(
    FLTSettings.LocationPuck().also {
      (locationPuck as? LocationPuck2D)?.let { puck2D ->
        it.locationPuck2D = FLTSettings.LocationPuck2D().also {
          it.topImage = puck2D.topImage?.bitmap?.let { bitmap ->
            ByteArrayOutputStream().also { stream ->
              bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.bearingImage = puck2D.bearingImage?.bitmap?.let { bitmap ->
            ByteArrayOutputStream().also { stream ->
              bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.shadowImage = puck2D.shadowImage?.bitmap?.let { bitmap ->
            ByteArrayOutputStream().also { stream ->
              bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            }.toByteArray()
          }
          it.scaleExpression = puck2D.scaleExpression
          it.opacity = puck2D.opacity.toDouble()
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
          it.modelCastShadows = puck3D.modelCastShadows
          it.modelReceiveShadows = puck3D.modelReceiveShadows
          it.modelScaleMode = puck3D.modelScaleMode.toFLTModelScaleMode()
          it.modelEmissiveStrength = puck3D.modelEmissiveStrength.toDouble()
          it.modelEmissiveStrengthExpression = puck3D.modelEmissiveStrengthExpression
        }
      }
    }
  )
  settings.build()
}

// End of generated file.