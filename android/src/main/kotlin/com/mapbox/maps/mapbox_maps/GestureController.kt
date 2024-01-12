package com.mapbox.maps.mapbox_maps

import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTGestureListeners
import com.mapbox.maps.pigeons.FLTGestureListeners.VoidResult
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMapLongClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger

class GestureController(private val mapView: MapView) :
  FLTSettings.GesturesSettingsInterface {

  override fun getSettings(): FLTSettings.GesturesSettings = mapView.gestures.toFLT(mapView.context)

  override fun updateSettings(settings: FLTSettings.GesturesSettings) {
    mapView.gestures.applyFromFLT(settings, mapView.context)
  }

  private lateinit var fltGestureListener: FLTGestureListeners.GestureListener
  private var onClickListener: OnMapClickListener? = null
  private var onLongClickListener: OnMapLongClickListener? = null
  private var onMoveListener: OnMoveListener? = null

  fun addListeners(messenger: BinaryMessenger) {
    fltGestureListener = FLTGestureListeners.GestureListener(messenger)

    removeListeners()
    val result = object : VoidResult {
      override fun success() { }
      override fun error(error: Throwable) { }
    }
    onClickListener = OnMapClickListener { point ->
      fltGestureListener.onTap(point.toFLTScreenCoordinate(), result)
      false
    }.also { mapView.gestures.addOnMapClickListener(it) }

    onLongClickListener = OnMapLongClickListener {
      fltGestureListener.onLongTap(it.toFLTScreenCoordinate(), result)
      false
    }.also { mapView.gestures.addOnMapLongClickListener(it) }

    onMoveListener = object : OnMoveListener {
      override fun onMove(detector: MoveGestureDetector): Boolean {
        fltGestureListener.onScroll(
          mapView.mapboxMap.coordinateForPixel(
            ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
          ).toFLTScreenCoordinate(),
          result
        )
        return false
      }

      override fun onMoveBegin(detector: MoveGestureDetector) {}

      override fun onMoveEnd(detector: MoveGestureDetector) {}
    }.also { mapView.gestures.addOnMoveListener(it) }
  }

  fun removeListeners() {
    onClickListener?.let { mapView.gestures.removeOnMapClickListener(it) }
    onLongClickListener?.let { mapView.gestures.removeOnMapLongClickListener(it) }
    onMoveListener?.let { mapView.gestures.removeOnMoveListener(it) }
  }
}

private fun Point.toFLTScreenCoordinate(): FLTGestureListeners.ScreenCoordinate {
  return FLTGestureListeners.ScreenCoordinate.Builder()
    .setX(this.latitude())
    .setY(this.longitude())
    .build()
}