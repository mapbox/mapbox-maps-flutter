package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.plugin.animation.*

class CameraController(private val mapboxMap: MapboxMap, private val context: Context) : FLTMapInterfaces._CameraManager {
  override fun cameraForCoordinatesPadding(
    coordinates: MutableList<MutableMap<String, Any>>,
    camera: FLTMapInterfaces.CameraOptions,
    coordinatesPadding: FLTMapInterfaces.MbxEdgeInsets?,
    maxZoom: Double?,
    offset: FLTMapInterfaces.ScreenCoordinate?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      camera.toCameraOptions(context),
      coordinatesPadding?.toEdgeInsets(context),
      maxZoom,
      offset?.toScreenCoordinate(context)
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinateBounds(
    bounds: FLTMapInterfaces.CoordinateBounds,
    padding: FLTMapInterfaces.MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?,
    maxZoom: Double?,
    offset: FLTMapInterfaces.ScreenCoordinate?
  ): FLTMapInterfaces.CameraOptions {
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
    coordinates: MutableList<MutableMap<String, Any>>,
    padding: FLTMapInterfaces.MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      padding?.toEdgeInsets(context),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForCoordinatesCameraOptions(
    coordinates: MutableList<MutableMap<String, Any>>,
    camera: FLTMapInterfaces.CameraOptions,
    box: FLTMapInterfaces.ScreenBox
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForCoordinates(
      coordinates.map { it.toPoint() },
      camera.toCameraOptions(context),
      box.toScreenBox(context)
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun cameraForGeometry(
    geometry: MutableMap<String, Any>,
    padding: FLTMapInterfaces.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = mapboxMap.cameraForGeometry(
      geometry.toGeometry(),
      padding.toEdgeInsets(context),
      bearing,
      pitch
    )
    return cameraOptions.toFLTCameraOptions(context)
  }

  override fun coordinateBoundsForCamera(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBounds {
    val coordinateBounds = mapboxMap.coordinateBoundsForCamera(camera.toCameraOptions(context))
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsForCameraUnwrapped(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBounds {
    val coordinateBounds =
      mapboxMap.coordinateBoundsForCameraUnwrapped(camera.toCameraOptions(context))
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun coordinateBoundsZoomForCamera(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBoundsZoom {
    val coordinateBoundsZoom = mapboxMap.coordinateBoundsZoomForCamera(camera.toCameraOptions(context))
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun coordinateBoundsZoomForCameraUnwrapped(camera: FLTMapInterfaces.CameraOptions): FLTMapInterfaces.CoordinateBoundsZoom {
    val coordinateBoundsZoom =
      mapboxMap.coordinateBoundsZoomForCameraUnwrapped(camera.toCameraOptions(context))
    return coordinateBoundsZoom.toFLTCoordinateBoundsZoom()
  }

  override fun pixelForCoordinate(coordinate: MutableMap<String, Any>): FLTMapInterfaces.ScreenCoordinate {
    val screenCoordinate = mapboxMap.pixelForCoordinate(coordinate.toPoint())
    return screenCoordinate.toFLTScreenCoordinate(context)
  }

  override fun coordinateForPixel(pixel: FLTMapInterfaces.ScreenCoordinate): MutableMap<String, Any> {
    val screenCoordinate = mapboxMap.coordinateForPixel(pixel.toScreenCoordinate(context))
    return screenCoordinate.toMap() as MutableMap<String, Any>
  }

  override fun pixelsForCoordinates(coordinates: MutableList<MutableMap<String, Any>>): MutableList<FLTMapInterfaces.ScreenCoordinate> {
    val screenCoordinates = mapboxMap.pixelsForCoordinates(coordinates.map { it.toPoint() })
    return screenCoordinates.map { it.toFLTScreenCoordinate(context) }.toMutableList()
  }

  override fun coordinatesForPixels(pixels: MutableList<FLTMapInterfaces.ScreenCoordinate>): MutableList<MutableMap<String, Any>> {
    val points = mapboxMap.coordinatesForPixels(pixels.map { it.toScreenCoordinate(context) })
    return points.map { it.toMap().toMutableMap() }.toMutableList()
  }

  override fun setCamera(cameraOptions: FLTMapInterfaces.CameraOptions) {
    mapboxMap.setCamera(cameraOptions.toCameraOptions(context))
  }

  override fun getCameraState(): FLTMapInterfaces.CameraState {
    return mapboxMap.cameraState.toCameraState(context)
  }

  override fun setBounds(options: FLTMapInterfaces.CameraBoundsOptions) {
    mapboxMap.setBounds(options.toCameraBoundsOptions())
  }

  override fun getBounds(): FLTMapInterfaces.CameraBounds {
    return mapboxMap.getBounds().toFLTCameraBounds()
  }
}