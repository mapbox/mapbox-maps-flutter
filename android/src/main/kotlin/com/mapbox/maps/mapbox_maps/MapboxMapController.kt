package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.mapbox.maps.*
import com.mapbox.maps.mapbox_maps.annotation.AnnotationController
import com.mapbox.maps.pigeons.FLTMapboxMap
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
  viewId: Int
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
  private val logoController = LogoController(mapView)

  init {
    lifecycleProvider.getLifecycle()?.addObserver(this)
    FLTMapboxMap.StyleManager.setup(messenger, styleController)
    FLTMapboxMap._CameraManager.setup(messenger, cameraController)
    FLTMapboxMap.Projection.setup(messenger, projectionController)
    FLTMapboxMap._MapInterface.setup(messenger, mapInterfaceController)
    FLTMapboxMap._AnimationManager.setup(messenger, animationController)
    annotationController.setup(messenger)
    FLTSettings.LocationComponentSettingsInterface.setup(messenger, locationComponentController)
    FLTSettings.LogoSettingsInterface.setup(messenger, logoController)
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
    mapView.onDestroy()
    methodChannel.setMethodCallHandler(null)
    FLTMapboxMap.StyleManager.setup(messenger, null)
    FLTMapboxMap._CameraManager.setup(messenger, null)
    FLTMapboxMap.Projection.setup(messenger, null)
    FLTMapboxMap._MapInterface.setup(messenger, null)
    FLTMapboxMap._AnimationManager.setup(messenger, null)
    annotationController.dispose(messenger)
    FLTSettings.LocationComponentSettingsInterface.setup(messenger, null)
    FLTSettings.LogoSettingsInterface.setup(messenger, null)
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

  private fun getEventMethodName(eventType: String) = "event#$eventType"
}