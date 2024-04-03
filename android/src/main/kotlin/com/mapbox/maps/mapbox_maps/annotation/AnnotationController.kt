package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.pigeons.OnPointAnnotationClickListener
import com.mapbox.maps.mapbox_maps.pigeons._PointAnnotationMessenger
import com.mapbox.maps.plugin.annotation.AnnotationConfig
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.createCircleAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.createPointAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.createPolygonAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.createPolylineAnnotationManager
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
  private lateinit var onPointAnnotationClickListener: OnPointAnnotationClickListener
  private lateinit var onPolygonAnnotationClickListener: OnPolygonAnnotationClickListener
  private lateinit var onPolylineAnnotationController: OnPolylineAnnotationClickListener
  private lateinit var onCircleAnnotationClickListener: OnCircleAnnotationClickListener
  private var index = 0
  fun handleCreateManager(call: MethodCall, result: MethodChannel.Result) {
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
            com.mapbox.maps.plugin.annotation.generated.OnCircleAnnotationClickListener { annotation ->
              onCircleAnnotationClickListener.onCircleAnnotationClick(annotation.toFLTCircleAnnotation()) {}
              true
            }
          )
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener.onPointAnnotationClick(annotation.toFLTPointAnnotation()) {}
              true
            }
          )
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation()) {}
              true
            }
          )
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolylineAnnotationClickListener { annotation ->
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
    onPointAnnotationClickListener = OnPointAnnotationClickListener(messenger)
    onCircleAnnotationClickListener = OnCircleAnnotationClickListener(messenger)
    onPolygonAnnotationClickListener = OnPolygonAnnotationClickListener(messenger)
    onPolylineAnnotationController = OnPolylineAnnotationClickListener(messenger)
    _PointAnnotationMessenger.setUp(messenger, pointAnnotationController)
    _CircleAnnotationMessenger.setUp(
      messenger,
      circleAnnotationController
    )
    _PolylineAnnotationMessenger.setUp(
      messenger,
      polylineAnnotationController
    )
    _PolygonAnnotationMessenger.setUp(
      messenger,
      polygonAnnotationController
    )
  }

  fun dispose(messenger: BinaryMessenger) {
    _PointAnnotationMessenger.setUp(messenger, null)
    _CircleAnnotationMessenger.setUp(messenger, null)
    _PolylineAnnotationMessenger.setUp(messenger, null)
    _PolygonAnnotationMessenger.setUp(messenger, null)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }
}