package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.graphics.Bitmap
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
import com.mapbox.maps.mapbox_maps.pigeons.LogoSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.Projection
import com.mapbox.maps.mapbox_maps.pigeons.ScaleBarSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons.StyleManager
import com.mapbox.maps.mapbox_maps.pigeons._AnimationManager
import com.mapbox.maps.mapbox_maps.pigeons._CameraManager
import com.mapbox.maps.mapbox_maps.pigeons._LocationComponentSettingsInterface
import com.mapbox.maps.mapbox_maps.pigeons._MapInterface
import com.mapbox.maps.mapbox_maps.pigeons._ViewportMessenger
import com.mapbox.maps.plugin.animation.camera
import com.mapbox.maps.plugin.viewport.viewport
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.ByteArrayOutputStream

class MapboxMapController(
  context: Context,
  mapInitOptions: MapInitOptions,
  private val lifecycleProvider: MapboxMapsPlugin.LifecycleProvider,
  messenger: BinaryMessenger,
  channelSuffix: Long,
  pluginVersion: String,
  eventTypes: List<Long>
) : PlatformView,
  DefaultLifecycleObserver,
  MethodChannel.MethodCallHandler {

  private var mapView: MapView? = null
  private var mapboxMap: MapboxMap? = null

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
  private val logoController: LogoController
  private val attributionController: AttributionController
  private val scaleBarController: ScaleBarController
  private val compassController: CompassController
  private val viewportController: ViewportController

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

    val mapView = MapView(context, mapInitOptions)
    val mapboxMap = mapView.mapboxMap
    this.mapView = mapView
    this.mapboxMap = mapboxMap
    eventHandler = MapboxEventHandler(mapboxMap.styleManager, messenger, eventTypes, this.channelSuffix)
    styleController = StyleController(context, mapboxMap)
    cameraController = CameraController(mapboxMap, context)
    projectionController = MapProjectionController(mapboxMap)
    mapInterfaceController = MapInterfaceController(mapboxMap, mapView, context)
    animationController = AnimationController(mapboxMap, context)
    annotationController = AnnotationController(mapView)
    locationComponentController = LocationComponentController(mapView, context)
    gestureController = GestureController(mapView, context)
    logoController = LogoController(mapView)
    attributionController = AttributionController(mapView)
    scaleBarController = ScaleBarController(mapView)
    compassController = CompassController(mapView)
    viewportController = ViewportController(mapView.viewport, mapView.camera, context, mapboxMap)

    changeUserAgent(pluginVersion)

    StyleManager.setUp(messenger, styleController, this.channelSuffix)
    _CameraManager.setUp(messenger, cameraController, this.channelSuffix)
    Projection.setUp(messenger, projectionController, this.channelSuffix)
    _MapInterface.setUp(messenger, mapInterfaceController, this.channelSuffix)
    _AnimationManager.setUp(messenger, animationController, this.channelSuffix)
    annotationController.setup(messenger, this.channelSuffix)
    _LocationComponentSettingsInterface.setUp(messenger, locationComponentController, this.channelSuffix)
    LogoSettingsInterface.setUp(messenger, logoController, this.channelSuffix)
    GesturesSettingsInterface.setUp(messenger, gestureController, this.channelSuffix)
    AttributionSettingsInterface.setUp(messenger, attributionController, this.channelSuffix)
    ScaleBarSettingsInterface.setUp(messenger, scaleBarController, this.channelSuffix)
    CompassSettingsInterface.setUp(messenger, compassController, this.channelSuffix)
    _ViewportMessenger.setUp(messenger, viewportController, this.channelSuffix)

    methodChannel = MethodChannel(messenger, "plugins.flutter.io.$channelSuffix")
    methodChannel.setMethodCallHandler(this)
  }

  override fun getView(): View? {
    return mapView
  }

  override fun onFlutterViewAttached(flutterView: View) {
    super.onFlutterViewAttached(flutterView)
    val context = flutterView.context
    val shouldDestroyOnDestroy = when (context is FlutterActivity) {
      true -> context.shouldDestroyEngineWithHost()
      false -> true
    }
    lifecycleHelper = LifecycleHelper(lifecycleProvider.getLifecycle()!!, shouldDestroyOnDestroy)

    mapView?.setViewTreeLifecycleOwner(lifecycleHelper)
  }

  override fun onFlutterViewDetached() {
    super.onFlutterViewDetached()
    lifecycleHelper?.dispose()
    lifecycleHelper = null
    mapView!!.setViewTreeLifecycleOwner(null)
  }

  override fun dispose() {
    if (mapView == null) {
      return
    }
    lifecycleHelper?.dispose()
    lifecycleHelper = null
    mapView = null
    mapboxMap = null
    methodChannel.setMethodCallHandler(null)

    StyleManager.setUp(messenger, null, channelSuffix)
    _CameraManager.setUp(messenger, null, channelSuffix)
    Projection.setUp(messenger, null, channelSuffix)
    _MapInterface.setUp(messenger, null, channelSuffix)
    _AnimationManager.setUp(messenger, null, channelSuffix)
    annotationController.dispose(messenger, channelSuffix)
    _LocationComponentSettingsInterface.setUp(messenger, null, channelSuffix)
    LogoSettingsInterface.setUp(messenger, null, channelSuffix)
    GesturesSettingsInterface.setUp(messenger, null, channelSuffix)
    CompassSettingsInterface.setUp(messenger, null, channelSuffix)
    ScaleBarSettingsInterface.setUp(messenger, null, channelSuffix)
    AttributionSettingsInterface.setUp(messenger, null, channelSuffix)
    _ViewportMessenger.setUp(messenger, null, channelSuffix)
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
        gestureController.addListeners(messenger, channelSuffix)
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
      "map#snapshot" -> {
        val mapView = mapView
        val snapshot = mapView?.snapshot()
        if (mapView == null) {
          result.error("2342345", "Failed to create snapshot: map view is not found.", null)
        } else if (snapshot == null) {
          result.error("2342345", "Failed to create snapshot: snapshotting timed out.", null)
        } else {
          val byteArray = ByteArrayOutputStream().also { stream ->
            snapshot.compress(Bitmap.CompressFormat.PNG, 100, stream)
          }.toByteArray()

          result.success(byteArray)
        }
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