package com.mapbox.maps.mapbox_maps

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
import com.mapbox.common.Cancelable
import com.mapbox.maps.CameraChangedCallback
import com.mapbox.maps.MapIdleCallback
import com.mapbox.maps.MapLoadedCallback
import com.mapbox.maps.MapLoadingErrorCallback
import com.mapbox.maps.Observable
import com.mapbox.maps.RenderFrameFinishedCallback
import com.mapbox.maps.RenderFrameStartedCallback
import com.mapbox.maps.ResourceRequestCallback
import com.mapbox.maps.SourceAddedCallback
import com.mapbox.maps.SourceDataLoadedCallback
import com.mapbox.maps.SourceRemovedCallback
import com.mapbox.maps.StyleDataLoadedCallback
import com.mapbox.maps.StyleImageMissingCallback
import com.mapbox.maps.StyleImageRemoveUnusedCallback
import com.mapbox.maps.StyleLoadedCallback
import com.mapbox.maps.mapbox_maps.pigeons._MapEvent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Type
import java.util.Date

class MapboxEventHandler(
  private val eventProvider: Observable,
  binaryMessenger: BinaryMessenger,
  eventTypes: List<Long>,
  channelSuffix: String,
) : MethodChannel.MethodCallHandler {
  private val channel: MethodChannel
  private val cancellables = HashSet<Cancelable>()
  private val gson = GsonBuilder()
    .registerTypeAdapter(Date::class.java, MicrosecondsDateTypeAdapter)
    .registerTypeAdapterFactory(EnumOrdinalTypeAdapterFactory)
    .create()

  init {
    val pigeon_channelSuffix = if (channelSuffix.isNotEmpty()) ".$channelSuffix" else ""
    channel = MethodChannel(binaryMessenger, "com.mapbox.maps.flutter.map_events$pigeon_channelSuffix")
    channel.setMethodCallHandler(this)

    eventTypes.mapNotNull { _MapEvent.ofRaw(it.toInt()) }
      .forEach { subscribeToEvent(it) }
  }

  override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
    if (methodCall.method == "subscribeToEvents" && methodCall.arguments is List<*>) {
      cancellables.forEach { it.cancel() }
      cancellables.clear()

      val rawEventTypes = methodCall.arguments as List<Long>

      rawEventTypes.mapNotNull { _MapEvent.ofRaw(it.toInt()) }
        .forEach { subscribeToEvent(it) }
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  private fun subscribeToEvent(event: _MapEvent) {
    when (event) {
      _MapEvent.MAP_LOADED -> eventProvider.subscribe(
        MapLoadedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.MAP_LOADING_ERROR -> eventProvider.subscribe(
        MapLoadingErrorCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.STYLE_LOADED -> eventProvider.subscribe(
        StyleLoadedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.STYLE_DATA_LOADED -> eventProvider.subscribe(
        StyleDataLoadedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.CAMERA_CHANGED -> eventProvider.subscribe(
        CameraChangedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.MAP_IDLE -> eventProvider.subscribe(
        MapIdleCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.SOURCE_ADDED -> eventProvider.subscribe(
        SourceAddedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.SOURCE_REMOVED -> eventProvider.subscribe(
        SourceRemovedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.SOURCE_DATA_LOADED -> eventProvider.subscribe(
        SourceDataLoadedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.STYLE_IMAGE_MISSING -> eventProvider.subscribe(
        StyleImageMissingCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.STYLE_IMAGE_REMOVE_UNUSED -> eventProvider.subscribe(
        StyleImageRemoveUnusedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.RENDER_FRAME_STARTED -> eventProvider.subscribe(
        RenderFrameStartedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.RENDER_FRAME_FINISHED -> eventProvider.subscribe(
        RenderFrameFinishedCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
      _MapEvent.RESOURCE_REQUEST -> eventProvider.subscribe(
        ResourceRequestCallback {
          channel.invokeMethod(event.methodName, gson.toJson(it))
        }
      ).also { cancellables.add(it) }
    }
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

private val _MapEvent.methodName: String
  get() = "event#$ordinal"