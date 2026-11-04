package com.mapbox.maps.mapbox_maps

import android.os.Handler
import android.os.Looper
import com.mapbox.common.geofencing.GeofenceState
import com.mapbox.common.geofencing.GeofencingError
import com.mapbox.common.geofencing.GeofencingEvent
import com.mapbox.common.geofencing.GeofencingFactory
import com.mapbox.common.geofencing.GeofencingObserver
import com.mapbox.common.geofencing.GeofencingService
import com.mapbox.common.geofencing.GeofencingUtils
import com.mapbox.common.geofencing.geofencingOptions
import com.mapbox.geojson.Feature
import com.mapbox.maps.mapbox_maps.pigeons.FlutterError
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingConsentChangesStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingEventWire
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingEventWireDwell
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingEventWireEntry
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingEventWireExit
import com.mapbox.maps.mapbox_maps.pigeons.GeofencingEventsStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.PigeonEventSink
import com.mapbox.maps.mapbox_maps.pigeons._GeofencingMessenger
import io.flutter.plugin.common.BinaryMessenger

class GeofencingController(
  messenger: BinaryMessenger,
) : _GeofencingMessenger, GeofencingObserver {
  private val mainHandler = Handler(Looper.getMainLooper())
  private var service: GeofencingService? = null
  private var observing = false

  private var eventsSink: PigeonEventSink<GeofencingEventWire>? = null
  private var consentSink: PigeonEventSink<Boolean>? = null

  init {
    GeofencingEventsStreamHandler.register(
      messenger,
      object : GeofencingEventsStreamHandler() {
        override fun onListen(p0: Any?, sink: PigeonEventSink<GeofencingEventWire>) {
          eventsSink = sink
          updateObserver()
        }

        override fun onCancel(p0: Any?) {
          eventsSink = null
          updateObserver()
        }
      }
    )
    GeofencingConsentChangesStreamHandler.register(
      messenger,
      object : GeofencingConsentChangesStreamHandler() {
        override fun onListen(p0: Any?, sink: PigeonEventSink<Boolean>) {
          consentSink = sink
          updateObserver()
        }

        override fun onCancel(p0: Any?) {
          consentSink = null
          updateObserver()
        }
      }
    )
  }

  fun dispose() {
    eventsSink = null
    consentSink = null
    updateObserver()
  }

  override fun configure(maximumMonitoredFeatures: Long, callback: (Result<Unit>) -> Unit) {
    if (maximumMonitoredFeatures !in 0..UInt.MAX_VALUE.toLong()) {
      callback(Result.failure(FlutterError("GENERIC", "maximumMonitoredFeatures is out of range", null)))
      return
    }
    service().configure(
      geofencingOptions { this.maximumMonitoredFeatures = maximumMonitoredFeatures.toUInt().toInt() },
    ) { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(Unit) },
          )
        )
      }
    }
  }

  override fun getOptions(callback: (Result<Long>) -> Unit) {
    service().getOptions { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(it.maximumMonitoredFeatures.toUInt().toLong()) },
          )
        )
      }
    }
  }

  override fun addFeature(feature: Feature, callback: (Result<String>) -> Unit) {
    service().addFeature(feature) { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(it) },
          )
        )
      }
    }
  }

  override fun getFeature(identifier: String, callback: (Result<GeofenceState>) -> Unit) {
    service().getFeature(identifier) { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(it) },
          )
        )
      }
    }
  }

  override fun removeFeature(identifier: String, callback: (Result<Unit>) -> Unit) {
    service().removeFeature(identifier) { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(Unit) },
          )
        )
      }
    }
  }

  override fun clearFeatures(callback: (Result<Long>) -> Unit) {
    service().clearFeatures { expected ->
      mainHandler.post {
        callback(
          expected.fold(
            { Result.failure(it.toFlutterError()) },
            { Result.success(it.toUInt().toLong()) },
          )
        )
      }
    }
  }

  override fun consent(): Boolean = GeofencingUtils.getUserConsent()

  override fun active(): Boolean = GeofencingUtils.isActive()

  override fun onEntry(event: GeofencingEvent) {
    sendEvent(GeofencingEventWireEntry(event))
  }

  override fun onDwell(event: GeofencingEvent) {
    sendEvent(GeofencingEventWireDwell(event))
  }

  override fun onExit(event: GeofencingEvent) {
    sendEvent(GeofencingEventWireExit(event))
  }

  override fun onError(error: GeofencingError) {
    mainHandler.post { sendError(error) }
  }

  override fun onUserConsentChanged(isConsentGiven: Boolean) {
    mainHandler.post { consentSink?.success(isConsentGiven) }
  }

  private fun updateObserver() {
    val listening = eventsSink != null || consentSink != null
    if (listening == observing) return
    observing = listening
    if (listening) {
      service().addObserver(this) { expected ->
        expected.error?.let { error ->
          mainHandler.post {
            observing = false
            sendError(error)
          }
        }
      }
    } else {
      service().removeObserver(this) {}
    }
  }

  private fun sendEvent(event: GeofencingEventWire) {
    mainHandler.post { eventsSink?.success(event) }
  }

  private fun sendError(error: GeofencingError) {
    eventsSink?.error(error.type.name, error.message, null)
  }

  private fun service(): GeofencingService {
    return service ?: GeofencingFactory.getOrCreate().also { service = it }
  }
}

private fun GeofencingError.toFlutterError(): FlutterError =
  FlutterError(type.name, message, null)