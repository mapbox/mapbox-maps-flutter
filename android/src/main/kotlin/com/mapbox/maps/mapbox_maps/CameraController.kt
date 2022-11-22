package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.animation.*

class CameraController(private val mapboxMap: MapboxMap) : FLTMapInterfaces._CameraManager {
  override fun cameraForCoordinateBounds(
    bounds: FLTMapInterfaces.CoordinateBounds,
    padding: FLTMapInterfaces.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
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
    padding: FLTMapInterfaces.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      padding.toEdgeInsets(),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun cameraForCoordinatesCameraOptions(
    coordinates: MutableList<MutableMap<String, Any>>,
    camera: FLTMapInterfaces.CameraOptions,
    box: FLTMapInterfaces.ScreenBox
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      camera.toCameraOptions(),
      box.toScreenBox()
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun cameraForGeometry(
    geometry: MutableMap<String, Any>,
    padding: FLTMapInterfaces.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForGeometry(
      geometry.toGeometry(),
      padding.toEdgeInsets(),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions()
  }

  override fun coordinateBoundsForCamera(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBounds {
    val coordinateBounds = mapboxMap.coordinateBoundsForCamera(camera.toCameraOptions())
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsForCameraUnwrapped(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBounds {
    val coordinateBounds =
      mapboxMap.coordinateBoundsForCameraUnwrapped(camera.toCameraOptions())
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsZoomForCamera(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBoundsZoom {
    val coordinateBoundsZoom = mapboxMap.coordinateBoundsZoomForCamera(camera.toCameraOptions())
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun coordinateBoundsZoomForCameraUnwrapped(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBoundsZoom {
    val coordinateBoundsZoom =
      mapboxMap.coordinateBoundsZoomForCameraUnwrapped(camera.toCameraOptions())
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun pixelForCoordinate(coordinate: MutableMap<String, Any>): FLTMapInterfaces.ScreenCoordinate {
    val screenCoordinate = mapboxMap.pixelForCoordinate(coordinate.toPoint())
    return screenCoordinate.toFLTScreenCoordinate()
  }

  override fun coordinateForPixel(pixel: FLTMapInterfaces.ScreenCoordinate): MutableMap<String, Any> {
    val screenCoordinate = mapboxMap.coordinateForPixel(pixel.toScreenCoordinate())
    return screenCoordinate.toMap() as MutableMap<String, Any>
  }

  override fun pixelsForCoordinates(coordinates: MutableList<MutableMap<String, Any>>): MutableList<FLTMapInterfaces.ScreenCoordinate> {
    val screenCoordinates = mapboxMap.pixelsForCoordinates(coordinates.map { it.toPoint() })
    return screenCoordinates.map { it.toFLTScreenCoordinate() }.toMutableList()
  }

  override fun coordinatesForPixels(pixels: MutableList<FLTMapInterfaces.ScreenCoordinate>): MutableList<MutableMap<String, Any>> {
    val points = mapboxMap.coordinatesForPixels(pixels.map { it.toScreenCoordinate() })
    return points.map { it.toMap().toMutableMap() }.toMutableList()
  }

  override fun setCamera(cameraOptions: FLTMapInterfaces.CameraOptions) {
    mapboxMap.setCamera(cameraOptions.toCameraOptions())
  }

  override fun getCameraState(): FLTMapInterfaces.CameraState {
    return mapboxMap.cameraState.toCameraState()
  }

  override fun setBounds(options: FLTMapInterfaces.CameraBoundsOptions) {
    mapboxMap.setBounds(options.toCameraBoundsOptions())
  }

  override fun getBounds(): FLTMapInterfaces.CameraBounds {
    return mapboxMap.getBounds().toFLTCameraBounds()
  }

  override fun dragStart(point: FLTMapInterfaces.ScreenCoordinate) {
    mapboxMap.dragStart(point.toScreenCoordinate())
  }

  override fun getDragCameraOptions(
    fromPoint: FLTMapInterfaces.ScreenCoordinate,
    toPoint: FLTMapInterfaces.ScreenCoordinate
  ): FLTMapInterfaces.CameraOptions {
    return mapboxMap.getDragCameraOptions(
      fromPoint.toScreenCoordinate(),
      toPoint.toScreenCoordinate()
    ).toFLTCameraOptions()
  }

  override fun dragEnd() {
    mapboxMap.dragEnd()
  }
}