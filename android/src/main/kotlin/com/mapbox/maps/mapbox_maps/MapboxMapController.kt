package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.mapbox.common.*
import com.mapbox.maps.*
import com.mapbox.maps.mapbox_maps.annotation.AnnotationController
import com.mapbox.maps.pigeons.FLTMapInterfaces
import com.mapbox.maps.pigeons.FLTSettings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class MapboxMapController(
  context: Context,
  mapInitOptions: MapInitOptions,
  lifecycleProvider: MapboxMapsPlugin.LifecycleProvider,
  eventTypes: List<String>,
  private val messenger: BinaryMessenger,
  viewId: Int,
  pluginVersion: String
) : PlatformView,
  DefaultLifecycleObserver,
  MethodChannel.MethodCallHandler {

  private val mapView: MapView = MapView(context, mapInitOptions)
  private val mapboxMap: MapboxMap = mapView.getMapboxMap()
  private val methodChannel: MethodChannel
  private val styleController: StyleController = StyleController(mapboxMap)
  private val cameraController: CameraController = CameraController(mapboxMap)
  private val projectionController: MapProjectionController = MapProjectionController(mapboxMap)
  private val mapInterfaceController: MapInterfaceController = MapInterfaceController(mapboxMap)
  private val animationController: AnimationController = AnimationController(mapboxMap)
  private val annotationController: AnnotationController = AnnotationController(mapView, mapboxMap)
  private val locationComponentController = LocationComponentController(mapView)
  private val gestureController = GestureController(mapView)
  private val logoController = LogoController(mapView)
  private val attributionController = AttributionController(mapView)
  private val scaleBarController = ScaleBarController(mapView)
  private val compassController = CompassController(mapView)

  init {
    changeUserAgent(pluginVersion)
    lifecycleProvider.getLifecycle()?.addObserver(this)
    FLTMapInterfaces.StyleManager.setup(messenger, styleController)
    FLTMapInterfaces._CameraManager.setup(messenger, cameraController)
    FLTMapInterfaces.Projection.setup(messenger, projectionController)
    FLTMapInterfaces._MapInterface.setup(messenger, mapInterfaceController)
    FLTMapInterfaces._AnimationManager.setup(messenger, animationController)
    annotationController.setup(messenger)
    FLTSettings.LocationComponentSettingsInterface.setup(messenger, locationComponentController)
    FLTSettings.LogoSettingsInterface.setup(messenger, logoController)
    FLTSettings.GesturesSettingsInterface.setup(messenger, gestureController)
    FLTSettings.AttributionSettingsInterface.setup(messenger, attributionController)
    FLTSettings.ScaleBarSettingsInterface.setup(messenger, scaleBarController)
    FLTSettings.CompassSettingsInterface.setup(messenger, compassController)
    gestureController.setup(messenger)
    methodChannel = MethodChannel(messenger, "plugins.flutter.io/mapbox_maps_$viewId")
    methodChannel.setMethodCallHandler(this)
    mapboxMap.subscribe(
      { event ->
        methodChannel.invokeMethod(getEventMethodName(event.type), event.data.toJson())
      },
      eventTypes
    )
  }

  override fun getView(): View {
    return mapView
  }

  override fun dispose() {
    mapView.onStop()
    mapView.onDestroy()
    methodChannel.setMethodCallHandler(null)
    FLTMapInterfaces.StyleManager.setup(messenger, null)
    FLTMapInterfaces._CameraManager.setup(messenger, null)
    FLTMapInterfaces.Projection.setup(messenger, null)
    FLTMapInterfaces._MapInterface.setup(messenger, null)
    FLTMapInterfaces._AnimationManager.setup(messenger, null)
    annotationController.dispose(messenger)
    FLTSettings.LocationComponentSettingsInterface.setup(messenger, null)
    FLTSettings.LogoSettingsInterface.setup(messenger, null)
    FLTSettings.GesturesSettingsInterface.setup(messenger, null)
    FLTSettings.CompassSettingsInterface.setup(messenger, null)
    FLTSettings.ScaleBarSettingsInterface.setup(messenger, null)
    FLTSettings.AttributionSettingsInterface.setup(messenger, null)
  }

  override fun onStart(owner: LifecycleOwner) {
    super.onStart(owner)
    mapView.onStart()
  }

  override fun onStop(owner: LifecycleOwner) {
    super.onStop(owner)
    mapView.onStop()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "map#subscribe" -> {
        val eventType = call.argument<String>("event")!!
        mapboxMap.subscribe(
          { event ->
            methodChannel.invokeMethod(getEventMethodName(eventType), event.data.toJson())
          },
          listOf(eventType)
        )
      }
      "annotation#create_manager" -> {
        annotationController.handleCreateManager(call, result)
      }
      "annotation#remove_manager" -> {
        annotationController.handleRemoveManager(call, result)
      }
      else -> {
        println("OnMethodCall : ${call.method}")
        result.success(null)
      }
    }
  }

  private fun changeUserAgent(version: String) {
    HttpServiceFactory.getInstance().setInterceptor(
      object : HttpServiceInterceptorInterface {
        override fun onRequest(request: HttpRequest): HttpRequest {
          request.headers[HttpHeaders.USER_AGENT] = "${request.headers[HttpHeaders.USER_AGENT]} Flutter Plugin/$version"
          return request
        }

        override fun onDownload(download: DownloadOptions): DownloadOptions {
          return download
        }

        override fun onResponse(response: HttpResponse): HttpResponse {
          return response
        }
      }
    )
  }

  private fun getEventMethodName(eventType: String) = "event#$eventType"
}