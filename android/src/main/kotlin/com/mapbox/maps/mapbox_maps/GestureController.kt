package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.GestureListener
import com.mapbox.maps.mapbox_maps.pigeons.GestureState
import com.mapbox.maps.mapbox_maps.pigeons.GesturesSettings
import com.mapbox.maps.mapbox_maps.pigeons.GesturesSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.MapContentGestureContext
import com.mapbox.maps.mapbox_maps.pigeons.ScreenCoordinate
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMapLongClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger

class GestureController(private val mapView: MapView, private val context: Context) :
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

    fun reportMove(detector: MoveGestureDetector, state: GestureState) {
      val pixel = com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
      val point = mapView.mapboxMap.coordinateForPixel(pixel)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, state)
      fltGestureListener.onScroll(context) { }
    }

    onClickListener = OnMapClickListener { point ->
      val pixel = mapView.mapboxMap.pixelForCoordinate(point)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, GestureState.ENDED)
      fltGestureListener.onTap(context) { }
      false
    }.also { mapView.gestures.addOnMapClickListener(it) }

    onLongClickListener = OnMapLongClickListener {
      val pixel = mapView.mapboxMap.pixelForCoordinate(it)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), it, GestureState.ENDED)

      fltGestureListener.onLongTap(context) { }
      false
    }.also { mapView.gestures.addOnMapLongClickListener(it) }

    onMoveListener = object : OnMoveListener {
      override fun onMove(detector: MoveGestureDetector): Boolean {
        reportMove(detector, GestureState.CHANGED)
        return false
      }

      override fun onMoveBegin(detector: MoveGestureDetector) {
        reportMove(detector, GestureState.STARTED)
      }

      override fun onMoveEnd(detector: MoveGestureDetector) {
        reportMove(detector, GestureState.ENDED)
      }
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