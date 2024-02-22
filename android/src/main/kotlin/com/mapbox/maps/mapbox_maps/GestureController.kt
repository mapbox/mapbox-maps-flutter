package com.mapbox.maps.mapbox_maps

import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMapLongClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger

class GestureController(private val mapView: MapView) :
  GesturesSettingsInterface {

  override fun getSettings(): GesturesSettings = mapView.gestures.toFLT(mapView.context)

  override fun updateSettings(settings: GesturesSettings) {
    mapView.gestures.applyFromFLT(settings, mapView.context)
  }

  private lateinit var fltGestureListener: GestureListener
  private var onClickListener: OnMapClickListener? = null
  private var onLongClickListener: OnMapLongClickListener? = null
  private var onMoveListener: OnMoveListener? = null

  fun addListeners(messenger: BinaryMessenger) {
    fltGestureListener = GestureListener(messenger)

    removeListeners()

    onClickListener = OnMapClickListener { point ->
      fltGestureListener.onTap(point.toFLTScreenCoordinate()) { }
      false
    }.also { mapView.gestures.addOnMapClickListener(it) }

    onLongClickListener = OnMapLongClickListener {
      fltGestureListener.onLongTap(it.toFLTScreenCoordinate()) { }
      false
    }.also { mapView.gestures.addOnMapLongClickListener(it) }

    onMoveListener = object : OnMoveListener {
      override fun onMove(detector: MoveGestureDetector): Boolean {
        fltGestureListener.onScroll(
          mapView.mapboxMap.coordinateForPixel(
            com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
          ).toFLTScreenCoordinate(),
        ) { }
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

private fun Point.toFLTScreenCoordinate(): ScreenCoordinate {
  return ScreenCoordinate(x = latitude(), y = longitude())
}