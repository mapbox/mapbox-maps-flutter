package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.ViewTreeLifecycleOwner
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

  private var mapView: MapView? = null
  private var mapboxMap: MapboxMap? = null
  private val methodChannel: MethodChannel
  private val styleController: StyleController
  private val cameraController: CameraController
  private val projectionController: MapProjectionController
  private val mapInterfaceController: MapInterfaceController
  private val animationController: AnimationController
  private val annotationController: AnnotationController
  private val locationComponentController: LocationComponentController
  private val gestureController: GestureController
  private val logoController: LogoController
  private val attributionController: AttributionController
  private val scaleBarController: ScaleBarController
  private val compassController: CompassController

  private val proxyBinaryMessenger = ProxyBinaryMessenger(messenger, "/map_$channelSuffix")
  private val gson = GsonBuilder()
    .registerTypeAdapter(Date::class.java, MicrosecondsDateTypeAdapter)
    .registerTypeAdapterFactory(EnumOrdinalTypeAdapterFactory)
    .create()

  /*
    Mirrors lifecycle of the parent, with one addition - switches to DESTROYED state
    when `dispose` is called.
    `parentLifecycle` is the lifecycle of the Flutter activity, which may live much longer then
    the MapView attached.
  */
  private class LifecycleHelper(
    val parentLifecycle: Lifecycle,
  ) : LifecycleOwner, DefaultLifecycleObserver {

    val lifecycleRegistry: LifecycleRegistry = LifecycleRegistry(this)

    init {
      parentLifecycle.addObserver(this)
    }

    override fun getLifecycle(): Lifecycle {
      return lifecycleRegistry
    }

    override fun onCreate(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.CREATED
    }

    override fun onStart(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.STARTED
    }

    override fun onResume(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.RESUMED
    }

    override fun onPause(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.STARTED
    }

    override fun onStop(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.CREATED
    }

    override fun onDestroy(owner: LifecycleOwner) {
      lifecycleRegistry.currentState = Lifecycle.State.DESTROYED
    }

    fun dispose() {
      parentLifecycle.removeObserver(this)
      // fires MapView.onStop
      lifecycleRegistry.currentState = Lifecycle.State.CREATED
      // fires MapView.onDestroy
      lifecycleRegistry.currentState = Lifecycle.State.DESTROYED
    }
  }

  private val lifecycleHelper: LifecycleHelper

  init {
    val mapView = MapView(context, mapInitOptions)
    val mapboxMap = mapView.mapboxMap
    this.mapView = mapView
    this.mapboxMap = mapboxMap
    styleController = StyleController(mapboxMap, context)
    cameraController = CameraController(mapboxMap, context)
    projectionController = MapProjectionController(mapboxMap)
    mapInterfaceController = MapInterfaceController(mapboxMap, context)
    animationController = AnimationController(mapboxMap, context)
    annotationController = AnnotationController(mapView)
    locationComponentController = LocationComponentController(mapView, context)
    gestureController = GestureController(mapView)
    logoController = LogoController(mapView)
    attributionController = AttributionController(mapView)
    scaleBarController = ScaleBarController(mapView)
    compassController = CompassController(mapView)

    changeUserAgent(pluginVersion)

    lifecycleHelper = LifecycleHelper(lifecycleProvider.getLifecycle()!!)
    ViewTreeLifecycleOwner.set(mapView, lifecycleHelper)

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
      mapboxMap.subscribeToEvent(_MapEvent.values()[event])
    }
  }

  private fun MapboxMap.subscribeToEvent(event: _MapEvent) {
    when (event) {
      _MapEvent.MAP_LOADED -> subscribeMapLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.MAP_LOADING_ERROR -> subscribeMapLoadingError {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_LOADED -> subscribeStyleLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_DATA_LOADED -> subscribeStyleDataLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.CAMERA_CHANGED -> subscribeCameraChanged {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.MAP_IDLE -> subscribeMapIdle {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_ADDED -> subscribeSourceAdded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_REMOVED -> subscribeSourceRemoved {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.SOURCE_DATA_LOADED -> subscribeSourceDataLoaded {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_IMAGE_MISSING -> subscribeStyleImageMissing {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.STYLE_IMAGE_REMOVE_UNUSED -> subscribeStyleImageRemoveUnused {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RENDER_FRAME_STARTED -> subscribeRenderFrameStarted {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RENDER_FRAME_FINISHED -> subscribeRenderFrameFinished {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
      _MapEvent.RESOURCE_REQUEST -> subscribeResourceRequest {
        methodChannel.invokeMethod(event.methodName, gson.toJson(it))
      }
    }
  }

  override fun getView(): View? {
    return mapView
  }

  override fun dispose() {
    if (mapView == null) {
      return
    }
    lifecycleHelper.dispose()
    mapView = null
    mapboxMap = null
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
        dispose()
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