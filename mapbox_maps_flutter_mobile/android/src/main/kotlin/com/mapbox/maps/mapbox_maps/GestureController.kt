package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.android.gestures.RotateGestureDetector
import com.mapbox.android.gestures.ShoveGestureDetector
import com.mapbox.android.gestures.StandardScaleGestureDetector
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.GestureListener
import com.mapbox.maps.mapbox_maps.pigeons.GestureState
import com.mapbox.maps.mapbox_maps.pigeons.GesturesSettings
import com.mapbox.maps.mapbox_maps.pigeons.GesturesSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.MapContentGestureContext
import com.mapbox.maps.mapbox_maps.pigeons.PanEventsStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.PigeonEventSink
import com.mapbox.maps.mapbox_maps.pigeons.PitchEventsStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.RotateEventsStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.ScreenCoordinate
import com.mapbox.maps.mapbox_maps.pigeons.ZoomEventsStreamHandler
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMapLongClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.OnRotateListener
import com.mapbox.maps.plugin.gestures.OnScaleListener
import com.mapbox.maps.plugin.gestures.OnShoveListener
import com.mapbox.maps.plugin.gestures.gestures
import io.flutter.plugin.common.BinaryMessenger

class GestureController(
  private val mapView: MapView,
  private val context: Context,
  private val messenger: BinaryMessenger,
  private val channelSuffix: String,
) : GesturesSettingsInterface {

  override fun getSettings(): GesturesSettings = mapView.gestures.toFLT(mapView.context)

  override fun updateSettings(settings: GesturesSettings) {
    mapView.gestures.applyFromFLT(settings, mapView.context)
  }

  private var fltGestureListener: GestureListener? = null

  init {
    register()
  }

  private fun register() {
    val panEvents = object : PanEventsStreamHandler() {
      var sink: PigeonEventSink<MapContentGestureContext>? = null
      override fun onListen(p0: Any?, sink: PigeonEventSink<MapContentGestureContext>) { this.sink = sink }
      override fun onCancel(p0: Any?) { sink = null }
    }
    val zoomEvents = object : ZoomEventsStreamHandler() {
      var sink: PigeonEventSink<MapContentGestureContext>? = null
      override fun onListen(p0: Any?, sink: PigeonEventSink<MapContentGestureContext>) { this.sink = sink }
      override fun onCancel(p0: Any?) { sink = null }
    }
    val rotateEvents = object : RotateEventsStreamHandler() {
      var sink: PigeonEventSink<MapContentGestureContext>? = null
      override fun onListen(p0: Any?, sink: PigeonEventSink<MapContentGestureContext>) { this.sink = sink }
      override fun onCancel(p0: Any?) { sink = null }
    }
    val pitchEvents = object : PitchEventsStreamHandler() {
      var sink: PigeonEventSink<MapContentGestureContext>? = null
      override fun onListen(p0: Any?, sink: PigeonEventSink<MapContentGestureContext>) { this.sink = sink }
      override fun onCancel(p0: Any?) { sink = null }
    }

    PanEventsStreamHandler.register(messenger, panEvents, channelSuffix)
    ZoomEventsStreamHandler.register(messenger, zoomEvents, channelSuffix)
    RotateEventsStreamHandler.register(messenger, rotateEvents, channelSuffix)
    PitchEventsStreamHandler.register(messenger, pitchEvents, channelSuffix)

    fun reportMove(detector: MoveGestureDetector, state: GestureState) {
      val pixel = com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
      val point = mapView.mapboxMap.coordinateForPixel(pixel)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, state)
      fltGestureListener?.onScroll(context) { }
      panEvents.sink?.success(context)
    }

    fun reportScale(detector: StandardScaleGestureDetector, state: GestureState) {
      val pixel = com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
      val point = mapView.mapboxMap.coordinateForPixel(pixel)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, state)
      fltGestureListener?.onZoom(context) { }
      zoomEvents.sink?.success(context)
    }

    fun reportRotate(detector: RotateGestureDetector, state: GestureState) {
      val pixel = com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
      val point = mapView.mapboxMap.coordinateForPixel(pixel)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, state)
      rotateEvents.sink?.success(context)
    }

    fun reportShove(detector: ShoveGestureDetector, state: GestureState) {
      val pixel = com.mapbox.maps.ScreenCoordinate(detector.currentEvent.x.toDouble(), detector.currentEvent.y.toDouble())
      val point = mapView.mapboxMap.coordinateForPixel(pixel)
      val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, state)
      pitchEvents.sink?.success(context)
    }

    mapView.gestures.addOnMapClickListener(
      OnMapClickListener { point ->
        val pixel = mapView.mapboxMap.pixelForCoordinate(point)
        val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), point, GestureState.ENDED)
        fltGestureListener?.onTap(context) { }
        false
      }
    )

    mapView.gestures.addOnMapLongClickListener(
      OnMapLongClickListener {
        val pixel = mapView.mapboxMap.pixelForCoordinate(it)
        val context = MapContentGestureContext(pixel.toFLTScreenCoordinate(context), it, GestureState.ENDED)
        fltGestureListener?.onLongTap(context) { }
        false
      }
    )

    mapView.gestures.addOnMoveListener(object : OnMoveListener {
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
    })

    mapView.gestures.addOnScaleListener(object : OnScaleListener {
      override fun onScale(detector: StandardScaleGestureDetector) {
        reportScale(detector, GestureState.CHANGED)
      }

      override fun onScaleBegin(detector: StandardScaleGestureDetector) {
        reportScale(detector, GestureState.STARTED)
      }

      override fun onScaleEnd(detector: StandardScaleGestureDetector) {
        reportScale(detector, GestureState.ENDED)
      }
    })

    mapView.gestures.addOnRotateListener(object : OnRotateListener {
      override fun onRotateBegin(detector: RotateGestureDetector) {
        reportRotate(detector, GestureState.STARTED)
      }

      override fun onRotate(detector: RotateGestureDetector) {
        reportRotate(detector, GestureState.CHANGED)
      }

      override fun onRotateEnd(detector: RotateGestureDetector) {
        reportRotate(detector, GestureState.ENDED)
      }
    })

    mapView.gestures.addOnShoveListener(object : OnShoveListener {
      override fun onShoveBegin(detector: ShoveGestureDetector) {
        reportShove(detector, GestureState.STARTED)
      }

      override fun onShove(detector: ShoveGestureDetector) {
        reportShove(detector, GestureState.CHANGED)
      }

      override fun onShoveEnd(detector: ShoveGestureDetector) {
        reportShove(detector, GestureState.ENDED)
      }
    })
  }

  fun addListeners() {
    fltGestureListener = GestureListener(messenger, channelSuffix)
  }

  fun removeListeners() {
    fltGestureListener = null
  }
}

private fun Point.toFLTScreenCoordinate(): ScreenCoordinate {
  return ScreenCoordinate(x = latitude(), y = longitude())
}