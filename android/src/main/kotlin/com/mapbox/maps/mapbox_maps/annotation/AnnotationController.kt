package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.MapView
import com.mapbox.maps.pigeons.*
import com.mapbox.maps.plugin.annotation.AnnotationConfig
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AnnotationController(private val mapView: MapView) :
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
    val voidResult = object : FLTCircleAnnotationMessager.VoidResult, FLTPointAnnotationMessager.VoidResult, FLTPolygonAnnotationMessager.VoidResult, FLTPolylineAnnotationMessager.VoidResult {
      override fun success() { }
      override fun error(error: Throwable) { }
    }
    val id = call.argument<String>("id") ?: (index++).toString()
    val layerId = call.argument<String>("belowLayerId")

    val belowLayerId = if (layerId != null && mapView.mapboxMap.style?.styleLayerExists(layerId) == true) {
      layerId
    } else {
      null
    }
    val manager = when (val type = call.argument<String>("type")!!) {
      "circle" -> {
        mapView.annotations.createCircleAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            OnCircleAnnotationClickListener { annotation ->
              onCircleAnnotationClickListener.onCircleAnnotationClick(annotation.toFLTCircleAnnotation(), voidResult)
              true
            }
          )
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener.onPointAnnotationClick(annotation.toFLTPointAnnotation(), voidResult)
              true
            }
          )
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation(), voidResult)
              true
            }
          )
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            OnPolylineAnnotationClickListener { annotation ->
              onPolylineAnnotationController.onPolylineAnnotationClick(annotation.toFLTPolylineAnnotation(), voidResult)
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
    FLTPointAnnotationMessager._PointAnnotationMessager.setUp(messenger, pointAnnotationController)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setUp(
      messenger,
      circleAnnotationController
    )
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setUp(
      messenger,
      polylineAnnotationController
    )
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setUp(
      messenger,
      polygonAnnotationController
    )
  }

  fun dispose(messenger: BinaryMessenger) {
    FLTPointAnnotationMessager._PointAnnotationMessager.setUp(messenger, null)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setUp(messenger, null)
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setUp(messenger, null)
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setUp(messenger, null)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }
}