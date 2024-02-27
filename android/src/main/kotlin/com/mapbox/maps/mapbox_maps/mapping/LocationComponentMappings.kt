// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.ImageHolder
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toFLTModelScaleMode
import com.mapbox.maps.mapbox_maps.toModelScaleMode
import com.mapbox.maps.plugin.locationcomponent.generated.LocationComponentSettingsInterface
import java.io.ByteArrayOutputStream

fun LocationComponentSettingsInterface.applyFromFLT(settings: LocationComponentSettings, context: Context) {
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
    puckBearing = com.mapbox.maps.plugin.PuckBearing.values()[it.ordinal]
  }
  settings.locationPuck?.let {
    val puck2D = it.locationPuck2D
    val puck3D = it.locationPuck3D
    locationPuck = if (puck3D != null) {
      com.mapbox.maps.plugin.LocationPuck3D(
        puck3D.modelUri!!
      ).apply {
        puck3D.modelUri?.let { modelUri = it }
        puck3D.position?.let { position = it.mapNotNull { it?.toFloat() } }
        puck3D.modelOpacity?.let { modelOpacity = it.toFloat() }
        puck3D.modelScale?.let { modelScale = it.mapNotNull { it?.toFloat() } }
        puck3D.modelScaleExpression?.let { modelScaleExpression = it }
        puck3D.modelTranslation?.let { modelTranslation = it.mapNotNull { it?.toFloat() } }
        puck3D.modelRotation?.let { modelRotation = it.mapNotNull { it?.toFloat() } }
        puck3D.modelCastShadows?.let { modelCastShadows = it }
        puck3D.modelReceiveShadows?.let { modelReceiveShadows = it }
        puck3D.modelScaleMode?.let { modelScaleMode = it.toModelScaleMode() }
        puck3D.modelEmissiveStrength?.let { modelEmissiveStrength = it.toFloat() }
        puck3D.modelEmissiveStrengthExpression?.let { modelEmissiveStrengthExpression = it }
      }
    } else {
      com.mapbox.maps.plugin.LocationPuck2D().apply {
        puck2D?.topImage?.let { topImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.bearingImage?.let { bearingImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.shadowImage?.let { shadowImage = ImageHolder.from(BitmapFactory.decodeByteArray(it, 0, it.size)) }
        puck2D?.scaleExpression?.let { scaleExpression = it }
        puck2D?.opacity?.let { opacity = it.toFloat() }
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