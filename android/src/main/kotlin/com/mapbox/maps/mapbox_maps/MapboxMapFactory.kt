package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.common.*
import com.mapbox.maps.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.lang.RuntimeException

class MapboxMapFactory(
  private val messenger: BinaryMessenger,
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

  override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
    if (context == null) {
      throw RuntimeException("Context is null, can't create MapView!")
    }
    val params = args as Map<String, Any>
    val mapOptionsBuilder = MapOptions.Builder().applyDefaultParams(context)

    (params["mapOptions"] as ArrayList<Any?>?)?.let { mapOptions ->
      mapOptions[0]?.let {
        mapOptionsBuilder.contextMode(ContextMode.values()[it as Int])
      }
      mapOptions[1]?.let {
        mapOptionsBuilder.constrainMode(ConstrainMode.values()[it as Int])
      }
      mapOptions[2]?.let {
        mapOptionsBuilder.viewportMode(ViewportMode.values()[it as Int])
      }
      mapOptions[3]?.let {
        mapOptionsBuilder.orientation(NorthOrientation.values()[it as Int])
      }
      mapOptions[4]?.let {
        mapOptionsBuilder.crossSourceCollisions(it as Boolean)
      }
      mapOptions[5]?.let {
        (it as ArrayList<Double>).let { size ->
          mapOptionsBuilder.size(
            Size(
              size[0].toDevicePixels(context),
              size[1].toDevicePixels(context)
            )
          )
        }
      }
      mapOptions[6]?.let {
        mapOptionsBuilder.pixelRatio((it as Double).toFloat())
      }
      mapOptions[7]?.let {
        (it as ArrayList<Any?>).let { glyphs ->
          val builder = GlyphsRasterizationOptions.Builder()
          glyphs[1]?.let { fontFamily ->
            builder.fontFamily(fontFamily as String)
          }
          glyphs[0]?.let { rasterizationMode ->
            builder.rasterizationMode(
              GlyphsRasterizationMode.values()[rasterizationMode as Int]
            )
          }
          mapOptionsBuilder.glyphsRasterizationOptions(builder.build())
        }
      }
    }

    val cameraOptions = (params["cameraOptions"] as ArrayList<Any?>?)?.let { cameraOptions ->
      val cameraOptionsBuilder = CameraOptions.Builder()
      cameraOptions[4]?.let {
        cameraOptionsBuilder.bearing(it as Double)
      }
      (cameraOptions[0] as? Map<String?, Any?>?)?.let {
        cameraOptionsBuilder.center(it.toPoint())
      }
      cameraOptions[5]?.let {
        cameraOptionsBuilder.pitch(it as Double)
      }
      cameraOptions[3]?.let {
        cameraOptionsBuilder.zoom(it as Double)
      }
      (cameraOptions[1] as? ArrayList<Double>?)?.let {
        cameraOptionsBuilder.padding(
          EdgeInsets(
            it[0].toDevicePixels(context).toDouble(), it[1].toDevicePixels(context).toDouble(),
            it[2].toDevicePixels(context).toDouble(), it[3].toDevicePixels(context).toDouble()
          )
        )
      }
      (cameraOptions[2] as? ArrayList<Double>?)?.let {
        cameraOptionsBuilder.anchor(
          ScreenCoordinate(
            it[0].toDevicePixels(context).toDouble(),
            it[1].toDevicePixels(context).toDouble()
          )
        )
      }
      cameraOptionsBuilder.build()
    }

    val channelSuffix = params["channelSuffix"] as Int

    val textureView = params["textureView"] as? Boolean ?: false
    val styleUri = params["styleUri"] as? String ?: Style.MAPBOX_STREETS
    val pluginVersion = params["mapboxPluginVersion"] as String
    val mapInitOptions = MapInitOptions(
      context = context,
      mapOptions = mapOptionsBuilder.build(),
      cameraOptions = cameraOptions,
      textureView = textureView,
      styleUri = styleUri
    )
    // TODO: Check if the cast succeeds
    val eventTypes = params["eventTypes"] as? List<Int> ?: listOf()
    return MapboxMapController(
      context,
      mapInitOptions,
      lifecycleProvider,
      eventTypes,
      messenger,
      channelSuffix,
      pluginVersion,
    )
  }

  companion object {
    private const val TAG = "MapBoxFactory"
  }
}