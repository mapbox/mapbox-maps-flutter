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
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider,
  eventTypes: List<String>,
  messenger: BinaryMessenger,
  channelSuffix: Int,
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

  private val proxyBinaryMessenger = ProxyBinaryMessenger(messenger, "/map_$channelSuffix")

  init {
    changeUserAgent(pluginVersion)
    lifecycleProvider.getLifecycle()?.addObserver(this)
    FLTMapInterfaces.StyleManager.setup(proxyBinaryMessenger, styleController)
    FLTMapInterfaces._CameraManager.setup(proxyBinaryMessenger, cameraController)
    FLTMapInterfaces.Projection.setup(proxyBinaryMessenger, projectionController)
    FLTMapInterfaces._MapInterface.setup(proxyBinaryMessenger, mapInterfaceController)
    FLTMapInterfaces._AnimationManager.setup(proxyBinaryMessenger, animationController)
    annotationController.setup(proxyBinaryMessenger)
    FLTSettings.LocationComponentSettingsInterface.setup(proxyBinaryMessenger, locationComponentController)
    FLTSettings.LogoSettingsInterface.setup(proxyBinaryMessenger, logoController)
    FLTSettings.GesturesSettingsInterface.setup(proxyBinaryMessenger, gestureController)
    FLTSettings.AttributionSettingsInterface.setup(proxyBinaryMessenger, attributionController)
    FLTSettings.ScaleBarSettingsInterface.setup(proxyBinaryMessenger, scaleBarController)
    FLTSettings.CompassSettingsInterface.setup(proxyBinaryMessenger, compassController)
    methodChannel = MethodChannel(proxyBinaryMessenger, "plugins.flutter.io")
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
    lifecycleProvider.getLifecycle()?.removeObserver(this)
    mapView.onStop()
    mapView.onDestroy()
    methodChannel.setMethodCallHandler(null)
    FLTMapInterfaces.StyleManager.setup(proxyBinaryMessenger, null)
    FLTMapInterfaces._CameraManager.setup(proxyBinaryMessenger, null)
    FLTMapInterfaces.Projection.setup(proxyBinaryMessenger, null)
    FLTMapInterfaces._MapInterface.setup(proxyBinaryMessenger, null)
    FLTMapInterfaces._AnimationManager.setup(proxyBinaryMessenger, null)
    annotationController.dispose(proxyBinaryMessenger)
    FLTSettings.LocationComponentSettingsInterface.setup(proxyBinaryMessenger, null)
    FLTSettings.LogoSettingsInterface.setup(proxyBinaryMessenger, null)
    FLTSettings.GesturesSettingsInterface.setup(proxyBinaryMessenger, null)
    FLTSettings.CompassSettingsInterface.setup(proxyBinaryMessenger, null)
    FLTSettings.ScaleBarSettingsInterface.setup(proxyBinaryMessenger, null)
    FLTSettings.AttributionSettingsInterface.setup(proxyBinaryMessenger, null)
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
        result.success(null)
      }
      "annotation#create_manager" -> {
        annotationController.handleCreateManager(call, result)
      }
      "annotation#remove_manager" -> {
        annotationController.handleRemoveManager(call, result)
      }
      "gesture#add_listeners" -> {
        gestureController.addListeners(proxyBinaryMessenger)
        result.success(null)
      }
      "gesture#remove_listeners" -> {
        gestureController.removeListeners()
        result.success(null)
      }
      else -> {
        result.notImplemented()
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