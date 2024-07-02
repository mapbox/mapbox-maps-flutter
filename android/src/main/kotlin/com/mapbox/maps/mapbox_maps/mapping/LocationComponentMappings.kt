// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.ImageHolder
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTModelScaleMode
import com.mapbox.maps.mapbox_maps.toModelScaleMode
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.locationcomponent.generated.LocationComponentSettingsInterface
import java.io.ByteArrayOutputStream

fun LocationComponentSettingsInterface.applyFromFLT(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Boolean, context: Context) {
  updateSettings {
    settings.enabled?.let { this.enabled = it }
    settings.pulsingEnabled?.let { this.pulsingEnabled = it }
    settings.pulsingColor?.let { this.pulsingColor = it.toInt() }
    settings.pulsingMaxRadius?.let { this.pulsingMaxRadius = it.toFloat() }
    settings.showAccuracyRing?.let { this.showAccuracyRing = it }
    settings.accuracyRingColor?.let { this.accuracyRingColor = it.toInt() }
    settings.accuracyRingBorderColor?.let { this.accuracyRingBorderColor = it.toInt() }
    settings.layerAbove?.let { this.layerAbove = it }
    settings.layerBelow?.let { this.layerBelow = it }
    settings.puckBearingEnabled?.let { this.puckBearingEnabled = it }
    settings.puckBearing?.let {
      this.puckBearing = com.mapbox.maps.plugin.PuckBearing.values()[it.ordinal]
    }
    settings.slot?.let { this.slot = it }
    settings.locationPuck?.let {
      val puck2D = it.locationPuck2D
      val puck3D = it.locationPuck3D
      this.locationPuck = if (puck3D != null) {
        com.mapbox.maps.plugin.LocationPuck3D(
          puck3D.modelUri!!
        ).apply {
          puck3D.modelUri?.let { this.modelUri = it }
          puck3D.position?.let { this.position = it.mapNotNull { it?.toFloat() } }
          puck3D.modelOpacity?.let { this.modelOpacity = it.toFloat() }
          puck3D.modelScale?.let { this.modelScale = it.mapNotNull { it?.toFloat() } }
          puck3D.modelScaleExpression?.let { this.modelScaleExpression = it }
          puck3D.modelTranslation?.let { this.modelTranslation = it.mapNotNull { it?.toFloat() } }
          puck3D.modelRotation?.let { this.modelRotation = it.mapNotNull { it?.toFloat() } }
          puck3D.modelCastShadows?.let { this.modelCastShadows = it }
          puck3D.modelReceiveShadows?.let { this.modelReceiveShadows = it }
          puck3D.modelScaleMode?.let { this.modelScaleMode = it.toModelScaleMode() }
          puck3D.modelEmissiveStrength?.let { this.modelEmissiveStrength = it.toFloat() }
          puck3D.modelEmissiveStrengthExpression?.let { this.modelEmissiveStrengthExpression = it }
        }
      } else {
        (if (useDefaultPuck2DIfNeeded) createDefault2DPuck(withBearing = settings.puckBearingEnabled == true) else com.mapbox.maps.plugin.LocationPuck2D())
          .apply {
            puck2D?.topImage?.let { this.topImage = if (it.isNotEmpty()) ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) else null }
            puck2D?.bearingImage?.let { this.bearingImage = if (it.isNotEmpty()) ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) else null }
            puck2D?.shadowImage?.let { this.shadowImage = if (it.isNotEmpty()) ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) else null }
            puck2D?.scaleExpression?.let { this.scaleExpression = it }
            puck2D?.opacity?.let { this.opacity = it.toFloat() }
          }
      }
    }
  }
}

fun LocationComponentSettingsInterface.toFLT(context: Context) = LocationComponentSettings(
  enabled = enabled,
  pulsingEnabled = pulsingEnabled,
  pulsingColor = pulsingColor.toUInt().toLong(),
  pulsingMaxRadius = pulsingMaxRadius.toDouble(),
  showAccuracyRing = showAccuracyRing,
  accuracyRingColor = accuracyRingColor.toUInt().toLong(),
  accuracyRingBorderColor = accuracyRingBorderColor.toUInt().toLong(),
  layerAbove = layerAbove,
  layerBelow = layerBelow,
  puckBearingEnabled = puckBearingEnabled,
  puckBearing = PuckBearing.values()[puckBearing.ordinal],
  slot = slot,
  locationPuck = LocationPuck(
    locationPuck2D = (locationPuck as? com.mapbox.maps.plugin.LocationPuck2D)?.let { puck2D ->
      LocationPuck2D(
        topImage = puck2D.topImage?.bitmap?.let { bitmap ->
          ByteArrayOutputStream().also { stream ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
          }.toByteArray()
        },
        bearingImage = puck2D.bearingImage?.bitmap?.let { bitmap ->
          ByteArrayOutputStream().also { stream ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
          }.toByteArray()
        },
        shadowImage = puck2D.shadowImage?.bitmap?.let { bitmap ->
          ByteArrayOutputStream().also { stream ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
          }.toByteArray()
        },
        scaleExpression = puck2D.scaleExpression,
        opacity = puck2D.opacity.toDouble(),
      )
    },
    locationPuck3D = (locationPuck as? com.mapbox.maps.plugin.LocationPuck3D)?.let { puck3D ->
      LocationPuck3D(
        modelUri = puck3D.modelUri,
        position = puck3D.position.map { it.toDouble() },
        modelOpacity = puck3D.modelOpacity.toDouble(),
        modelScale = puck3D.modelScale.map { it.toDouble() },
        modelScaleExpression = puck3D.modelScaleExpression,
        modelTranslation = puck3D.modelTranslation.map { it.toDouble() },
        modelRotation = puck3D.modelRotation.map { it.toDouble() },
        modelCastShadows = puck3D.modelCastShadows,
        modelReceiveShadows = puck3D.modelReceiveShadows,
        modelScaleMode = puck3D.modelScaleMode.toFLTModelScaleMode(),
        modelEmissiveStrength = puck3D.modelEmissiveStrength.toDouble(),
        modelEmissiveStrengthExpression = puck3D.modelEmissiveStrengthExpression,
      )
    }
  )
)

// End of generated file.