package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxExperimental
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.MapboxMapRecorder
import com.mapbox.maps.mapbox_maps.pigeons._MapRecorderMessenger
import java.nio.ByteBuffer

/**
 * Controller for MapRecorder functionality.
 *
 * Provides functions to record and replay API calls of a MapboxMap instance.
 * These recordings can be used to debug issues which require multiple steps to reproduce.
 * Additionally, playbacks can be used for performance testing custom scenarios.
 */
@OptIn(MapboxExperimental::class)
class MapRecorderController(
  private val mapboxMap: MapboxMap
) : _MapRecorderMessenger {

  private var recorder: MapboxMapRecorder? = null

  /**
   * Get or create the recorder instance.
   */
  private fun getRecorder(): MapboxMapRecorder {
    if (recorder == null) {
      recorder = mapboxMap.createRecorder()
    }
    return recorder!!
  }

  override fun startRecording(timeWindow: Long?, loggingEnabled: Boolean, compressed: Boolean) {
    val nativeOptions = com.mapbox.maps.MapRecorderOptions.Builder()
      .apply {
        timeWindow?.let { timeWindow(it) }
        loggingEnabled(loggingEnabled)
        compressed(compressed)
      }
      .build()

    getRecorder().startRecording(nativeOptions)
  }

  override fun stopRecording(callback: (Result<ByteArray>) -> Unit) {
    try {
      val data = getRecorder().stopRecording()
      val bytes = ByteArray(data.remaining())
      data.get(bytes)
      callback(Result.success(bytes))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun replay(
    recordedSequence: ByteArray,
    playbackCount: Long,
    playbackSpeedMultiplier: Double,
    avoidPlaybackPauses: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val nativeOptions = com.mapbox.maps.MapPlayerOptions.Builder()
        .playbackCount(playbackCount.toInt())
        .playbackSpeedMultiplier(playbackSpeedMultiplier)
        .avoidPlaybackPauses(avoidPlaybackPauses)
        .build()

      val buffer = ByteBuffer.wrap(recordedSequence)
      getRecorder().replay(buffer, nativeOptions) {
        callback(Result.success(Unit))
      }
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun togglePause() {
    getRecorder().togglePauseReplay()
  }

  override fun getState(): String {
    return getRecorder().getPlaybackState()
  }

  fun dispose() {
    recorder = null
  }
}