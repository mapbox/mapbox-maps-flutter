// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toFLTScreenCoordinate
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.ScrollMode
import com.mapbox.maps.plugin.gestures.generated.GesturesSettingsInterface

fun GesturesSettingsInterface.applyFromFLT(settings: FLTSettings.GesturesSettings, context: Context) {
  settings.rotateEnabled?.let { rotateEnabled = it }
  settings.pinchToZoomEnabled?.let { pinchToZoomEnabled = it }
  settings.scrollEnabled?.let { scrollEnabled = it }
  settings.simultaneousRotateAndPinchToZoomEnabled?.let { simultaneousRotateAndPinchToZoomEnabled = it }
  settings.pitchEnabled?.let { pitchEnabled = it }
  settings.scrollMode?.let {
    scrollMode = ScrollMode.values()[it.ordinal]
  }
  settings.doubleTapToZoomInEnabled?.let { doubleTapToZoomInEnabled = it }
  settings.doubleTouchToZoomOutEnabled?.let { doubleTouchToZoomOutEnabled = it }
  settings.quickZoomEnabled?.let { quickZoomEnabled = it }
  settings.focalPoint?.let { focalPoint = ScreenCoordinate(it.x.toDevicePixels(context).toDouble(), it.y.toDevicePixels(context).toDouble()) }
  settings.pinchToZoomDecelerationEnabled?.let { pinchToZoomDecelerationEnabled = it }
  settings.rotateDecelerationEnabled?.let { rotateDecelerationEnabled = it }
  settings.scrollDecelerationEnabled?.let { scrollDecelerationEnabled = it }
  settings.increaseRotateThresholdWhenPinchingToZoom?.let { increaseRotateThresholdWhenPinchingToZoom = it }
  settings.increasePinchToZoomThresholdWhenRotating?.let { increasePinchToZoomThresholdWhenRotating = it }
  settings.zoomAnimationAmount?.let { zoomAnimationAmount = it.toFloat() }
  settings.pinchPanEnabled?.let { pinchScrollEnabled = it }
}

fun GesturesSettingsInterface.toFLT(context: Context) = FLTSettings.GesturesSettings.Builder().let { settings ->
  settings.setRotateEnabled(rotateEnabled)
  settings.setPinchToZoomEnabled(pinchToZoomEnabled)
  settings.setScrollEnabled(scrollEnabled)
  settings.setSimultaneousRotateAndPinchToZoomEnabled(simultaneousRotateAndPinchToZoomEnabled)
  settings.setPitchEnabled(pitchEnabled)
  settings.setScrollMode(FLTSettings.ScrollMode.values()[scrollMode.ordinal])
  settings.setDoubleTapToZoomInEnabled(doubleTapToZoomInEnabled)
  settings.setDoubleTouchToZoomOutEnabled(doubleTouchToZoomOutEnabled)
  settings.setQuickZoomEnabled(quickZoomEnabled)
  focalPoint?.let {
    settings.setFocalPoint(
      FLTSettings.ScreenCoordinate.Builder()
        .setX(it.x.toLogicalPixels(context))
        .setY(it.y.toLogicalPixels(context))
        .build()
    )
  }
  settings.setPinchToZoomDecelerationEnabled(pinchToZoomDecelerationEnabled)
  settings.setRotateDecelerationEnabled(rotateDecelerationEnabled)
  settings.setScrollDecelerationEnabled(scrollDecelerationEnabled)
  settings.setIncreaseRotateThresholdWhenPinchingToZoom(increaseRotateThresholdWhenPinchingToZoom)
  settings.setIncreasePinchToZoomThresholdWhenRotating(increasePinchToZoomThresholdWhenRotating)
  settings.setZoomAnimationAmount(zoomAnimationAmount.toDouble())
  settings.setPinchPanEnabled(pinchScrollEnabled)
  settings.build()
}

// End of generated file.