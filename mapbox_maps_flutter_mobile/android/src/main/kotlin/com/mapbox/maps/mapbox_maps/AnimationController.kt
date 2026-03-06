package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.common.Cancelable
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.animation.easeTo
import com.mapbox.maps.plugin.animation.flyTo
import com.mapbox.maps.plugin.animation.moveBy
import com.mapbox.maps.plugin.animation.pitchBy
import com.mapbox.maps.plugin.animation.rotateBy
import com.mapbox.maps.plugin.animation.scaleBy

class AnimationController(private val mapboxMap: MapboxMap, private val context: Context) : _AnimationManager {
  var cancelable: Cancelable? = null
  override fun easeTo(
    cameraOptions: CameraOptions,
    mapAnimationOptions: MapAnimationOptions?
  ) {
    cancelable = mapboxMap.easeTo(
      cameraOptions.toCameraOptions(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun flyTo(
    cameraOptions: CameraOptions,
    mapAnimationOptions: MapAnimationOptions?
  ) {
    cancelable = mapboxMap.flyTo(
      cameraOptions.toCameraOptions(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun moveBy(
    screenCoordinate: ScreenCoordinate,
    mapAnimationOptions: MapAnimationOptions?
  ) {
    cancelable = mapboxMap.moveBy(
      screenCoordinate.toScreenCoordinate(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun rotateBy(
    first: ScreenCoordinate,
    second: ScreenCoordinate,
    mapAnimationOptions: MapAnimationOptions?
  ) {
    cancelable = mapboxMap.rotateBy(
      first.toScreenCoordinate(context),
      second.toScreenCoordinate(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun scaleBy(
    amount: Double,
    screenCoordinate: ScreenCoordinate?,
    mapAnimationOptions: MapAnimationOptions?
  ) {
    cancelable = mapboxMap.scaleBy(
      amount,
      screenCoordinate?.toScreenCoordinate(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun pitchBy(pitch: Double, mapAnimationOptions: MapAnimationOptions?) {
    cancelable = mapboxMap.pitchBy(pitch, mapAnimationOptions?.toMapAnimationOptions())
  }

  override fun cancelCameraAnimation() {
    cancelable?.cancel()
  }
}