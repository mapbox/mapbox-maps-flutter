// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.gestures.generated.GesturesSettingsInterface

fun GesturesSettingsInterface.applyFromFLT(settings: GesturesSettings, context: Context) {
  updateSettings {
    settings.rotateEnabled?.let { this.rotateEnabled = it }
    settings.pinchToZoomEnabled?.let { this.pinchToZoomEnabled = it }
    settings.scrollEnabled?.let { this.scrollEnabled = it }
    settings.simultaneousRotateAndPinchToZoomEnabled?.let { this.simultaneousRotateAndPinchToZoomEnabled = it }
    settings.pitchEnabled?.let { this.pitchEnabled = it }
    settings.scrollMode?.let {
      this.scrollMode = com.mapbox.maps.plugin.ScrollMode.values()[it.ordinal]
    }
    settings.doubleTapToZoomInEnabled?.let { this.doubleTapToZoomInEnabled = it }
    settings.doubleTouchToZoomOutEnabled?.let { this.doubleTouchToZoomOutEnabled = it }
    settings.quickZoomEnabled?.let { this.quickZoomEnabled = it }
    settings.focalPoint?.let { this.focalPoint = ScreenCoordinate(it.x.toDevicePixels(context).toDouble(), it.y.toDevicePixels(context).toDouble()) }
    settings.pinchToZoomDecelerationEnabled?.let { this.pinchToZoomDecelerationEnabled = it }
    settings.rotateDecelerationEnabled?.let { this.rotateDecelerationEnabled = it }
    settings.scrollDecelerationEnabled?.let { this.scrollDecelerationEnabled = it }
    settings.increaseRotateThresholdWhenPinchingToZoom?.let { this.increaseRotateThresholdWhenPinchingToZoom = it }
    settings.increasePinchToZoomThresholdWhenRotating?.let { this.increasePinchToZoomThresholdWhenRotating = it }
    settings.zoomAnimationAmount?.let { this.zoomAnimationAmount = it.toFloat() }
    settings.pinchPanEnabled?.let { this.pinchScrollEnabled = it }
  }
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