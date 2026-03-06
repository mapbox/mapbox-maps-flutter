package com.mapbox.maps.mapbox_maps.snapshot

import android.content.Context
import android.graphics.Bitmap
import com.mapbox.geojson.Point
import com.mapbox.maps.Snapshotter
import com.mapbox.maps.mapbox_maps.MapboxEventHandler
import com.mapbox.maps.mapbox_maps.pigeons.CameraOptions
import com.mapbox.maps.mapbox_maps.pigeons.CameraState
import com.mapbox.maps.mapbox_maps.pigeons.CanonicalTileID
import com.mapbox.maps.mapbox_maps.pigeons.CoordinateBounds
import com.mapbox.maps.mapbox_maps.pigeons.MbxEdgeInsets
import com.mapbox.maps.mapbox_maps.pigeons.TileCoverOptions
import com.mapbox.maps.mapbox_maps.pigeons._SnapshotterMessenger
import com.mapbox.maps.mapbox_maps.toCameraOptions
import com.mapbox.maps.mapbox_maps.toCameraState
import com.mapbox.maps.mapbox_maps.toEdgeInsets
import com.mapbox.maps.mapbox_maps.toFLTCameraOptions
import com.mapbox.maps.mapbox_maps.toFLTCanonicalTileID
import com.mapbox.maps.mapbox_maps.toFLTCoordinateBounds
import com.mapbox.maps.mapbox_maps.toFLTSize
import com.mapbox.maps.mapbox_maps.toSize
import com.mapbox.maps.mapbox_maps.toTileCoverOptions
import java.io.ByteArrayOutputStream

class SnapshotterController(
  private val context: Context,
  private val snapshotter: Snapshotter,
  private val eventHandler: MapboxEventHandler
) : _SnapshotterMessenger {
  override fun getSize(): com.mapbox.maps.mapbox_maps.pigeons.Size {
    return snapshotter.getSize().toFLTSize(context)
  }

  override fun setSize(size: com.mapbox.maps.mapbox_maps.pigeons.Size) {
    snapshotter.setSize(size.toSize(context))
  }

  override fun getCameraState(): CameraState {
    return snapshotter.getCameraState().toCameraState(context)
  }

  override fun setCamera(cameraOptions: CameraOptions) {
    snapshotter.setCamera(cameraOptions.toCameraOptions(context))
  }

  override fun start(callback: (Result<ByteArray?>) -> Unit) {
    snapshotter.start(null) { snapshot, error ->
      if (snapshot != null) {
        val byteArray = ByteArrayOutputStream().also { stream ->
          snapshot.compress(Bitmap.CompressFormat.PNG, 100, stream)
        }.toByteArray()

        callback(Result.success(byteArray))
      } else {
        callback(Result.failure(Throwable(error ?: "Unknown error")))
      }
    }
  }

  override fun cancel() {
    snapshotter.cancel()
  }

  override fun coordinateBounds(camera: CameraOptions): CoordinateBounds {
    return snapshotter.coordinateBoundsForCamera(camera.toCameraOptions(context)).toFLTCoordinateBounds()
  }

  override fun camera(
    coordinates: List<Point>,
    padding: MbxEdgeInsets?,
    bearing: Double?,
    pitch: Double?
  ): CameraOptions {
    // TODO: remove default values from padding, bearing and pitch after they are optional on Android
    return snapshotter.cameraForCoordinates(
      coordinates,
      (padding ?: MbxEdgeInsets(0.0, 0.0, 0.0, 0.0)).toEdgeInsets(context),
      bearing ?: 0.0,
      pitch ?: 0.0
    )
      .toFLTCameraOptions(context)
  }

  override fun tileCover(options: TileCoverOptions): List<CanonicalTileID> {
    return snapshotter.tileCover(options.toTileCoverOptions(), null).map { it.toFLTCanonicalTileID() }
  }

  override fun clearData(callback: (Result<Unit>) -> Unit) {
    Snapshotter.clearData() {
      if (it.isError) {
        callback(Result.failure(Throwable(it.error)))
      } else {
        callback(Result.success(Unit))
      }
    }
  }
}