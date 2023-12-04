package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.common.Cancelable
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.animation.*

class AnimationController(private val mapboxMap: MapboxMap, private val context: Context) : FLTMapInterfaces._AnimationManager {
  var cancelable: Cancelable? = null
  override fun easeTo(
    cameraOptions: FLTMapInterfaces.CameraOptions,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.easeTo(
      cameraOptions.toCameraOptions(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun flyTo(
    cameraOptions: FLTMapInterfaces.CameraOptions,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.flyTo(
      cameraOptions.toCameraOptions(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun moveBy(
    screenCoordinate: FLTMapInterfaces.ScreenCoordinate,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.moveBy(
      screenCoordinate.toScreenCoordinate(context),
      mapAnimationOptions?.toMapAnimationOptions()
    )
  }

  override fun rotateBy(
    first: FLTMapInterfaces.ScreenCoordinate,
    second: FLTMapInterfaces.ScreenCoordinate,
    mapAnimationOptions: FLTMapInterfaces.MapAnimationOptions?
  ) {
    cancelable = mapboxMap.rotateBy(
      first.toScreenCoordinate(context),
      second.toScreenCoordinate(context),
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
      screenCoordinate?.toScreenCoordinate(context),
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