package com.mapbox.maps.mapbox_maps.snapshot

import android.content.Context
import com.mapbox.maps.MapSnapshotOptions
import com.mapbox.maps.MapView
import com.mapbox.maps.Size
import com.mapbox.maps.SnapshotOverlayOptions
import com.mapbox.maps.SnapshotStyleListener
import com.mapbox.maps.Snapshotter
import com.mapbox.maps.Style
import com.mapbox.maps.mapbox_maps.toMbxImage
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.pigeons.FLTSnapshot
import com.mapbox.maps.pigeons.FLTSnapshot.OnSnapshotStyleListener
import com.mapbox.maps.pigeons.FLTSnapshot.VoidResult
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID

interface SnapshotControllerDelegate {
  fun getSnapshotter(id: String): Snapshotter

  fun getContext(): Context

  fun remove(id: String)
}

class SnapshotController(private val mapView: MapView, private val context: Context) :
  FLTSnapshot._SnapShotManager,
  SnapshotControllerDelegate {

  private val snapshotterMap = mutableMapOf<String, Snapshotter>()
  private lateinit var onSnapshotStyleListener: OnSnapshotStyleListener
  private val snapshotter: SnapshotterManager = SnapshotterManager(this)

  override fun create(
    options: FLTSnapshot.MapSnapshotOptions,
    overlayOptions: FLTSnapshot.SnapshotOverlayOptions
  ): String {
    val snapshotter =
      Snapshotter(
        context,
        options.toSnapshotOptions(),
        overlayOptions.toSnapshotOverlayOptions()
      ).apply {
        val voidResult = object : VoidResult {
          override fun success() {}
          override fun error(error: Throwable) {}
        }
        this.setStyleListener(object : SnapshotStyleListener {
          override fun onDidFinishLoadingStyle(style: Style) {
            onSnapshotStyleListener.onDidFinishLoadingStyle(voidResult)
          }

          override fun onDidFailLoadingStyle(message: String) {
            onSnapshotStyleListener.onDidFailLoadingStyle(message, voidResult)
          }

          override fun onDidFullyLoadStyle(style: Style) {
            onSnapshotStyleListener.onDidFullyLoadStyle(voidResult)
          }

          override fun onStyleImageMissing(imageId: String) {
            onSnapshotStyleListener.onStyleImageMissing(imageId, voidResult)
          }
        })
      }
    val id = UUID.randomUUID().toString().replace("-", "")
    snapshotterMap[id] = snapshotter
    return id
  }

  override fun snapshot(result: FLTSnapshot.NullableResult<FLTMapInterfaces.MbxImage>) {
    mapView.snapshot {
      result.success(it?.toMbxImage())
    }
  }

  private fun FLTSnapshot.MapSnapshotOptions.toSnapshotOptions(): MapSnapshotOptions {
    val options = MapSnapshotOptions.Builder()
    options.size(Size(this.size.width.toFloat(), this.size.height.toFloat()))
    options.pixelRatio(this.pixelRatio.toFloat())
    return options.build()
  }

  private fun FLTSnapshot.SnapshotOverlayOptions.toSnapshotOverlayOptions(): SnapshotOverlayOptions {
    return SnapshotOverlayOptions(this.showLogo, this.showAttributes)
  }

  override fun getSnapshotter(id: String): Snapshotter {
    if (snapshotterMap[id] == null) {
      throw (Throwable("No Snapshotter found with id: $id"))
    }
    return snapshotterMap[id]!!
  }

  override fun getContext(): Context {
    return context
  }

  override fun remove(id: String) {
    snapshotterMap.remove(id)
  }

  fun setup(messenger: BinaryMessenger) {
    onSnapshotStyleListener = OnSnapshotStyleListener(messenger)
    FLTSnapshot._SnapShotManager.setUp(messenger, this)
    FLTSnapshot._SnapshotterMessager.setUp(messenger, snapshotter)
  }

  fun dispose(messenger: BinaryMessenger) {
    FLTSnapshot._SnapShotManager.setUp(messenger, null)
    FLTSnapshot._SnapshotterMessager.setUp(messenger, null)
    snapshotterMap.clear()
  }
}