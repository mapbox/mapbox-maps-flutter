package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.*
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AnnotationController(private val mapView: MapView, private val mapboxMap: MapboxMap) :
  ControllerDelegate {
  private val managerMap = mutableMapOf<String, AnnotationManager<*, *, *, *, *, *, *>>()
  private val pointAnnotationController = PointAnnotationController(this)
  private val circleAnnotationController = CircleAnnotationController(this)
  private val polygonAnnotationController = PolygonAnnotationController(this)
  private val polylineAnnotationController = PolylineAnnotationController(this)
  private lateinit var onPointAnnotationClickListener: FLTPointAnnotationMessager.OnPointAnnotationClickListener
  private lateinit var onPolygonAnnotationClickListener: FLTPolygonAnnotationMessager.OnPolygonAnnotationClickListener
  private lateinit var onPolylineAnnotationController: FLTPolylineAnnotationMessager.OnPolylineAnnotationClickListener
  private lateinit var onCircleAnnotationClickListener: FLTCircleAnnotationMessager.OnCircleAnnotationClickListener
  private var index = 0
  fun handleCreateManager(call: MethodCall, result: MethodChannel.Result) {
    val manager = when (val type = call.argument<String>("type")!!) {
      "circle" -> {
        mapView.annotations.createCircleAnnotationManager().apply {
          this.addClickListener(
            OnCircleAnnotationClickListener { annotation ->
              onCircleAnnotationClickListener.onCircleAnnotationClick(annotation.toFLTCircleAnnotation()) {}
              true
            }
          )
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager().apply {
          this.addClickListener(
            OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener.onPointAnnotationClick(annotation.toFLTPointAnnotation()) {}
              true
            }
          )
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager().apply {
          this.addClickListener(
            OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation()) {}
              true
            }
          )
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager().apply {
          this.addClickListener(
            OnPolylineAnnotationClickListener { annotation ->
              onPolylineAnnotationController.onPolylineAnnotationClick(annotation.toFLTPolylineAnnotation()) {}
              true
            }
          )
        }
      }
      else -> {
        result.error("0", "Unrecognized manager type: $type", null)
        return
      }
    }
    val id = (index++).toString()
    managerMap[id] = manager
    result.success(id)
  }

  fun handleRemoveManager(call: MethodCall, result: MethodChannel.Result) {
    val id = call.argument<String>("id")!!
    managerMap.remove(id)?.let {
      mapView.annotations.removeAnnotationManager(it)
    }
    result.success(null)
  }

  fun setup(messenger: BinaryMessenger) {
    onPointAnnotationClickListener = FLTPointAnnotationMessager.OnPointAnnotationClickListener(messenger)
    onCircleAnnotationClickListener = FLTCircleAnnotationMessager.OnCircleAnnotationClickListener(messenger)
    onPolygonAnnotationClickListener = FLTPolygonAnnotationMessager.OnPolygonAnnotationClickListener(messenger)
    onPolylineAnnotationController = FLTPolylineAnnotationMessager.OnPolylineAnnotationClickListener(messenger)
    FLTPointAnnotationMessager._PointAnnotationMessager.setup(messenger, pointAnnotationController)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setup(
      messenger,
      circleAnnotationController
    )
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setup(
      messenger,
      polylineAnnotationController
    )
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setup(
      messenger,
      polygonAnnotationController
    )
  }

  fun dispose(messenger: BinaryMessenger) {
    FLTPointAnnotationMessager._PointAnnotationMessager.setup(messenger, null)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setup(messenger, null)
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setup(messenger, null)
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setup(messenger, null)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }
}