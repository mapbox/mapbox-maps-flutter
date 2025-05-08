package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.pigeons.OnCircleAnnotationClickListener
import com.mapbox.maps.mapbox_maps.pigeons.OnPointAnnotationClickListener
import com.mapbox.maps.mapbox_maps.pigeons.OnPolygonAnnotationClickListener
import com.mapbox.maps.mapbox_maps.pigeons.OnPolylineAnnotationClickListener
import com.mapbox.maps.mapbox_maps.pigeons.PointAnnotation
import com.mapbox.maps.plugin.annotation.Annotation
import com.mapbox.maps.plugin.annotation.AnnotationConfig
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.*
import com.mapbox.maps.plugin.annotation.generated.CircleAnnotation
import com.mapbox.maps.plugin.annotation.generated.PolygonAnnotation
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AnnotationController(
  private val mapView: MapView,
  private val messenger: BinaryMessenger,
  private val channelSuffix: String
) : ControllerDelegate {
  private val managerMap = mutableMapOf<String, AnnotationManager<*, *, *, *, *, *, *>>()
  private val streamSinkMap = mutableMapOf<String, PigeonEventSink<AnnotationInteractionContext>>()
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
              false
            }
          )
          this.addDragListener(object :
              OnCircleAnnotationDragListener {
              override fun onAnnotationDrag(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.CHANGED)
              }

              override fun onAnnotationDragFinished(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.ENDED)
              }

              override fun onAnnotationDragStarted(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.STARTED)
              }
            })
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener?.onPointAnnotationClick(annotation.toFLTPointAnnotation()) {}
              false
            }
          )
          this.addDragListener(object :
              OnPointAnnotationDragListener {
              override fun onAnnotationDrag(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.CHANGED)
              }

              override fun onAnnotationDragFinished(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.ENDED)
              }

              override fun onAnnotationDragStarted(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.STARTED)
              }
            })
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener?.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation()) {}
              false
            }
          )
          this.addDragListener(object :
              OnPolygonAnnotationDragListener {
              override fun onAnnotationDrag(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.CHANGED)
              }

              override fun onAnnotationDragFinished(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.ENDED)
              }

              override fun onAnnotationDragStarted(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.STARTED)
              }
            })
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager(AnnotationConfig(belowLayerId, id, id)).apply {
          this.addClickListener(
            com.mapbox.maps.plugin.annotation.generated.OnPolylineAnnotationClickListener { annotation ->
              onPolylineAnnotationClickListener?.onPolylineAnnotationClick(annotation.toFLTPolylineAnnotation()) {}
              false
            }
          )
          this.addDragListener(object :
              OnPolylineAnnotationDragListener {
              override fun onAnnotationDrag(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.CHANGED)
              }

              override fun onAnnotationDragFinished(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.ENDED)
              }

              override fun onAnnotationDragStarted(annotation: Annotation<*>) {
                sendDragEvent(id, annotation, GestureState.STARTED)
              }
            })
        }
      }
      else -> {
        result.error("0", "Unrecognized manager type: $type", null)
        return
      }
    }

    val interactionEvents = object : AnnotationDragEventsStreamHandler() {
      override fun onListen(p0: Any?, sink: PigeonEventSink<AnnotationInteractionContext>) {
        streamSinkMap[id] = sink
      }

      override fun onCancel(p0: Any?) {
        streamSinkMap.remove(id)
      }
    }

    AnnotationDragEventsStreamHandler.register(
      messenger,
      interactionEvents, "$channelSuffix/$id"
    )

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

  fun setup() {
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

  fun dispose() {
    _PointAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _CircleAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _PolylineAnnotationMessenger.setUp(messenger, null, channelSuffix)
    _PolygonAnnotationMessenger.setUp(messenger, null, channelSuffix)
    onPointAnnotationClickListener = null
    onCircleAnnotationClickListener = null
    onPolygonAnnotationClickListener = null
    onPolylineAnnotationClickListener = null
  }

  fun sendDragEvent(managerId: String, annotation: Annotation<*>, gestureState: GestureState) {
    val context: AnnotationInteractionContext = when (annotation) {
      is com.mapbox.maps.plugin.annotation.generated.PointAnnotation ->
        PointAnnotationInteractionContext(annotation.toFLTPointAnnotation(), gestureState)
      is CircleAnnotation ->
        CircleAnnotationInteractionContext(annotation.toFLTCircleAnnotation(), gestureState)
      is PolygonAnnotation ->
        PolygonAnnotationInteractionContext(annotation.toFLTPolygonAnnotation(), gestureState)
      is PolylineAnnotation ->
        PolylineAnnotationInteractionContext(annotation.toFLTPolylineAnnotation(), gestureState)

      else -> throw IllegalArgumentException("$annotation is unsupported")
    }
    streamSinkMap[managerId]?.success(context)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }
}