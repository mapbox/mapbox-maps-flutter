package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapboxMap
import com.mapbox.maps.plugin.animation.*

class AnimationController(private val mapboxMap: MapboxMap) : FLTMapboxMap._AnimationManager {
  var cancelable: Cancelable? = null
  override fun easeTo(
    cameraOptions: FLTMapboxMap.CameraOptions,
    mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.easeTo(
      cameraOptions.toCameraOptions(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun flyTo(
    cameraOptions: FLTMapboxMap.CameraOptions,
    mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.flyTo(
      cameraOptions.toCameraOptions(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun moveBy(
    screenCoordinate: FLTMapboxMap.ScreenCoordinate,
    mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.moveBy(
      screenCoordinate.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun rotateBy(
    first: FLTMapboxMap.ScreenCoordinate,
    second: FLTMapboxMap.ScreenCoordinate,
    mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.rotateBy(
      first.toScreenCoordinate(),
      second.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun scaleBy(
    amount: Double,
    screenCoordinate: FLTMapboxMap.ScreenCoordinate?,
    mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.scaleBy(
      amount,
      screenCoordinate?.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun pitchBy(pitch: Double, mapAnimationOptions: FLTMapboxMap.MapAnimationOptions?) {
    cancelable = mapboxMap.pitchBy(pitch, mapAnimationOptions?.toMapAnimationOptions())
  }

  override fun cancelCameraAnimation() {
    cancelable?.cancel()
  }
}