// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

package com.mapbox.maps.mapbox_maps.pigeons

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError(
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/**
 * Configuration options for [ViewportManager].
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ViewportOptions(
  /**
   * Indicates whether the [ViewportManager] should idle when the user interacts with the map using gestures.
   *
   * Set this property to [false] to enable building a custom [ViewportState] that
   * can work simultaneously with certain types of gestures.
   *
   * Defaults to [true].
   */
  val transitionsToIdleUponUserInteraction: Boolean
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): ViewportOptions {
      val transitionsToIdleUponUserInteraction = pigeonVar_list[0] as Boolean
      return ViewportOptions(transitionsToIdleUponUserInteraction)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      transitionsToIdleUponUserInteraction,
    )
  }
}
private open class ViewportPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ViewportOptions.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
    when (value) {
      is ViewportOptions -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface _ViewportManager {
  fun getOptions(): ViewportOptions
  fun setOptions(options: ViewportOptions)

  companion object {
    /** The codec used by _ViewportManager. */
    val codec: MessageCodec<Any?> by lazy {
      ViewportPigeonCodec()
    }
    /** Sets up an instance of `_ViewportManager` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: _ViewportManager?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.mapbox_maps_flutter._ViewportManager.getOptions$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getOptions())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.mapbox_maps_flutter._ViewportManager.setOptions$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val optionsArg = args[0] as ViewportOptions
            val wrapped: List<Any?> = try {
              api.setOptions(optionsArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}