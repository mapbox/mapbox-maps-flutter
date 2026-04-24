package com.mapbox.maps.mapbox_maps.viewannotation

import android.graphics.BitmapFactory
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.ViewAnnotationAnchor
import com.mapbox.maps.viewannotation.annotationAnchor
import com.mapbox.maps.viewannotation.geometry
import com.mapbox.maps.viewannotation.viewAnnotationOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.util.concurrent.atomic.AtomicInteger

/**
 * Owns all [ViewAnnotationManager] instances attached to this map.
 *
 * Call sites are:
 *  1. [handleCreateManager] from [MapboxMapController.onMethodCall] for the
 *     `view_annotation#create_manager` method.
 *  2. Per-manager [MethodChannel]s set up inside [ManagerHandle] for
 *     `create` / `update` / `delete` / `deleteAll` / `dispose`.
 *
 * We keep one `MethodChannel` per manager so messages do not have to be
 * demuxed through a shared channel and the clean-up path is trivial
 * (disposing the manager also releases its channel).
 */
internal class ViewAnnotationController(
  private val mapView: MapView,
  private val messenger: BinaryMessenger,
  private val channelSuffix: String,
) {

  private val managers = mutableMapOf<String, ManagerHandle>()
  private val managerAutoId = AtomicInteger(0)

  fun handleCreateManager(call: MethodCall, result: MethodChannel.Result) {
    val requestedId = call.argument<String>("id")
    val resolvedId = requestedId
      ?: "view_annotation_manager_${managerAutoId.incrementAndGet()}"

    if (managers.containsKey(resolvedId)) {
      // Manager with this id already exists; reuse it.
      result.success(resolvedId)
      return
    }

    managers[resolvedId] = ManagerHandle(
      managerId = resolvedId,
      channel = MethodChannel(
        messenger,
        "plugins.flutter.io.mapbox_maps.view_annotations.$channelSuffix.$resolvedId",
        StandardMethodCodec.INSTANCE,
      ),
    )
    result.success(resolvedId)
  }

  fun dispose() {
    managers.values.toList().forEach { it.dispose() }
    managers.clear()
  }

  private inner class ManagerHandle(
    val managerId: String,
    val channel: MethodChannel,
  ) : MethodChannel.MethodCallHandler {

    private val annotations = linkedMapOf<String, NativeViewAnnotation>()

    init {
      channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
      when (call.method) {
        "create" -> handleUpsert(call, result, isCreate = true)
        "update" -> handleUpsert(call, result, isCreate = false)
        "delete" -> handleDelete(call, result)
        "deleteAll" -> {
          clearAll()
          result.success(null)
        }
        "dispose" -> {
          dispose()
          managers.remove(managerId)
          result.success(null)
        }
        else -> result.notImplemented()
      }
    }

    fun dispose() {
      clearAll()
      channel.setMethodCallHandler(null)
    }

    private fun clearAll() {
      val ids = annotations.keys.toList()
      ids.forEach(::remove)
    }

    private fun handleDelete(call: MethodCall, result: MethodChannel.Result) {
      val id = call.argument<String>("id")
      if (id == null) {
        result.error("INVALID_ARGUMENTS", "delete requires an id.", null)
        return
      }
      remove(id)
      result.success(null)
    }

    private fun handleUpsert(
      call: MethodCall,
      result: MethodChannel.Result,
      isCreate: Boolean,
    ) {
      val args = call.arguments as? Map<*, *>
      if (args == null) {
        result.error("INVALID_ARGUMENTS", "Missing arguments map.", null)
        return
      }

      val id = args["id"] as? String
      if (id == null) {
        result.error("INVALID_ARGUMENTS", "Missing annotation id.", null)
        return
      }

      val bitmapBytes = args["image"] as? ByteArray
      if (bitmapBytes == null) {
        result.error("INVALID_ARGUMENTS", "Missing image bytes.", null)
        return
      }
      val bitmap = BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size)
      if (bitmap == null) {
        result.error("INVALID_ARGUMENTS", "Unable to decode annotation image.", null)
        return
      }

      val coordinates = args["coordinates"] as? List<*>
      if (coordinates == null || coordinates.size < 2) {
        result.error("INVALID_ARGUMENTS", "Missing or malformed coordinates.", null)
        return
      }
      val longitude = (coordinates[0] as? Number)?.toDouble()
      val latitude = (coordinates[1] as? Number)?.toDouble()
      if (longitude == null || latitude == null) {
        result.error("INVALID_ARGUMENTS", "coordinates must be numeric.", null)
        return
      }

      val width = ((args["width"] as? Number)?.toDouble() ?: bitmap.width.toDouble()).toInt()
      val height = ((args["height"] as? Number)?.toDouble() ?: bitmap.height.toDouble()).toInt()
      val visible = (args["visible"] as? Boolean) ?: true
      val allowOverlap = (args["allowOverlap"] as? Boolean) ?: true
      val offsetX = (args["offsetX"] as? Number)?.toDouble() ?: 0.0
      val offsetY = (args["offsetY"] as? Number)?.toDouble() ?: 0.0
      val anchor = decodeAnchor((args["anchor"] as? Number)?.toInt())

      val existing = annotations[id]
      if (existing == null && !isCreate) {
        result.error("NOT_FOUND", "No view annotation with id=$id.", null)
        return
      }

      val options = viewAnnotationOptions {
        geometry(Point.fromLngLat(longitude, latitude))
        width(width.toDouble())
        height(height.toDouble())
        visible(visible)
        allowOverlap(allowOverlap)
        annotationAnchor {
          anchor(anchor)
          offsetX(offsetX)
          offsetY(offsetY)
        }
      }

      if (existing == null) {
        val imageView = ImageView(mapView.context).apply {
          scaleType = ImageView.ScaleType.FIT_XY
          layoutParams = ViewGroup.LayoutParams(width, height)
          setImageBitmap(bitmap)
          isClickable = true
          setOnClickListener { dispatchTap(id) }
        }
        mapView.viewAnnotationManager.addViewAnnotation(imageView, options)
        annotations[id] = NativeViewAnnotation(view = imageView)
      } else {
        existing.view.setImageBitmap(bitmap)
        existing.view.layoutParams = (existing.view.layoutParams ?: ViewGroup.LayoutParams(width, height)).also {
          it.width = width
          it.height = height
        }
        existing.view.visibility = if (visible) View.VISIBLE else View.GONE
        existing.view.requestLayout()
        mapView.viewAnnotationManager.updateViewAnnotation(existing.view, options)
      }

      result.success(null)
    }

    private fun remove(id: String) {
      val entry = annotations.remove(id) ?: return
      mapView.viewAnnotationManager.removeViewAnnotation(entry.view)
      entry.view.setOnClickListener(null)
    }

    private fun dispatchTap(annotationId: String) {
      channel.invokeMethod("onTap", mapOf("id" to annotationId))
    }
  }

  private data class NativeViewAnnotation(val view: ImageView)

  private fun decodeAnchor(rawValue: Int?): ViewAnnotationAnchor {
    // Wire ordinals mirror lib/src/pigeons/map_interfaces.dart::ViewAnnotationAnchor.
    return when (rawValue) {
      0 -> ViewAnnotationAnchor.TOP
      1 -> ViewAnnotationAnchor.LEFT
      2 -> ViewAnnotationAnchor.BOTTOM
      3 -> ViewAnnotationAnchor.RIGHT
      4 -> ViewAnnotationAnchor.TOP_LEFT
      5 -> ViewAnnotationAnchor.BOTTOM_RIGHT
      6 -> ViewAnnotationAnchor.TOP_RIGHT
      7 -> ViewAnnotationAnchor.BOTTOM_LEFT
      8 -> ViewAnnotationAnchor.CENTER
      else -> ViewAnnotationAnchor.CENTER
    }
  }
}
