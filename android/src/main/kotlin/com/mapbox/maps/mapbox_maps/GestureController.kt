package com.mapbox.maps.mapbox_maps

import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTGestureListeners
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger

class GestureController(private val mapView: MapView) :
  FLTSettings.GesturesSettingsInterface {

  private lateinit var gestureListener: FLTGestureListeners.GestureListener

  override fun getSettings(): FLTSettings.GesturesSettings = mapView.gestures.toFLT()

  override fun updateSettings(settings: FLTSettings.GesturesSettings) {
    mapView.gestures.applyFromFLT(settings, mapView.context)
  }

  fun setup(messenger: BinaryMessenger) {
    gestureListener = FLTGestureListeners.GestureListener(messenger)
    mapView.gestures.addOnMapClickListener {
      gestureListener.onTap(it.toFLTScreenCoordinate()) {}
      false
    }
    mapView.gestures.addOnMapLongClickListener {
      gestureListener.onLongTap(it.toFLTScreenCoordinate()) {}
      false
    }
    mapView.gestures.addOnMoveListener(object :
        OnMoveListener {
        override fun onMove(detector: MoveGestureDetector): Boolean {
          gestureListener.onScroll(
            mapView.getMapboxMap().coordinateForPixel(
              ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
            ).toFLTScreenCoordinate()
          ) {}
          return false
        }

        override fun onMoveBegin(detector: MoveGestureDetector) {}

        override fun onMoveEnd(detector: MoveGestureDetector) {}
      })
  }
}

private fun Point.toFLTScreenCoordinate(): FLTGestureListeners.ScreenCoordinate {
  return FLTGestureListeners.ScreenCoordinate.Builder()
    .setX(this.latitude())
    .setY(this.longitude())
    .build()
}