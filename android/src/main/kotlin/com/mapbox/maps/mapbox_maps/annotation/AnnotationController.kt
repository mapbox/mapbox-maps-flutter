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
import kotlin.collections.set

class AnnotationController(
  private val mapView: MapView,
  private val messenger: BinaryMessenger,
  private val channelSuffix: String
) : ControllerDelegate {
  private val managerMap = mutableMapOf<String, AnnotationManager<*, *, *, *, *, *, *>>()
  private val streamSinkMap = mutableMapOf<String, InteractionEventsHandler>()
  private val pointAnnotationController = PointAnnotationController(this)
  private val circleAnnotationController = CircleAnnotationController(this)
  private val polygonAnnotationController = PolygonAnnotationController(this)
  private val polylineAnnotationController = PolylineAnnotationController(this)
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
              sendTapEvent(id, annotation)
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
              sendTapEvent(id, annotation)
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
              sendTapEvent(id, annotation)
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
              sendTapEvent(id, annotation)
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
    streamSinkMap[managerId]?.dragEventsSink?.success(context)
  }

  fun sendTapEvent(managerId: String, annotation: Annotation<*>) {
    val context: AnnotationInteractionContext = when (annotation) {
      is com.mapbox.maps.plugin.annotation.generated.PointAnnotation ->
        PointAnnotationInteractionContext(annotation.toFLTPointAnnotation(), GestureState.ENDED)
      is CircleAnnotation ->
        CircleAnnotationInteractionContext(annotation.toFLTCircleAnnotation(), GestureState.ENDED)
      is PolygonAnnotation ->
        PolygonAnnotationInteractionContext(annotation.toFLTPolygonAnnotation(), GestureState.ENDED)
      is PolylineAnnotation ->
        PolylineAnnotationInteractionContext(annotation.toFLTPolylineAnnotation(), GestureState.ENDED)

      else -> throw IllegalArgumentException("$annotation is unsupported")
    }
    streamSinkMap[managerId]?.tapEventsSink?.success(context)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }

  companion object {
    class InteractionEventsHandler {
      var tapEventsSink: PigeonEventSink<AnnotationInteractionContext>? = null
      var dragEventsSink: PigeonEventSink<AnnotationInteractionContext>? = null

      fun register(messenger: BinaryMessenger, channelName: String) {
          val tapEvents = object : AnnotationInteractionEventsStreamHandler() {
            override fun onListen(p0: Any?, sink: PigeonEventSink<AnnotationInteractionContext>) {
              tapEventsSink = sink
            }

            override fun onCancel(p0: Any?) {
              tapEventsSink = null
            }
          }
          val dragEvents = object : AnnotationInteractionEventsStreamHandler() {
            override fun onListen(p0: Any?, sink: PigeonEventSink<AnnotationInteractionContext>) {
              dragEventsSink = sink
            }

            override fun onCancel(p0: Any?) {
              dragEventsSink = null
            }
          }
        AnnotationInteractionEventsStreamHandler.register(messenger, tapEvents, "$channelName/tap")
        AnnotationInteractionEventsStreamHandler.register(messenger, tapEvents, "$channelName/drag")
      }
    }
  }
}