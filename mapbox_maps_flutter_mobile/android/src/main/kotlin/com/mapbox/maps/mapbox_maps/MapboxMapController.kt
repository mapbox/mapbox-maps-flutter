package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.view.MotionEvent
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.setViewTreeLifecycleOwner
import com.mapbox.bindgen.Value
import com.mapbox.common.SettingsServiceFactory
import com.mapbox.common.SettingsServiceStorageType
import com.mapbox.maps.MapInitOptions
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.annotation.AnnotationController
import com.mapbox.maps.mapbox_maps.pigeons.AttributionSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.CompassSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.GesturesSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.IndoorSelectorSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.LogoSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.Projection
import com.mapbox.maps.mapbox_maps.pigeons.ScaleBarSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.StyleManager
import com.mapbox.maps.mapbox_maps.pigeons._AnimationManager
import com.mapbox.maps.mapbox_maps.pigeons._CameraManager
import com.mapbox.maps.mapbox_maps.pigeons._IndoorMessenger
import com.mapbox.maps.mapbox_maps.pigeons._LocationComponentSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons._MapInterface
import com.mapbox.maps.mapbox_maps.pigeons._MapRecorderMessenger
import com.mapbox.maps.mapbox_maps.pigeons._PerformanceStatisticsApi
import com.mapbox.maps.mapbox_maps.pigeons._ViewportMessenger
import com.mapbox.maps.plugin.animation.camera
import com.mapbox.maps.plugin.viewport.viewport
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FlutterMapView : MapView {
  constructor(context: Context, mapInitOptions: MapInitOptions) : super(context, mapInitOptions)
  constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

  @SuppressLint("ClickableViewAccessibility")
  override fun onTouchEvent(event: MotionEvent): Boolean {
    // Flutter can forward pointers with inconsistent ids, which makes the gesture detectors throw
    // (https://github.com/flutter/flutter/issues/195431). Drop the event; the detectors recover
    // on later events.
    return try {
      super.onTouchEvent(event)
    } catch (e: RuntimeException) {
      if (e !is IllegalArgumentException && e !is NullPointerException) throw e
      Log.w("FlutterMapView", "Ignoring inconsistent touch event: $e")
      false
    }
  }
}

class MapboxMapController(
  context: Context,
  mapInitOptions: MapInitOptions,
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider,
  messenger: BinaryMessenger,
  channelSuffix: Long,
  pluginVersion: String,
  eventTypes: List<Long>,
  externalMapView: MapView? = null
) : PlatformView,
  DefaultLifecycleObserver,
  MethodChannel.MethodCallHandler {

  private var mapView: MapView? = null
  private var mapboxMap: MapboxMap? = null
  private val ownsMapView: Boolean

  private val methodChannel: MethodChannel
  private val messenger: BinaryMessenger
  private val channelSuffix: String

  private val styleController: StyleController
  private val cameraController: CameraController
  private val projectionController: MapProjectionController
  private val mapInterfaceController: MapInterfaceController
  private val animationController: AnimationController
  private val annotationController: AnnotationController
  private val locationComponentController: LocationComponentController
  private val gestureController: GestureController
  private val interactionsController: InteractionsController
  private val logoController: LogoController
  private val attributionController: AttributionController
  private val scaleBarController: ScaleBarController
  private val compassController: CompassController
  private val indoorSelectorController: IndoorSelectorController
  private val indoorController: IndoorController
  private val viewportController: ViewportController
  private val performanceStatisticsController: PerformanceStatisticsController
  private val mapRecorderController: MapRecorderController

  private val eventHandler: MapboxEventHandler

  /*
    Mirrors lifecycle of the parent, with one addition - switches to DESTROYED state
    when `dispose` is called.
    `parentLifecycle` is the lifecycle of the Flutter activity, which may live much longer then
    the MapView attached.
  */
  private class LifecycleHelper(
    val parentLifecycle: Lifecycle,
    val shouldDestroyOnDestroy: Boolean,
  ) : LifecycleOwner, DefaultLifecycleObserver {

    val lifecycleRegistry: LifecycleRegistry = LifecycleRegistry(this)

    init {
      parentLifecycle.addObserver(this)
    }

    override val lifecycle: Lifecycle
      get() = lifecycleRegistry

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

    override fun onDestroy(owner: LifecycleOwner) = propagateDestroyEvent()

    fun dispose() {
      parentLifecycle.removeObserver(this)
      propagateDestroyEvent()
    }

    private fun propagateDestroyEvent() {
      lifecycleRegistry.currentState = when (shouldDestroyOnDestroy) {
        true -> Lifecycle.State.DESTROYED
        false -> Lifecycle.State.CREATED
      }
    }
  }

  private var lifecycleHelper: LifecycleHelper? = null

  init {
    this.messenger = messenger
    this.channelSuffix = channelSuffix.toString()

    val mapView = externalMapView ?: FlutterMapView(context, mapInitOptions)
    ownsMapView = externalMapView == null
    val mapboxMap = mapView.mapboxMap
    this.mapView = mapView
    this.mapboxMap = mapboxMap
    eventHandler = MapboxEventHandler(mapboxMap.styleManager, messenger, eventTypes, this.channelSuffix)
    styleController = StyleController(context, mapboxMap)
    cameraController = CameraController(mapboxMap, context)
    projectionController = MapProjectionController(mapboxMap)
    mapInterfaceController = MapInterfaceController(mapboxMap, mapView, context)
    animationController = AnimationController(mapboxMap, context)
    annotationController = AnnotationController(mapView, messenger, this.channelSuffix)
    locationComponentController = LocationComponentController(mapView, context)
    gestureController = GestureController(mapView, context, messenger, this.channelSuffix)
    interactionsController = InteractionsController(mapboxMap, context)
    logoController = LogoController(mapView)
    attributionController = AttributionController(mapView)
    scaleBarController = ScaleBarController(mapView)
    compassController = CompassController(mapView)
    indoorSelectorController = IndoorSelectorController(mapView)
    indoorController = IndoorController(mapboxMap, messenger, this.channelSuffix)
    viewportController = ViewportController(mapView.viewport, mapView.camera, context, mapboxMap)
    performanceStatisticsController = PerformanceStatisticsController(mapboxMap, this.messenger, this.channelSuffix)
    mapRecorderController = MapRecorderController(mapboxMap)
    changeUserAgent(pluginVersion)

    StyleManager.setUp(messenger, styleController, this.channelSuffix)
    _CameraManager.setUp(messenger, cameraController, this.channelSuffix)
    Projection.setUp(messenger, projectionController, this.channelSuffix)
    _MapInterface.setUp(messenger, mapInterfaceController, this.channelSuffix)
    _AnimationManager.setUp(messenger, animationController, this.channelSuffix)
    annotationController.setup()
    _LocationComponentSettingsInterface.setUp(messenger, locationComponentController, this.channelSuffix)
    LogoSettingsInterface.setUp(messenger, logoController, this.channelSuffix)
    GesturesSettingsInterface.setUp(messenger, gestureController, this.channelSuffix)
    AttributionSettingsInterface.setUp(messenger, attributionController, this.channelSuffix)
    ScaleBarSettingsInterface.setUp(messenger, scaleBarController, this.channelSuffix)
    CompassSettingsInterface.setUp(messenger, compassController, this.channelSuffix)
    IndoorSelectorSettingsInterface.setUp(messenger, indoorSelectorController, this.channelSuffix)
    _IndoorMessenger.setUp(messenger, indoorController, this.channelSuffix)
    _ViewportMessenger.setUp(messenger, viewportController, this.channelSuffix)
    _PerformanceStatisticsApi.setUp(messenger, performanceStatisticsController, this.channelSuffix)
    _MapRecorderMessenger.setUp(messenger, mapRecorderController, this.channelSuffix)

    methodChannel = MethodChannel(messenger, "plugins.flutter.io.$channelSuffix")
    methodChannel.setMethodCallHandler(this)
    methodChannel.invokeMethod("mapView#onMapCreated", null)
  }

  override fun getView(): View? {
    return mapView
  }

  private var onFlutterViewAttachedCalled = false
  override fun onFlutterViewAttached(flutterView: View) {
    super.onFlutterViewAttached(flutterView)

    if (onFlutterViewAttachedCalled) {
      return
    }

    onFlutterViewAttachedCalled = true

    if (ownsMapView) {
      val context = flutterView.context
      val shouldDestroyOnDestroy = when (context is FlutterActivity) {
        true -> context.shouldDestroyEngineWithHost()
        false -> true
      }
      lifecycleHelper = LifecycleHelper(lifecycleProvider.getLifecycle()!!, shouldDestroyOnDestroy)

      mapView?.setViewTreeLifecycleOwner(lifecycleHelper)
    }
  }

  override fun onFlutterViewDetached() {
    super.onFlutterViewDetached()

    onFlutterViewAttachedCalled = false

    if (ownsMapView) {
      lifecycleHelper?.dispose()
      lifecycleHelper = null
      mapView?.setViewTreeLifecycleOwner(null)
    }
  }

  override fun dispose() {
    if (mapView == null) {
      return
    }

    eventHandler.dispose()
    lifecycleHelper?.dispose()
    lifecycleHelper = null
    if (ownsMapView) {
      mapView?.setViewTreeLifecycleOwner(null)
    }
    mapView = null
    mapboxMap = null
    methodChannel.setMethodCallHandler(null)

    StyleManager.setUp(messenger, null, channelSuffix)
    _CameraManager.setUp(messenger, null, channelSuffix)
    Projection.setUp(messenger, null, channelSuffix)
    _MapInterface.setUp(messenger, null, channelSuffix)
    _AnimationManager.setUp(messenger, null, channelSuffix)
    annotationController.dispose()
    _LocationComponentSettingsInterface.setUp(messenger, null, channelSuffix)
    LogoSettingsInterface.setUp(messenger, null, channelSuffix)
    GesturesSettingsInterface.setUp(messenger, null, channelSuffix)
    CompassSettingsInterface.setUp(messenger, null, channelSuffix)
    IndoorSelectorSettingsInterface.setUp(messenger, null, channelSuffix)
    _IndoorMessenger.setUp(messenger, null, channelSuffix)
    indoorController.dispose()
    ScaleBarSettingsInterface.setUp(messenger, null, channelSuffix)
    AttributionSettingsInterface.setUp(messenger, null, channelSuffix)
    _ViewportMessenger.setUp(messenger, null, channelSuffix)
    _PerformanceStatisticsApi.setUp(messenger, null, channelSuffix)
    _MapRecorderMessenger.setUp(messenger, null, channelSuffix)
    mapRecorderController.dispose()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "annotation#create_manager" -> {
        annotationController.handleCreateManager(call, result)
      }
      "annotation#remove_manager" -> {
        annotationController.handleRemoveManager(call, result)
      }
      "interactions#add_interaction" -> {
        interactionsController.addInteraction(messenger, channelSuffix, call)
        result.success(null)
      }
      "interactions#remove_interaction" -> {
        interactionsController.removeInteraction(call)
        result.success(null)
      }
      "platform#releaseMethodChannels" -> {
        dispose()
        result.success(null)
      }
      "mapView#submitViewSizeHint" -> {
        result.success(null) // no-op on this platform
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun changeUserAgent(version: String) {
    SettingsServiceFactory.getInstance(SettingsServiceStorageType.NON_PERSISTENT)
      .set("com.mapbox.common.telemetry.internal.custom_user_agent_fragment", Value.valueOf("FlutterPlugin/$version"))
  }
}