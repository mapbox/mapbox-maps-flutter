// Autogenerated from Pigeon (v17.1.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.mapbox.maps.mapbox_maps.pigeons

import com.mapbox.geojson.Point
import com.mapbox.maps.mapbox_maps.mapping.turf.*
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun createConnectionError(channelName: String): FlutterError {
  return FlutterError("channel-error", "Unable to establish connection on channel: '$channelName'.", "")
}

/**
 * A structure that defines additional information about map content gesture.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MapContentGestureContext(
  /** The location of gesture in Map view bounds. */
  val touchPosition: ScreenCoordinate,
  /** Geographical coordinate of the map gesture. */
  val point: Point

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MapContentGestureContext {
      val touchPosition = ScreenCoordinate.fromList(list[0] as List<Any?>)
      val point = PointDecoder.fromList(list[1] as List<Any?>)
      return MapContentGestureContext(touchPosition, point)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      touchPosition.toList(),
      point.toList(),
    )
  }
}
@Suppress("UNCHECKED_CAST")
private object GestureListenerCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MapContentGestureContext.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PointDecoder.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ScreenCoordinate.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
    when (value) {
      is MapContentGestureContext -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is Point -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is ScreenCoordinate -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class GestureListener(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by GestureListener. */
    val codec: MessageCodec<Any?> by lazy {
      GestureListenerCodec
    }
  }
  fun onTap(contextArg: MapContentGestureContext, callback: (Result<Unit>) -> Unit) {
    val channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(contextArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      }
    }
  }
  fun onLongTap(contextArg: MapContentGestureContext, callback: (Result<Unit>) -> Unit) {
    val channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(contextArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      }
    }
  }
  fun onScroll(contextArg: MapContentGestureContext, callback: (Result<Unit>) -> Unit) {
    val channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(contextArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      }
    }
  }
}