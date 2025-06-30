package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.animation.*

class CameraController(private val mapboxMap: MapboxMap, private val context: Context) : _CameraManager {
  override fun cameraForCoordinatesPadding(
    coordinates: List<Point>,
    camera: CameraOptions,
    coordinatesPadding: MbxEdgeInsets?,
    maxZoom: Double?,
    offset: ScreenCoordinate?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates,
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
    coordinates: List<Point>,
    padding: MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates,
      padding?.toEdgeInsets(context),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinatesCameraOptions(
    coordinates: List<Point>,
    camera: CameraOptions,
    box: ScreenBox
  ): CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates,
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

  override fun pixelForCoordinate(coordinate: Point): ScreenCoordinate {
    val screenCoordinate = mapboxMap.pixelForCoordinate(coordinate)
    return screenCoordinate.toFLTScreenCoordinate(context)
  }

  override fun coordinateForPixel(pixel: ScreenCoordinate): Point {
    return mapboxMap.coordinateForPixel(pixel.toScreenCoordinate(context))
  }

  override fun pixelsForCoordinates(coordinates: List<Point>): MutableList<ScreenCoordinate> {
    val screenCoordinates = mapboxMap.pixelsForCoordinates(coordinates)
    return screenCoordinates.map { it.toFLTScreenCoordinate(context) }.toMutableList()
  }

  override fun coordinatesForPixels(pixels: List<ScreenCoordinate?>): List<Point> {
    return mapboxMap.coordinatesForPixels(pixels.map { it!!.toScreenCoordinate(context) })
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