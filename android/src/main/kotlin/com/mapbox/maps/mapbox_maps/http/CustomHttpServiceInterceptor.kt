package com.mapbox.maps.mapbox_maps.http

import com.mapbox.common.HttpServiceFactory
import com.mapbox.common.HttpServiceInterceptorInterface
import com.mapbox.common.HttpRequest
import com.mapbox.common.HttpRequestOrResponse
import com.mapbox.common.HttpResponse
import com.mapbox.common.HttpServiceInterceptorRequestContinuation
import com.mapbox.common.HttpServiceInterceptorResponseContinuation
import com.mapbox.common.NetworkRestriction

class CustomHttpServiceInterceptor : HttpServiceInterceptorInterface {
  private var customHeaders: MutableMap<String, String> = mutableMapOf()

  override fun onRequest(request: HttpRequest, continuation: HttpServiceInterceptorRequestContinuation) {
    val currentHeaders = HashMap(request.headers)

    currentHeaders.putAll(customHeaders)
    val modifiedRequest = request.toBuilder()
      .headers(currentHeaders)
      .networkRestriction(NetworkRestriction.NONE)
      .build()
    val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
    continuation.run(requestOrResponse)
  }

  override fun onResponse(response: HttpResponse, continuation: HttpServiceInterceptorResponseContinuation) {
    continuation.run(response)
  }

  fun setCustomHeaders(headers: Map<String, String>) {
    customHeaders.clear()
    customHeaders.putAll(headers)
    HttpServiceFactory.setHttpServiceInterceptor(this)
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