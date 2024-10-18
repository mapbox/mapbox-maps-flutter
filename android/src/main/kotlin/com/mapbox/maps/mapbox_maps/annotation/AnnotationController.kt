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
  private var onPointAnnotationClickListener: OnPointAnnotationClickListener? = null
  private var onPolygonAnnotationClickListener: OnPolygonAnnotationClickListener? = null
  private var onPolylineAnnotationClickListener: OnPolylineAnnotationClickListener? = null
  private var onCircleAnnotationClickListener: OnCircleAnnotationClickListener? = null
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
              onCircleAnnotationClickListener?.onCircleAnnotationClick(annotation.toFLTCircleAnnotation()) {}
              true
            }
          )
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener?.onPointAnnotationClick(annotation.toFLTPointAnnotation()) {}
              true
            }
          )
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener?.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation()) {}
              true
            }
          )
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolylineAnnotationClickListener { annotation ->
              onPolylineAnnotationClickListener?.onPolylineAnnotationClick(annotation.toFLTPolylineAnnotation()) {}
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

  fun setup(messenger: BinaryMessenger, channelSuffix: String) {
    onPointAnnotationClickListener = OnPointAnnotationClickListener(messenger, channelSuffix)
    onCircleAnnotationClickListener = OnCircleAnnotationClickListener(messenger, channelSuffix)
    onPolygonAnnotationClickListener = OnPolygonAnnotationClickListener(messenger, channelSuffix)
    onPolylineAnnotationClickListener = OnPolylineAnnotationClickListener(messenger, channelSuffix)
    _PointAnnotationMessenger.setUp(messenger, pointAnnotationController, channelSuffix)
    _CircleAnnotationMessenger.setUp(
      messenger,
      circleAnnotationController, channelSuffix
    )
    _PolylineAnnotationMessenger.setUp(
      messenger,
      polylineAnnotationController, channelSuffix
    )
    _PolygonAnnotationMessenger.setUp(
      messenger,
      polygonAnnotationController, channelSuffix
    )
  }

  fun dispose(messenger: BinaryMessenger, channelSuffix: String) {
    _PointAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _CircleAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _PolylineAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _PolygonAnnotationMessenger.setUp(messenger, null, channelSuffix)
    onPointAnnotationClickListener = null
    onCircleAnnotationClickListener = null
    onPolygonAnnotationClickListener = null
    onPolylineAnnotationClickListener = null
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }
}