// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

package com.mapbox.maps.mapbox_maps.pigeons

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

/** Samplers which can be optionally enabled to collect performance statistics. */
enum class PerformanceSamplerOptions(val raw: Int) {
  /** Enables the collection of `cumulativeValues`, which are GPU resource statistics. */
  CUMULATIVE(0),
  /** Enables the collection of `perFrameValues`, which are CPU timeline duration statistics. */
  PER_FRAME(1);

  companion object {
    fun ofRaw(raw: Int): PerformanceSamplerOptions? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * Options for the following statistics collection behaviors:
 * - Specify the types of sampling: cumulative, per-frame, or both.
 * - Define the minimum elapsed time for collecting performance samples.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class PerformanceStatisticsOptions(
  /** List of optional samplers to be used to collect performance statistics. */
  val samplerOptions: List<PerformanceSamplerOptions>,
  /**
   * The minimum elapsed time required before performance statistics become available.
   * It's important to note that the actual collection interval may exceed this duration since statistics are aggregated during render calls.
   * The effective collection interval can be observed through the `PerformanceStatistics` instance.
   * Setting `samplingDurationMillis` to 0 forces the collection of performance statistics every frame.
   *
   * A negative sampling duration is an error and results in no operation.
   */
  val samplingDurationMillis: Double
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PerformanceStatisticsOptions {
      val samplerOptions = pigeonVar_list[0] as List<PerformanceSamplerOptions>
      val samplingDurationMillis = pigeonVar_list[1] as Double
      return PerformanceStatisticsOptions(samplerOptions, samplingDurationMillis)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      samplerOptions,
      samplingDurationMillis,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DurationStatistics(
  /** The largest measured duration over the sampling window. */
  val maxMillis: Double,
  /** The median duration over the sampling window. */
  val medianMillis: Double
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): DurationStatistics {
      val maxMillis = pigeonVar_list[0] as Double
      val medianMillis = pigeonVar_list[1] as Double
      return DurationStatistics(maxMillis, medianMillis)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      maxMillis,
      medianMillis,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class CumulativeRenderingStatistics(
  /** The number of draw calls at the end of the collection window. */
  val drawCalls: Long,
  /** The amount of texture memory in use at the end of the collection window. */
  val textureBytes: Long,
  /** The amount of vertex memory (array and index buffer memory) in use at the end of the collection window. */
  val vertexBytes: Long,
  /** The number of graphics pipeline programs created. */
  val graphicsPrograms: Long,
  /** The total amount of time spent on all graphics pipeline program creation, in milliseconds. */
  val graphicsProgramsCreationTimeMillis: Double,
  /** The number of FBO switches. */
  val fboSwitchCount: Long
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): CumulativeRenderingStatistics {
      val drawCalls = pigeonVar_list[0] as Long
      val textureBytes = pigeonVar_list[1] as Long
      val vertexBytes = pigeonVar_list[2] as Long
      val graphicsPrograms = pigeonVar_list[3] as Long
      val graphicsProgramsCreationTimeMillis = pigeonVar_list[4] as Double
      val fboSwitchCount = pigeonVar_list[5] as Long
      return CumulativeRenderingStatistics(drawCalls, textureBytes, vertexBytes, graphicsPrograms, graphicsProgramsCreationTimeMillis, fboSwitchCount)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      drawCalls,
      textureBytes,
      vertexBytes,
      graphicsPrograms,
      graphicsProgramsCreationTimeMillis,
      fboSwitchCount,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class GroupPerformanceStatistics(
  /** The duration of the group or layer on the CPU timeline. */
  val durationMillis: Double,
  /** The name of the group or layer. */
  val name: String
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): GroupPerformanceStatistics {
      val durationMillis = pigeonVar_list[0] as Double
      val name = pigeonVar_list[1] as String
      return GroupPerformanceStatistics(durationMillis, name)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      durationMillis,
      name,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class PerFrameRenderingStatistics(
  /** The CPU timeline duration statistics of each render group, in descending order by duration. */
  val topRenderGroups: List<GroupPerformanceStatistics>,
  /** The CPU timeline duration statistics of each layer, in descending order by duration. */
  val topRenderLayers: List<GroupPerformanceStatistics>,
  /** The CPU timeline duration of the shadowmap render pass. */
  val shadowMapDurationStatistics: DurationStatistics,
  /** The CPU timeline duration of the renderer's resource (buffers, textures, images) upload pass. */
  val uploadDurationStatistics: DurationStatistics
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PerFrameRenderingStatistics {
      val topRenderGroups = pigeonVar_list[0] as List<GroupPerformanceStatistics>
      val topRenderLayers = pigeonVar_list[1] as List<GroupPerformanceStatistics>
      val shadowMapDurationStatistics = pigeonVar_list[2] as DurationStatistics
      val uploadDurationStatistics = pigeonVar_list[3] as DurationStatistics
      return PerFrameRenderingStatistics(topRenderGroups, topRenderLayers, shadowMapDurationStatistics, uploadDurationStatistics)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      topRenderGroups,
      topRenderLayers,
      shadowMapDurationStatistics,
      uploadDurationStatistics,
    )
  }
}

/**
 * The performance statistics collected at the end of the sampling duration.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class PerformanceStatistics(
  /**
   * The actual amount of time elapsed during statistics collection. Note that this duration is always a little bit larger
   * than the configured duration, as collection happens at a fixed point during the map render call.
   */
  val collectionDurationMillis: Double,
  /** The CPU timeline duration statistics of the map render call. */
  val mapRenderDurationStatistics: DurationStatistics,
  /** Cumulative, continuously tracked, resource stats. Enable using the `CumulativeRenderingStats` performance sampler option. */
  val cumulativeStatistics: CumulativeRenderingStatistics,
  /** Aggregated, per-frame, timings. Enable using the  `PerFrameRenderingStats` performance sampler option. */
  val perFrameStatistics: PerFrameRenderingStatistics
) {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PerformanceStatistics {
      val collectionDurationMillis = pigeonVar_list[0] as Double
      val mapRenderDurationStatistics = pigeonVar_list[1] as DurationStatistics
      val cumulativeStatistics = pigeonVar_list[2] as CumulativeRenderingStatistics
      val perFrameStatistics = pigeonVar_list[3] as PerFrameRenderingStatistics
      return PerformanceStatistics(collectionDurationMillis, mapRenderDurationStatistics, cumulativeStatistics, perFrameStatistics)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      collectionDurationMillis,
      mapRenderDurationStatistics,
      cumulativeStatistics,
      perFrameStatistics,
    )
  }
}
private open class PerformaceStatisticsPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          PerformanceSamplerOptions.ofRaw(it.toInt())
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PerformanceStatisticsOptions.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DurationStatistics.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          CumulativeRenderingStatistics.fromList(it)
        }
      }
      133.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          GroupPerformanceStatistics.fromList(it)
        }
      }
      134.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PerFrameRenderingStatistics.fromList(it)
        }
      }
      135.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PerformanceStatistics.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
    when (value) {
      is PerformanceSamplerOptions -> {
        stream.write(129)
        writeValue(stream, value.raw)
      }
      is PerformanceStatisticsOptions -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is DurationStatistics -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is CumulativeRenderingStatistics -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      is GroupPerformanceStatistics -> {
        stream.write(133)
        writeValue(stream, value.toList())
      }
      is PerFrameRenderingStatistics -> {
        stream.write(134)
        writeValue(stream, value.toList())
      }
      is PerformanceStatistics -> {
        stream.write(135)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
class PerformanceStatisticsListener(private val binaryMessenger: BinaryMessenger, private val messageChannelSuffix: String = "") {
  companion object {
    /** The codec used by PerformanceStatisticsListener. */
    val codec: MessageCodec<Any?> by lazy {
      PerformaceStatisticsPigeonCodec()
    }
  }
  fun onPerformanceStatisticsCollected(statisticsArg: PerformanceStatistics, callback: (Result<Unit>) -> Unit) {
    val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
    val channelName = "dev.flutter.pigeon.mapbox_maps_flutter.PerformanceStatisticsListener.onPerformanceStatisticsCollected$separatedMessageChannelSuffix"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(statisticsArg)) {
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