package com.mapbox.maps.mapbox_maps

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.content.Context
import android.view.animation.PathInterpolator
import com.google.gson.GsonBuilder
import com.mapbox.common.Cancelable
import com.mapbox.geojson.Polygon
import com.mapbox.geojson.gson.GeoJsonAdapterFactory
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.ScreenCoordinate
import com.mapbox.maps.logE
import com.mapbox.maps.mapbox_maps.pigeons._DefaultViewportTransitionOptions
import com.mapbox.maps.mapbox_maps.pigeons._EasingViewportTransitionOptions
import com.mapbox.maps.mapbox_maps.pigeons._FlyViewportTransitionOptions
import com.mapbox.maps.mapbox_maps.pigeons._FollowPuckViewportStateBearing
import com.mapbox.maps.mapbox_maps.pigeons._FollowPuckViewportStateOptions
import com.mapbox.maps.mapbox_maps.pigeons._OverviewViewportStateOptions
import com.mapbox.maps.mapbox_maps.pigeons._ViewportMessenger
import com.mapbox.maps.mapbox_maps.pigeons._ViewportStateStorage
import com.mapbox.maps.mapbox_maps.pigeons._ViewportStateType
import com.mapbox.maps.mapbox_maps.pigeons._ViewportTransitionStorage
import com.mapbox.maps.mapbox_maps.pigeons._ViewportTransitionType
import com.mapbox.maps.plugin.animation.CameraAnimationsPlugin
import com.mapbox.maps.plugin.animation.MapAnimationOptions
import com.mapbox.maps.plugin.viewport.CompletionListener
import com.mapbox.maps.plugin.viewport.ViewportPlugin
import com.mapbox.maps.plugin.viewport.data.DefaultViewportTransitionOptions
import com.mapbox.maps.plugin.viewport.data.FollowPuckViewportStateBearing
import com.mapbox.maps.plugin.viewport.data.FollowPuckViewportStateOptions
import com.mapbox.maps.plugin.viewport.data.OverviewViewportStateOptions
import com.mapbox.maps.plugin.viewport.state.ViewportState
import com.mapbox.maps.plugin.viewport.transition.ViewportTransition

class ViewportController(
  private val viewportPlugin: ViewportPlugin,
  private val cameraPlugin: CameraAnimationsPlugin,
  private val context: Context
) : _ViewportMessenger {

  override fun transition(
    stateStorage: _ViewportStateStorage,
    transitionStorage: _ViewportTransitionStorage?,
    callback: (Result<Boolean>) -> Unit
  ) {
    val state = viewportPlugin.viewportStateFromFLTState(stateStorage, context)
    if (state == null) {
      logE("Viewport", "Could not create viewport state ouf of options: $stateStorage")
      return
    }
    val transition = viewportPlugin.transitionFromFLTTransition(transitionStorage, cameraPlugin)
    viewportPlugin.transitionTo(state, transition) { success ->
      callback(Result.success(success))
    }
  }
}

fun ViewportPlugin.transitionFromFLTTransition(transitionStorage: _ViewportTransitionStorage?, cameraPlugin: CameraAnimationsPlugin): ViewportTransition {
  return when (transitionStorage?.type) {
    _ViewportTransitionType.DEFAULT_TRANSITION ->
      (transitionStorage.options as? _DefaultViewportTransitionOptions)
        ?.let { makeDefaultViewportTransition(it.toOptions()) }
    _ViewportTransitionType.FLY ->
      (transitionStorage.options as? _FlyViewportTransitionOptions)
        ?.let {
          GenericViewportTransition { cameraOptions, completion ->
            val options = MapAnimationOptions.Builder()
            if (it.durationMs != null) {
              options.duration(it.durationMs)
            }
            cameraPlugin.flyTo(
              cameraOptions, options.build(),
              object : AnimatorListenerAdapter() {
                override fun onAnimationEnd(animation: Animator) { completion.onComplete(true) }
                override fun onAnimationCancel(animation: Animator) { completion.onComplete(false) }
              }
            )
          }
        }
    _ViewportTransitionType.EASING ->
      (transitionStorage.options as? _EasingViewportTransitionOptions)
        ?.let {
          GenericViewportTransition { cameraOptions, completion ->
            val options = MapAnimationOptions.Builder()
              .duration(it.durationMs)
              .interpolator(PathInterpolator(it.a.toFloat(), it.b.toFloat(), it.c.toFloat(), it.d.toFloat()))
              .build()
            cameraPlugin.easeTo(
              cameraOptions, options,
              object : AnimatorListenerAdapter() {
                override fun onAnimationEnd(animation: Animator) { completion.onComplete(true) }
                override fun onAnimationCancel(animation: Animator) { completion.onComplete(false) }
              }
            )
          }
        }
    null -> null
  } ?: makeImmediateViewportTransition()
}

typealias AnimationRunner = (CameraOptions, CompletionListener) -> Unit
class GenericViewportTransition(private val runAnimation: AnimationRunner) : ViewportTransition {

  override fun run(to: ViewportState, completionListener: CompletionListener): Cancelable {
    return to.observeDataSource { cameraOptions ->
      runAnimation(cameraOptions) { animationPosition ->
        completionListener.onComplete(animationPosition)
      }
      return@observeDataSource false
    }
  }
}

fun _DefaultViewportTransitionOptions.toOptions(): DefaultViewportTransitionOptions {
  return DefaultViewportTransitionOptions.Builder()
    .maxDurationMs(maxDurationMs)
    .build()
}

fun ViewportPlugin.viewportStateFromFLTState(stateStorage: _ViewportStateStorage, context: Context): ViewportState? {
  return when (stateStorage.type) {
    _ViewportStateType.IDLE -> throw Exception("Not implemented")
    _ViewportStateType.FOLLOW_PUCK ->
      (stateStorage.options as? _FollowPuckViewportStateOptions)
        ?.let { makeFollowPuckViewportState(it.toOptions()) }
    _ViewportStateType.OVERVIEW ->
      (stateStorage.options as? _OverviewViewportStateOptions)
        ?.let { makeOverviewViewportState(it.toOptions(context)) }
    _ViewportStateType.STYLE_DEFAULT -> throw Exception("Not implemented")
    _ViewportStateType.CAMERA -> throw Exception("Not implemented")
  }
}

fun _FollowPuckViewportStateOptions.toOptions(): FollowPuckViewportStateOptions {
  val bearing: FollowPuckViewportStateBearing? = when (this.bearing) {
    _FollowPuckViewportStateBearing.HEADING -> FollowPuckViewportStateBearing.SyncWithLocationPuck
    _FollowPuckViewportStateBearing.COURSE -> FollowPuckViewportStateBearing.SyncWithLocationPuck
    _FollowPuckViewportStateBearing.CONSTANT -> {
      if (bearingValue == null) {
        logE("Viewport", "Invalid FollowPuckViewportStateOptions, bearing mode is CONSTANT but bearingValue is null")
      }

      bearingValue?.let { FollowPuckViewportStateBearing.Constant(it) }
    }
    null -> null
  }

  return FollowPuckViewportStateOptions.Builder()
    .zoom(zoom)
    .bearing(bearing)
    .pitch(pitch)
    .build()
}

fun _OverviewViewportStateOptions.toOptions(context: Context): OverviewViewportStateOptions {
  val geometry = GsonBuilder()
    .registerTypeAdapterFactory(GeoJsonAdapterFactory.create())
    .create()
    .fromJson(geometry, Polygon::class.java)
  return OverviewViewportStateOptions.Builder()
    .geometry(geometry)
    .padding(padding?.toEdgeInsets(context))
    .geometryPadding(geometryPadding.toEdgeInsets(context))
    .bearing(bearing)
    .pitch(pitch)
    .maxZoom(maxZoom)
    .offset(offset?.toScreenCoordinate(context) ?: ScreenCoordinate(0.0, 0.0))
    .animationDurationMs(animationDurationMs)
    .build()
}