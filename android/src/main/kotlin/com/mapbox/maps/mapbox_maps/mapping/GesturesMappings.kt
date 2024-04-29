// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.gestures.generated.GesturesSettingsInterface

fun GesturesSettingsInterface.applyFromFLT(settings: GesturesSettings, context: Context) {
  settings.rotateEnabled?.let { rotateEnabled = it }
  settings.pinchToZoomEnabled?.let { pinchToZoomEnabled = it }
  settings.scrollEnabled?.let { scrollEnabled = it }
  settings.simultaneousRotateAndPinchToZoomEnabled?.let { simultaneousRotateAndPinchToZoomEnabled = it }
  settings.pitchEnabled?.let { pitchEnabled = it }
  settings.scrollMode?.let {
    scrollMode = com.mapbox.maps.plugin.ScrollMode.values()[it.ordinal]
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

fun GesturesSettingsInterface.toFLT(context: Context) = GesturesSettings(
  rotateEnabled = rotateEnabled,
  pinchToZoomEnabled = pinchToZoomEnabled,
  scrollEnabled = scrollEnabled,
  simultaneousRotateAndPinchToZoomEnabled = simultaneousRotateAndPinchToZoomEnabled,
  pitchEnabled = pitchEnabled,
  scrollMode = ScrollMode.values()[scrollMode.ordinal],
  doubleTapToZoomInEnabled = doubleTapToZoomInEnabled,
  doubleTouchToZoomOutEnabled = doubleTouchToZoomOutEnabled,
  quickZoomEnabled = quickZoomEnabled,
  focalPoint = focalPoint?.let {
    ScreenCoordinate(x = it.x.toLogicalPixels(context), y = it.y.toLogicalPixels(context))
  },
  pinchToZoomDecelerationEnabled = pinchToZoomDecelerationEnabled,
  rotateDecelerationEnabled = rotateDecelerationEnabled,
  scrollDecelerationEnabled = scrollDecelerationEnabled,
  increaseRotateThresholdWhenPinchingToZoom = increaseRotateThresholdWhenPinchingToZoom,
  increasePinchToZoomThresholdWhenRotating = increasePinchToZoomThresholdWhenRotating,
  zoomAnimationAmount = zoomAnimationAmount.toDouble(),
  pinchPanEnabled = pinchScrollEnabled,
)

// End of generated file.