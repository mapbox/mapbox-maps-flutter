package com.mapbox.maps.mapbox_maps

import com.mapbox.common.HttpServiceFactory
import com.mapbox.maps.mapbox_maps.http.CustomHttpServiceInterceptor
import com.mapbox.maps.mapbox_maps.pigeons.FlutterError
import com.mapbox.maps.mapbox_maps.pigeons._HttpServiceMessenger

/** Applies process-wide HTTP settings. No map is necessary. */
class HttpServiceController : _HttpServiceMessenger {
  override fun setCustomHeaders(headers: Map<String, String>, callback: (Result<Unit>) -> Unit) {
    runReportingErrors(HEADER_ERROR, callback) {
      CustomHttpServiceInterceptor.getInstance().setCustomHeaders(headers)
    }
  }

  override fun setCustomHeadersForHost(
    host: String,
    headers: Map<String, String>,
    callback: (Result<Unit>) -> Unit
  ) {
    if (host.isEmpty()) {
      callback(Result.failure(FlutterError(INVALID_ARGUMENTS, "host cannot be empty", null)))
      return
    }
    runReportingErrors(HEADER_ERROR, callback) {
      CustomHttpServiceInterceptor.getInstance().setCustomHeaders(host, headers)
    }
  }

  override fun clearCustomHeaders(callback: (Result<Unit>) -> Unit) {
    runReportingErrors(HEADER_ERROR, callback) {
      CustomHttpServiceInterceptor.getInstance().clearCustomHeaders()
    }
  }

  override fun setMaxRequestsPerHost(max: Long, callback: (Result<Unit>) -> Unit) {
    runReportingErrors(MAX_REQUESTS_PER_HOST_ERROR, callback) {
      // The Android HTTP client reads the value as a signed byte.
      HttpServiceFactory.setMaxRequestsPerHost(max.coerceIn(1, Byte.MAX_VALUE.toLong()).toByte())
    }
  }

  /** Sends an exception from the native SDK to Flutter as an error with [code]. */
  private fun runReportingErrors(code: String, callback: (Result<Unit>) -> Unit, block: () -> Unit) {
    try {
      block()
      callback(Result.success(Unit))
    } catch (e: Exception) {
      callback(Result.failure(FlutterError(code, e.message, null)))
    }
  }

  private companion object {
    const val INVALID_ARGUMENTS = "INVALID_ARGUMENTS"
    const val HEADER_ERROR = "HEADER_ERROR"
    const val MAX_REQUESTS_PER_HOST_ERROR = "MAX_REQUESTS_PER_HOST_ERROR"
  }
}