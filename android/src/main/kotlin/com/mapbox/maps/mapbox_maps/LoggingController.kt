package com.mapbox.maps.mapbox_maps

import android.os.Handler
import android.os.Looper
import com.mapbox.common.LogConfiguration
import com.mapbox.common.LoggingLevel
import com.mapbox.maps.mapbox_maps.pigeons.LogWriterBackend
import io.flutter.plugin.common.BinaryMessenger

class Log {
  companion object {
    fun d(message: String) {
      LoggingController.instance.writeLog(LoggingLevel.DEBUG, message)
    }
  }
}

class LoggingController : com.mapbox.common.LogWriterBackend {
  private val handler = Handler(Looper.getMainLooper())

  companion object {
    private var backend: LogWriterBackend? = null
    internal val instance = LoggingController()

    fun setup(binaryMessenger: BinaryMessenger) {
      backend = LogWriterBackend(binaryMessenger)
      LogConfiguration.registerLogWriterBackend(instance)
    }
  }

  override fun writeLog(level: LoggingLevel, message: String) {
    handler.post {
      backend?.writeLog(level.toFLTLoggingLevel(), message) { }
    }
  }
}