package com.mapbox.maps.mapbox_maps.http

import android.net.Uri
import com.mapbox.common.HttpRequest
import com.mapbox.common.HttpRequestOrResponse
import com.mapbox.common.HttpResponse
import com.mapbox.common.HttpServiceFactory
import com.mapbox.common.HttpServiceInterceptorInterface
import com.mapbox.common.HttpServiceInterceptorRequestContinuation
import com.mapbox.common.HttpServiceInterceptorResponseContinuation

class CustomHttpServiceInterceptor : HttpServiceInterceptorInterface {
  // Deprecated: headers applied to every request regardless of host.
  private var globalHeaders: Map<String, String> = emptyMap()

  // Headers scoped to a specific host, keyed by lowercased host. Attached only
  // to requests whose parsed URL host matches the key exactly. Both maps are
  // always replaced wholesale (never mutated in place) so a reader sees a
  // complete map.
  private var headersByHost: Map<String, Map<String, String>> = emptyMap()

  override fun onRequest(request: HttpRequest, continuation: HttpServiceInterceptorRequestContinuation) {
    val currentHeaders = HashMap(request.headers)

    // Deprecated global headers are applied to every host.
    currentHeaders.putAll(globalHeaders)

    // Host-scoped headers take precedence over the global ones. Match on the
    // exact, lowercased host of the parsed URL -- never a substring, so a host
    // like "api.mapbox.com.attacker.example" does not match "api.mapbox.com".
    val host = runCatching { Uri.parse(request.url).host?.lowercase() }.getOrNull()
    if (host != null) {
      headersByHost[host]?.let { currentHeaders.putAll(it) }
    }

    val modifiedRequest = request.toBuilder()
      .headers(currentHeaders)
      .build()
    continuation.run(HttpRequestOrResponse(modifiedRequest))
  }

  override fun onResponse(response: HttpResponse, continuation: HttpServiceInterceptorResponseContinuation) {
    continuation.run(response)
  }

  /**
   * Deprecated: sets headers attached to every request regardless of host.
   * Prefer the [setCustomHeaders] overload that takes an explicit host.
   */
  fun setCustomHeaders(headers: Map<String, String>) {
    globalHeaders = HashMap(headers)
    HttpServiceFactory.setHttpServiceInterceptor(this)
  }

  /**
   * Attaches [headers] only to requests whose URL host matches [host] exactly
   * (case-insensitive). An empty [headers] map removes the entry for [host].
   */
  fun setCustomHeaders(host: String, headers: Map<String, String>) {
    val key = host.lowercase()
    headersByHost = HashMap(headersByHost).apply {
      if (headers.isEmpty()) remove(key) else put(key, HashMap(headers))
    }
    HttpServiceFactory.setHttpServiceInterceptor(this)
  }

  /** Removes all custom headers, both global and host-scoped. */
  fun clearCustomHeaders() {
    globalHeaders = emptyMap()
    headersByHost = emptyMap()
  }

  companion object {
    private var instance: CustomHttpServiceInterceptor? = null

    fun getInstance(): CustomHttpServiceInterceptor {
      if (instance == null) {
        instance = CustomHttpServiceInterceptor()
      }
      return instance!!
    }
  }
}