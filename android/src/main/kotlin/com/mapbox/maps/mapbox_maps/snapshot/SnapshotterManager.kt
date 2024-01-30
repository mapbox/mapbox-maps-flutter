package com.mapbox.maps.mapbox_maps.snapshot

import com.mapbox.maps.Size
import com.mapbox.maps.mapbox_maps.toCameraOptions
import com.mapbox.maps.mapbox_maps.toCameraState
import com.mapbox.maps.mapbox_maps.toEdgeInsets
import com.mapbox.maps.mapbox_maps.toFLTCameraOptions
import com.mapbox.maps.mapbox_maps.toFLTCoordinateBounds
import com.mapbox.maps.mapbox_maps.toFLTSize
import com.mapbox.maps.mapbox_maps.toMbxImage
import com.mapbox.maps.mapbox_maps.toPoint
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.pigeons.FLTMapInterfaces.MbxImage
import com.mapbox.maps.pigeons.FLTSnapshot
import java.util.concurrent.CompletableFuture
import java.util.concurrent.CountDownLatch
import java.util.concurrent.CyclicBarrier

class SnapshotterManager(private val delegate: SnapshotControllerDelegate) :
  FLTSnapshot._SnapshotterMessager {
  override fun cancel(id: String) {
    delegate.getSnapshotter(id).cancel();
  }

  override fun destroy(id: String) {
    delegate.getSnapshotter(id).destroy()
    delegate.remove(id)
  }

  override fun setCamera(id: String, cameraOptions: FLTMapInterfaces.CameraOptions) {
    delegate.getSnapshotter(id).setCamera(cameraOptions.toCameraOptions(delegate.getContext()))
  }

  override fun setStyleUri(id: String, styleUri: String) {
    delegate.getSnapshotter(id).setStyleUri(styleUri)
  }

  override fun setStyleJson(id: String, styleJson: String) {
    delegate.getSnapshotter(id).setStyleJson(styleJson)
  }

  override fun setSize(id: String, size: FLTMapInterfaces.Size) {
    delegate.getSnapshotter(id).setSize(Size(size.width.toFloat(), size.height.toFloat()))
  }

  override fun cameraForCoordinates(
    id: String,
    coordinates: MutableList<MutableMap<String, Any>>,
    padding: FLTMapInterfaces.MbxEdgeInsets,
    bearing: Double?,
    pitch: Double?
  ): FLTMapInterfaces.CameraOptions {
    val cameraOptions = delegate.getSnapshotter(id).cameraForCoordinates(
      coordinates.map { it.toPoint() },
      padding.toEdgeInsets(delegate.getContext()),
      bearing ?: 0.0, pitch ?: 0.0,
    )
    return cameraOptions.toFLTCameraOptions(delegate.getContext())
  }

  override fun coordinateBoundsForCamera(
    id: String,
    camera: FLTMapInterfaces.CameraOptions
  ): FLTMapInterfaces.CoordinateBounds {
    val coordinateBounds = delegate.getSnapshotter(id)
      .coordinateBoundsForCamera(camera.toCameraOptions(delegate.getContext()))
    return coordinateBounds.toFLTCoordinateBounds()
  }

  override fun getCameraState(id: String): FLTMapInterfaces.CameraState {
    val cameraState = delegate.getSnapshotter(id).getCameraState()
    return cameraState.toCameraState(delegate.getContext())
  }

  override fun getSize(id: String): FLTMapInterfaces.Size {
    val size = delegate.getSnapshotter(id).getSize()
    return size.toFLTSize(delegate.getContext())
  }

  override fun getStyleJson(id: String): String {
    return delegate.getSnapshotter(id).getStyleJson()
  }

  override fun getStyleUri(id: String): String {
    return delegate.getSnapshotter(id).getStyleUri()
  }

  override fun start(id: String, result: FLTSnapshot.NullableResult<MbxImage>) {
    delegate.getSnapshotter(id).start { snapshot, errorMessage ->
      if (errorMessage == null) {
        result.success(snapshot?.toMbxImage())
      } else {
        result.error(UnknownError(errorMessage))
      }
    }
  }
}