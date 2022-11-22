package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.animation.*

class AnimationController(private val mapboxMap: MapboxMap) : FLTMapInterfaces._AnimationManager {
  var cancelable: Cancelable? = null
  override fun easeTo(
    cameraOptions: FLTMapInterfaces.CameraOptions,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.easeTo(
      cameraOptions.toCameraOptions(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun flyTo(
    cameraOptions: FLTMapInterfaces.CameraOptions,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.flyTo(
      cameraOptions.toCameraOptions(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun moveBy(
    screenCoordinate: FLTMapInterfaces.ScreenCoordinate,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.moveBy(
      screenCoordinate.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun rotateBy(
    first: FLTMapInterfaces.ScreenCoordinate,
    second: FLTMapInterfaces.ScreenCoordinate,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.rotateBy(
      first.toScreenCoordinate(),
      second.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun scaleBy(
    amount: Double,
    screenCoordinate: FLTMapInterfaces.ScreenCoordinate?,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.scaleBy(
      amount,
      screenCoordinate?.toScreenCoordinate(),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun pitchBy(pitch: Double, mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?) {
    cancelable = mapboxMap.pitchBy(pitch, mapAnimationOptions?.toMapAnimationOptions())
  }

  override fun cancelCameraAnimation() {
    cancelable?.cancel()
  }
}