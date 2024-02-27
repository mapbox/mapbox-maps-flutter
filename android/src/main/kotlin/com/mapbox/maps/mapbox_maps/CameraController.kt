package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.animation.*

class CameraController(private val mapboxMap: MapboxMap, private val context: Context) : _CameraManager {
  override fun cameraForCoordinatesPadding(
    coordinates: List<Map<String?, Any?>?>,
    camera: CameraOptions,
    coordinatesPadding: MbxEdgeInsets?,
    maxZoom: Double?,
    offset: ScreenCoordinate?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it!!.toPoint() },
      camera.toCameraOptions(context),
      coordinatesPadding?.toEdgeInsets(context),
      maxZoom,
      offset?.toScreenCoordinate(context)
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinateBounds(
    bounds: CoordinateBounds,
    padding: MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?,
    maxZoom: Double?,
    offset: ScreenCoordinate?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinateBounds(
      bounds.toCoordinateBounds(),
      padding?.toEdgeInsets(context),
      bearing,
      pitch,
      maxZoom,
      offset?.toScreenCoordinate(context)
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinates(
    coordinates: List<Map<String?, Any?>?>,
    padding: MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it!!.toPoint() },
      padding?.toEdgeInsets(context),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinatesCameraOptions(
    coordinates: List<Map<String?, Any?>?>,
    camera: CameraOptions,
    box: ScreenBox
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it!!.toPoint() },
      camera.toCameraOptions(context),
      box.toScreenBox(context)
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForGeometry(
    geometry: Map<String?, Any?>,
    padding: MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForGeometry(
      geometry.toGeometry(),
      padding.toEdgeInsets(context),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun coordinateBoundsForCamera(camera: CameraOptions): CoordinateBounds {
    val coordinateBounds = mapboxMap.coordinateBoundsForCamera(camera.toCameraOptions(context))
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsForCameraUnwrapped(camera: CameraOptions): CoordinateBounds {
    val coordinateBounds =
      mapboxMap.coordinateBoundsForCameraUnwrapped(camera.toCameraOptions(context))
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsZoomForCamera(camera: CameraOptions): CoordinateBoundsZoom {
    val coordinateBoundsZoom = mapboxMap.coordinateBoundsZoomForCamera(camera.toCameraOptions(context))
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun coordinateBoundsZoomForCameraUnwrapped(camera: CameraOptions): CoordinateBoundsZoom {
    val coordinateBoundsZoom =
      mapboxMap.coordinateBoundsZoomForCameraUnwrapped(camera.toCameraOptions(context))
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun pixelForCoordinate(coordinate: Map<String?, Any?>): ScreenCoordinate {
    val screenCoordinate = mapboxMap.pixelForCoordinate(coordinate.toPoint())
    return screenCoordinate.toFLTScreenCoordinate(context)
  }

  override fun coordinateForPixel(pixel: ScreenCoordinate): Map<String?, Any?> {
    val screenCoordinate = mapboxMap.coordinateForPixel(pixel.toScreenCoordinate(context))
    return screenCoordinate.toMap() as Map<String?, Any?>
  }

  override fun pixelsForCoordinates(coordinates: List<Map<String?, Any?>?>): MutableList<ScreenCoordinate> {
    val screenCoordinates = mapboxMap.pixelsForCoordinates(coordinates.map { it!!.toPoint() })
    return screenCoordinates.map { it.toFLTScreenCoordinate(context) }.toMutableList()
  }

  override fun coordinatesForPixels(pixels: List<ScreenCoordinate?>): List<Map<String?, Any?>?> {
    val points = mapboxMap.coordinatesForPixels(pixels.map { it!!.toScreenCoordinate(context) })
    return points.map { it.toMap().toMutableMap() }.toMutableList()
  }

  override fun setCamera(cameraOptions: CameraOptions) {
    mapboxMap.setCamera(cameraOptions.toCameraOptions(context))
  }

  override fun getCameraState(): CameraState {
    return mapboxMap.cameraState.toCameraState(context)
  }

  override fun setBounds(options: CameraBoundsOptions) {
    mapboxMap.setBounds(options.toCameraBoundsOptions())
  }

  override fun getBounds(): CameraBounds {
    return mapboxMap.getBounds().toFLTCameraBounds()
  }
}