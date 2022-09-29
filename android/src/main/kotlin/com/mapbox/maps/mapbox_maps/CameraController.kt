package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapboxMap
import com.mapbox.maps.plugin.animation.*

class CameraController(private val mapboxMap: MapboxMap) : FLTMapboxMap._CameraManager {
  override fun cameraForCoordinateBounds(
    bounds: FLTMapboxMap.CoordinateBounds,
    padding: FLTMapboxMap.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapboxMap.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinateBounds(
      bounds.toCoordinateBounds(),
      padding.toEdgeInsets(),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun cameraForCoordinates(
    coordinates: MutableList<MutableMap<String, Any>>,
    padding: FLTMapboxMap.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapboxMap.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      padding.toEdgeInsets(),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun cameraForCoordinates2(
    coordinates: MutableList<MutableMap<String, Any>>,
    camera: FLTMapboxMap.CameraOptions,
    box: FLTMapboxMap.ScreenBox
  ): FLTMapboxMap.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      camera.toCameraOptions(),
      box.toScreenBox()
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun cameraForGeometry(
    geometry: MutableMap<String, Any>,
    padding: FLTMapboxMap.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapboxMap.CameraOptions {
    val cameraOptions = mapboxMap.cameraForGeometry(
      geometry.toGeometry(),
      padding.toEdgeInsets(),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun coordinateBoundsForCamera(camera: FLTMapboxMap.CameraOptions): FLTMapboxMap.CoordinateBounds {
    val coordinateBounds = mapboxMap.coordinateBoundsForCamera(camera.toCameraOptions())
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsForCameraUnwrapped(camera: FLTMapboxMap.CameraOptions): FLTMapboxMap.CoordinateBounds {
    val coordinateBounds =
      mapboxMap.coordinateBoundsForCameraUnwrapped(camera.toCameraOptions())
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsZoomForCamera(camera: FLTMapboxMap.CameraOptions): FLTMapboxMap.CoordinateBoundsZoom {
    val coordinateBoundsZoom = mapboxMap.coordinateBoundsZoomForCamera(camera.toCameraOptions())
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun coordinateBoundsZoomForCameraUnwrapped(camera: FLTMapboxMap.CameraOptions): FLTMapboxMap.CoordinateBoundsZoom {
    val coordinateBoundsZoom =
      mapboxMap.coordinateBoundsZoomForCameraUnwrapped(camera.toCameraOptions())
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun pixelForCoordinate(coordinate: MutableMap<String, Any>): FLTMapboxMap.ScreenCoordinate {
    val screenCoordinate = mapboxMap.pixelForCoordinate(coordinate.toPoint())
    return screenCoordinate.toFLTScreenCoordinate()
  }

  override fun coordinateForPixel(pixel: FLTMapboxMap.ScreenCoordinate): MutableMap<String, Any> {
    val screenCoordinate = mapboxMap.coordinateForPixel(pixel.toScreenCoordinate())
    return screenCoordinate.toMap() as MutableMap<String, Any>
  }

  override fun pixelsForCoordinates(coordinates: MutableList<MutableMap<String, Any>>): MutableList<FLTMapboxMap.ScreenCoordinate> {
    val screenCoordinates = mapboxMap.pixelsForCoordinates(coordinates.map { it.toPoint() })
    return screenCoordinates.map { it.toFLTScreenCoordinate() }.toMutableList()
  }

  override fun coordinatesForPixels(pixels: MutableList<FLTMapboxMap.ScreenCoordinate>): MutableList<MutableMap<String, Any>> {
    val points = mapboxMap.coordinatesForPixels(pixels.map { it.toScreenCoordinate() })
    return points.map { it.toMap().toMutableMap() }.toMutableList()
  }

  override fun setCamera(cameraOptions: FLTMapboxMap.CameraOptions) {
    mapboxMap.setCamera(cameraOptions.toCameraOptions())
  }

  override fun getCameraState(): FLTMapboxMap.CameraState {
    return mapboxMap.cameraState.toCameraState()
  }

  override fun setBounds(options: FLTMapboxMap.CameraBoundsOptions) {
    mapboxMap.setBounds(options.toCameraBoundsOptions())
  }

  override fun getBounds(): FLTMapboxMap.CameraBounds {
    return mapboxMap.getBounds().toFLTCameraBounds()
  }

  override fun dragStart(point: FLTMapboxMap.ScreenCoordinate) {
    mapboxMap.dragStart(point.toScreenCoordinate())
  }

  override fun getDragCameraOptions(
    fromPoint: FLTMapboxMap.ScreenCoordinate,
    toPoint: FLTMapboxMap.ScreenCoordinate
  ): FLTMapboxMap.CameraOptions {
    return mapboxMap.getDragCameraOptions(
      fromPoint.toScreenCoordinate(),
      toPoint.toScreenCoordinate()
    ).toFLTCameraOptions()
  }

  override fun dragEnd() {
    mapboxMap.dragEnd()
  }
}