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
    val resourceOptionsBuilder = ResourceOptions.Builder().applyDefaultParams(context)
    val mapOptionsBuilder = MapOptions.Builder().applyDefaultParams(context)
    val cameraOptionsBuilder = CameraOptions.Builder()
    (params["resourceOptions"] as Map<String, Any>?)?.let { resourceOptions ->
      resourceOptions["accessToken"]?.let {
        resourceOptionsBuilder.accessToken(it as String)
      }
      resourceOptions["baseURL"]?.let {
        resourceOptionsBuilder.baseURL(it as String)
      }
      resourceOptions["dataPath"]?.let {
        resourceOptionsBuilder.dataPath(it as String)
      }
      resourceOptions["assetPath"]?.let {
        resourceOptionsBuilder.assetPath(it as String)
      }
      resourceOptions["tileStoreUsageMode"]?.let {
        resourceOptionsBuilder.tileStoreUsageMode(TileStoreUsageMode.values()[it as Int])
      }
    }

    (params["mapOptions"] as Map<String, Any>?)?.let { mapOptions ->
      mapOptions["contextMode"]?.let {
        mapOptionsBuilder.contextMode(ContextMode.values()[it as Int])
      }
      mapOptions["constrainMode"]?.let {
        mapOptionsBuilder.constrainMode(ConstrainMode.values()[it as Int])
      }
      mapOptions["viewportMode"]?.let {
        mapOptionsBuilder.viewportMode(ViewportMode.values()[it as Int])
      }
      mapOptions["orientation"]?.let {
        mapOptionsBuilder.orientation(NorthOrientation.values()[it as Int])
      }
      mapOptions["crossSourceCollisions"]?.let {
        mapOptionsBuilder.crossSourceCollisions(it as Boolean)
      }
      mapOptions["optimizeForTerrain"]?.let {
        mapOptionsBuilder.optimizeForTerrain(it as Boolean)
      }
      mapOptions["size"]?.let {
        (it as Map<String, Double>).let { size ->
          mapOptionsBuilder.size(
            Size(
              size["width"]!!.toFloat(),
              size["height"]!!.toFloat()
            )
          )
        }
      }
      mapOptions["pixelRatio"]?.let {
        mapOptionsBuilder.pixelRatio((it as Double).toFloat())
      }
      mapOptions["glyphsRasterizationOptions"]?.let {
        (it as Map<String, Any?>).let { glyphs ->
          val builder = GlyphsRasterizationOptions.Builder()
          glyphs["fontFamily"]?.let { fontFamily ->
            builder.fontFamily(fontFamily as String)
          }
          glyphs["rasterizationMode"]?.let { rasterizationMode ->
            builder.rasterizationMode(
              GlyphsRasterizationMode.values()[rasterizationMode as Int]
            )
          }
          mapOptionsBuilder.glyphsRasterizationOptions(builder.build())
        }
      }
    }

    (params["cameraOptions"] as Map<String, Any>?)?.let { cameraOptions ->
      cameraOptions["bearing"]?.let {
        cameraOptionsBuilder.bearing(it as Double)
      }
      (cameraOptions["center"] as Map<String, Any>?)?.let {
        cameraOptionsBuilder.center(it.toPoint())
      }
      cameraOptions["pitch"]?.let {
        cameraOptionsBuilder.pitch(it as Double)
      }
      cameraOptions["zoom"]?.let {
        cameraOptionsBuilder.zoom(it as Double)
      }
      (cameraOptions["padding"] as Map<String, Double>?)?.let {
        cameraOptionsBuilder.padding(
          EdgeInsets(
            it["top"]!!, it["left"]!!,
            it["bottom"]!!, it["right"]!!
          )
        )
      }
      (cameraOptions["anchor"] as Map<String, Double>?)?.let {
        cameraOptionsBuilder.anchor(ScreenCoordinate(it["x"]!!, it["y"]!!))
      }
    }

    val channelSuffix = params["channelSuffix"] as Int

    val textureView = params["textureView"] as? Boolean ?: false
    val styleUri = params["styleUri"] as? String ?: Style.MAPBOX_STREETS
    val pluginVersion = params["mapboxPluginVersion"] as String
    val mapInitOptions = MapInitOptions(
      context = context,
      resourceOptions = resourceOptionsBuilder.build(),
      mapOptions = mapOptionsBuilder.build(),
      cameraOptions = cameraOptionsBuilder.build(),
      textureView = textureView,
      styleUri = styleUri
    )
    val eventTypes = params["eventTypes"] as? List<String> ?: listOf()
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