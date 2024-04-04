package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import com.google.gson.TypeAdapter
import com.google.gson.TypeAdapterFactory
import com.google.gson.reflect.TypeToken
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter
import com.mapbox.common.*
import com.mapbox.maps.MapInitOptions
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.annotation.AnnotationController
import com.mapbox.maps.mapbox_maps.pigeons.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.reflect.Type
import java.util.Date

class MapboxMapController(
  context: Context,
  mapInitOptions: MapInitOptions,
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider,
  eventTypes: List<Int>,
  messenger: BinaryMessenger,
  channelSuffix: Int,
  pluginVersion: String
) : PlatformView,
  DefaultLifecycleObserver,
  MethodChannel.MethodCallHandler {

  private val mapView: MapView = MapView(context, mapInitOptions)
  private val mapboxMap: MapboxMap = mapView.mapboxMap
  private val methodChannel: MethodChannel
  private val styleController: StyleController = StyleController(mapboxMap, context)
  private val cameraController: CameraController = CameraController(mapboxMap, context)
  private val projectionController: MapProjectionController = MapProjectionController(mapboxMap)
  private val mapInterfaceController: MapInterfaceController = MapInterfaceController(mapboxMap, context)
  private val animationController: AnimationController = AnimationController(mapboxMap, context)
  private val annotationController: AnnotationController = AnnotationController(mapView)
  private val locationComponentController = LocationComponentController(mapView, context)
  private val gestureController = GestureController(mapView)
  private val logoController = LogoController(mapView)
  private val attributionController = AttributionController(mapView)
  private val scaleBarController = ScaleBarController(mapView)
  private val compassController = CompassController(mapView)

  private val proxyBinaryMessenger = ProxyBinaryMessenger(messenger, "/map_$channelSuffix")
  private val gson = GsonBuilder()
    .registerTypeAdapter(Date::class.java, MicrosecondsDateTypeAdapter)
    .registerTypeAdapterFactory(EnumOrdinalTypeAdapterFactory)
    .create()
  init {
    changeUserAgent(pluginVersion)
    lifecycleProvider.getLifecycle()?.addObserver(this)
    StyleManager.setUp(proxyBinaryMessenger, styleController)
    _CameraManager.setUp(proxyBinaryMessenger, cameraController)
    Projection.setUp(proxyBinaryMessenger, projectionController)
    _MapInterface.setUp(proxyBinaryMessenger, mapInterfaceController)
    _AnimationManager.setUp(proxyBinaryMessenger, animationController)
    annotationController.setup(proxyBinaryMessenger)
    _LocationComponentSettingsInterface.setUp(proxyBinaryMessenger, locationComponentController)
    LogoSettingsInterface.setUp(proxyBinaryMessenger, logoController)
    GesturesSettingsInterface.setUp(proxyBinaryMessenger, gestureController)
    AttributionSettingsInterface.setUp(proxyBinaryMessenger, attributionController)
    ScaleBarSettingsInterface.setUp(proxyBinaryMessenger, scaleBarController)
    CompassSettingsInterface.setUp(proxyBinaryMessenger, compassController)

    methodChannel = MethodChannel(proxyBinaryMessenger, "plugins.flutter.io")
    methodChannel.setMethodCallHandler(this)

    // TODO: check if state-triggered subscription change does not lead to multiple subscriptions/not unsubscribing when listener becomes null
    for (event in eventTypes) {
      subscribeToEvent(_MapEvent.values()[event])
    }
  }

  private fun subscribeToEvent(event: _MapEvent) {
    when (event) {
      _MapEvent.MAP_LOADED -> mapboxMap.subscribeMapLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.MAP_LOADING_ERROR -> mapboxMap.subscribeMapLoadingError {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_LOADED -> mapboxMap.subscribeStyleLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_DATA_LOADED -> mapboxMap.subscribeStyleDataLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.CAMERA_CHANGED -> mapboxMap.subscribeCameraChanged {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.MAP_IDLE -> mapboxMap.subscribeMapIdle {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_ADDED -> mapboxMap.subscribeSourceAdded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_REMOVED -> mapboxMap.subscribeSourceRemoved {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_DATA_LOADED -> mapboxMap.subscribeSourceDataLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_IMAGE_MISSING -> mapboxMap.subscribeStyleImageMissing {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_IMAGE_REMOVE_UNUSED -> mapboxMap.subscribeStyleImageRemoveUnused {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RENDER_FRAME_STARTED -> mapboxMap.subscribeRenderFrameStarted {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RENDER_FRAME_FINISHED -> mapboxMap.subscribeRenderFrameFinished {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RESOURCE_REQUEST -> mapboxMap.subscribeResourceRequest {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
    }
  }

  override fun getView(): View {
    return mapView
  }

  override fun dispose() { }

  private fun releaseMethodChannels() {
    lifecycleProvider.getLifecycle()?.removeObserver(this)
    mapView.onStop()
    mapView.onDestroy()
    methodChannel.setMethodCallHandler(null)
    StyleManager.setUp(proxyBinaryMessenger, null)
    _CameraManager.setUp(proxyBinaryMessenger, null)
    Projection.setUp(proxyBinaryMessenger, null)
    _MapInterface.setUp(proxyBinaryMessenger, null)
    _AnimationManager.setUp(proxyBinaryMessenger, null)
    annotationController.dispose(proxyBinaryMessenger)
    _LocationComponentSettingsInterface.setUp(proxyBinaryMessenger, null)
    LogoSettingsInterface.setUp(proxyBinaryMessenger, null)
    GesturesSettingsInterface.setUp(proxyBinaryMessenger, null)
    CompassSettingsInterface.setUp(proxyBinaryMessenger, null)
    ScaleBarSettingsInterface.setUp(proxyBinaryMessenger, null)
    AttributionSettingsInterface.setUp(proxyBinaryMessenger, null)
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
      "platform#releaseMethodChannels" -> {
        releaseMethodChannels()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun changeUserAgent(version: String) {
    HttpServiceFactory.setHttpServiceInterceptor(
      object : HttpServiceInterceptorInterface {
        override fun onRequest(
          request: HttpRequest,
          continuation: HttpServiceInterceptorRequestContinuation
        ) {
          request.headers["user-agent"] = "${request.headers["user-agent"]} Flutter Plugin/$version"
          continuation.run(HttpRequestOrResponse(request))
        }

        override fun onResponse(
          response: HttpResponse,
          continuation: HttpServiceInterceptorResponseContinuation
        ) {
          continuation.run(response)
        }
      }
    )
  }
}

private val _MapEvent.methodName: String
  get() = "event#$ordinal"

object MicrosecondsDateTypeAdapter : JsonSerializer<Date> {
  override fun serialize(
    src: Date,
    typeOfSrc: Type?,
    context: JsonSerializationContext?
  ): JsonElement {
    return JsonPrimitive(src.time * 1000)
  }
}

class EnumOrdinalTypeAdapter<T>() : TypeAdapter<T>() {
  override fun write(out: JsonWriter?, value: T) {
    out?.value((value as Enum<*>).ordinal)
  }
  override fun read(`in`: JsonReader?): T {
    throw NotImplementedError("Not supported")
  }
}

object EnumOrdinalTypeAdapterFactory : TypeAdapterFactory {
  override fun <T : Any?> create(gson: Gson?, type: TypeToken<T>?): TypeAdapter<T>? {
    if (type == null || !type.rawType.isEnum) {
      return null
    }

    return EnumOrdinalTypeAdapter()
  }
}