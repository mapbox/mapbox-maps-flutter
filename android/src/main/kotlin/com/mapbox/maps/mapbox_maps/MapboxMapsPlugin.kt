package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import android.opengl.EGLSurface
import android.opengl.GLES20
import android.os.Handler
import android.os.HandlerThread
import android.os.Process.THREAD_PRIORITY_DISPLAY
import android.util.Log
import android.view.Choreographer
import androidx.lifecycle.Lifecycle
import com.mapbox.bindgen.Value
import com.mapbox.geojson.Point
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.Map
import com.mapbox.maps.MapClient
import com.mapbox.maps.MapLoaded
import com.mapbox.maps.MapLoadedCallback
import com.mapbox.maps.MapLoadingErrorCallback
import com.mapbox.maps.MapOptions
import com.mapbox.maps.Size
import com.mapbox.maps.Style
import com.mapbox.maps.applyDefaultParams
import com.mapbox.maps.logD
import com.mapbox.maps.mapbox_maps.offline.OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.offline.OfflineSwitch
import com.mapbox.maps.mapbox_maps.pigeons._MapboxMapsOptions
import com.mapbox.maps.mapbox_maps.pigeons._MapboxOptions
import com.mapbox.maps.mapbox_maps.pigeons._OfflineMapInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._OfflineSwitch
import com.mapbox.maps.mapbox_maps.pigeons._SnapshotterInstanceManager
import com.mapbox.maps.mapbox_maps.pigeons._TileStoreInstanceManager
import com.mapbox.maps.mapbox_maps.snapshot.SnapshotterInstanceManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry.SurfaceProducer

/** MapboxMapsPlugin */
class MapboxMapsPlugin : FlutterPlugin, ActivityAware {
  private var lifecycle: Lifecycle? = null

  companion object {
    var mapController: MapController? = null
    var methodChannel: MethodChannel? = null
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        "plugins.flutter.io/mapbox_maps",
        MapboxMapFactory(
          flutterPluginBinding.binaryMessenger,
          flutterPluginBinding.flutterAssets,
          object : LifecycleProvider {
            override fun getLifecycle(): Lifecycle? {
              return lifecycle
            }
          }
        )
      )
    setupStaticChannels(
      flutterPluginBinding.applicationContext,
      flutterPluginBinding.binaryMessenger,
      flutterPluginBinding.flutterAssets
    )

    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "mapbox_maps/texture")
    methodChannel?.setMethodCallHandler { call, result ->
      if (call.method == "getTextureId") {
        val width = call.argument<Double>("width")
        val height = call.argument<Double>("height")
        val size = Size(width!!.toFloat(), height!!.toFloat())
        val producer = flutterPluginBinding.textureRegistry.createSurfaceProducer()
        mapController = MapController(producer, flutterPluginBinding.applicationContext, size, )
        result.success(producer.id())
      }
    }
  }

  private fun setupStaticChannels(
    context: Context,
    binaryMessenger: BinaryMessenger,
    flutterAssets: FlutterAssets
  ) {
    val optionsController = MapboxOptionsController(flutterAssets)
    val snapshotterInstanceManager = SnapshotterInstanceManager(context, binaryMessenger)
    val offlineMapInstanceManager = OfflineMapInstanceManager(context, binaryMessenger)
    val offlineSwitch = OfflineSwitch()
    // static options handling should be setup upon attachment,
    // as options can before configured before the map view is setup
    _MapboxMapsOptions.setUp(binaryMessenger, optionsController)
    _MapboxOptions.setUp(binaryMessenger, optionsController)
    _SnapshotterInstanceManager.setUp(binaryMessenger, snapshotterInstanceManager)
    _OfflineMapInstanceManager.setUp(binaryMessenger, offlineMapInstanceManager)
    _TileStoreInstanceManager.setUp(binaryMessenger, offlineMapInstanceManager)
    _OfflineSwitch.setUp(binaryMessenger, offlineSwitch)
    LoggingController.setup(binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    lifecycle = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
  }

  override fun onDetachedFromActivity() {
    lifecycle = null
  }

  interface LifecycleProvider {
    fun getLifecycle(): Lifecycle?
  }
}

@SuppressLint("RestrictedApi")
class MapController(
  private val surfaceProducer: SurfaceProducer,
  private val context: Context,
  private val size: Size
) : SurfaceProducer.Callback,
  MapClient, Choreographer.FrameCallback {
  private var map: Map? = null
  private var needsRepaint = false
  private val eglCore: EGLCore
  private var eglSurface: EGLSurface
  private val renderThread: HandlerThread
  private val handler: Handler
  private var step = 0

  init {
    renderThread = HandlerThread("RenderThread", THREAD_PRIORITY_DISPLAY)
    surfaceProducer.setSize(size.width.toInt(), size.height.toInt())
    surfaceProducer.setCallback(this)
    eglCore = EGLCore(false, 1, mapName = "sfsfs")
    eglSurface = eglCore.eglNoSurface
    map = createMap()
    renderThread.start()
    handler = Handler(renderThread.looper)
    handler.post {
      setupOpenGL()
      map?.createRenderer()
      Choreographer.getInstance().postFrameCallback(this)
    }
  }

  private fun createMap(): Map {
    val options = MapOptions.Builder()
      .applyDefaultParams(context)
      .size(size)
      .pixelRatio(1f)
      .build()
    val map = Map(this, options)

    map.subscribe(MapLoadedCallback {
      logD("kkk","Map loaded $it")
    })
    map.subscribe(MapLoadingErrorCallback {
      logD("kkk","Map Loading error $it")
    })
    map.styleURI = Style.STANDARD
    map.setCamera(
      CameraOptions.Builder()
        .center(Point.fromLngLat(0.0, 0.0))
        .zoom(2.0)
        .build()
    )
    map.setStyleProjection(Value.valueOf(hashMapOf("name" to Value.valueOf("globe"))))

    return map
  }

  private fun setupOpenGL() {
    val surface = surfaceProducer.surface
    if (!eglCore.prepareEgl()) {
      throw IllegalStateException("OpenGL ES 3.0 context could not be created")
    }
    if (!surface.isValid) {
      throw IllegalStateException("Invalid surface")
    }
    eglSurface = eglCore.createWindowSurface(surface)
    if (eglSurface == eglCore.eglNoSurface) {
      throw IllegalStateException("Surface was null")
    }
    if (!eglCore.makeCurrent(eglSurface)) {
      throw IllegalStateException("eglMakeCurrent failed")
    }
  }

  override fun onSurfaceCreated() {
    map = createMap()
  }

  override fun onSurfaceDestroyed() {
    map?.reduceMemoryUse()
    map?.destroyRenderer()
    map = null
  }

  override fun scheduleRepaint() {
    needsRepaint = true
  }

  override fun doFrame(frameTimeNanos: Long) {
    Choreographer.getInstance().postFrameCallback(this)

    if (!needsRepaint) {
      return
    }

    needsRepaint = false

    map?.render()

    eglCore.swapBuffers(eglSurface)

    map?.setCamera(
      CameraOptions.Builder()
        .center(Point.fromLngLat(getCycleValue(step), 0.0))
        .zoom(1.0)
        .build()
    )
    step = step + 1
  }
}

fun getCycleValue(step: Int): Double {
  val totalRange = 361 // total numbers from -180 to 180
  val normalizedStep = step % totalRange
  return if (normalizedStep <= 180) {
    (-180 + normalizedStep).toDouble()
  } else {
    (180 - (normalizedStep - 180)).toDouble()
  }
}

