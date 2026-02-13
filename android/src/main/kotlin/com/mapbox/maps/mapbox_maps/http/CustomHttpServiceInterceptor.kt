package com.mapbox.maps.mapbox_maps.http

import android.os.Handler
import android.os.Looper
import com.mapbox.common.HttpRequest
import com.mapbox.common.HttpRequestOrResponse
import com.mapbox.common.HttpResponse
import com.mapbox.common.HttpServiceFactory
import com.mapbox.common.HttpServiceInterceptorInterface
import com.mapbox.common.HttpServiceInterceptorRequestContinuation
import com.mapbox.common.HttpServiceInterceptorResponseContinuation
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class CustomHttpServiceInterceptor : HttpServiceInterceptorInterface {
  private var customHeaders: MutableMap<String, String> = mutableMapOf()
  private var flutterChannel: MethodChannel? = null
  private var interceptRequests: Boolean = false
  private var interceptResponses: Boolean = false
  private val mainHandler = Handler(Looper.getMainLooper())

  override fun onRequest(request: HttpRequest, continuation: HttpServiceInterceptorRequestContinuation) {
    val currentHeaders = HashMap(request.headers)

    // First apply static custom headers
    currentHeaders.putAll(customHeaders)

    // If Flutter callback is enabled, invoke it
    if (interceptRequests && flutterChannel != null) {
      invokeFlutterRequestCallback(request, currentHeaders, continuation)
    } else {
      // No callback, just continue with static headers
      val modifiedRequest = request.toBuilder()
        .headers(currentHeaders)
        .build()
      val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
      continuation.run(requestOrResponse)
    }
  }

  private fun invokeFlutterRequestCallback(
    request: HttpRequest,
    currentHeaders: HashMap<String, String>,
    continuation: HttpServiceInterceptorRequestContinuation
  ) {
    val requestMap = mapOf(
      "url" to request.url,
      "method" to request.method.name,
      "headers" to currentHeaders,
      "body" to request.body
    )

    // Use a latch to wait for the Flutter response
    val latch = CountDownLatch(1)
    var modifiedRequestMap: Map<String, Any?>? = null

    mainHandler.post {
      flutterChannel?.invokeMethod("http#onRequest", requestMap, object : MethodChannel.Result {
        override fun success(result: Any?) {
          @Suppress("UNCHECKED_CAST")
          modifiedRequestMap = result as? Map<String, Any?>
          latch.countDown()
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
          // On error, continue with original request
          latch.countDown()
        }

        override fun notImplemented() {
          // Not implemented, continue with original request
          latch.countDown()
        }
      })
    }

    // Wait for Flutter response with a timeout
    val received = latch.await(5, TimeUnit.SECONDS)

    val builder = request.toBuilder()

    if (received && modifiedRequestMap != null) {
      val modified = modifiedRequestMap!!

      // Apply modified headers
      @Suppress("UNCHECKED_CAST")
      val newHeaders = modified["headers"] as? Map<String, String>
      if (newHeaders != null) {
        builder.headers(HashMap(newHeaders))
      } else {
        builder.headers(currentHeaders)
      }

      // Apply modified URL
      val newUrl = modified["url"] as? String
      if (newUrl != null) {
        builder.url(newUrl)
      }

      // Apply modified body
      @Suppress("UNCHECKED_CAST")
      val newBody = modified["body"] as? ByteArray
      if (newBody != null) {
        builder.body(newBody)
      }

      // Note: method is not modifiable via the builder API
    } else {
      builder.headers(currentHeaders)
    }

    val modifiedRequest = builder.build()
    val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
    continuation.run(requestOrResponse)
  }

  override fun onResponse(response: HttpResponse, continuation: HttpServiceInterceptorResponseContinuation) {
    // If Flutter callback is enabled, invoke it (non-blocking)
    if (interceptResponses && flutterChannel != null) {
      // response.result is Expected<HttpRequestError, HttpResponseData>
      // We need to check if it's a success and extract the value
      val responseData = response.result.value
      val responseMap = if (responseData != null) {
        mapOf(
          "url" to response.request.url,
          "statusCode" to responseData.code,
          "headers" to responseData.headers,
          "data" to responseData.data,
          "requestHeaders" to response.request.headers
        )
      } else {
        // Error response - still send basic info
        mapOf(
          "url" to response.request.url,
          "statusCode" to -1,
          "headers" to emptyMap<String, String>(),
          "data" to null,
          "requestHeaders" to response.request.headers
        )
      }

      mainHandler.post {
        flutterChannel?.invokeMethod("http#onResponse", responseMap, object : MethodChannel.Result {
          override fun success(result: Any?) {}
          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
          override fun notImplemented() {}
        })
      }
    }

    continuation.run(response)
  }

  fun setCustomHeaders(headers: Map<String, String>) {
    customHeaders.clear()
    customHeaders.putAll(headers)
    HttpServiceFactory.setHttpServiceInterceptor(this)
  }

  fun setFlutterChannel(channel: MethodChannel?) {
    flutterChannel = channel
  }

  fun setInterceptorEnabled(enabled: Boolean, interceptRequests: Boolean, interceptResponses: Boolean) {
    this.interceptRequests = enabled && interceptRequests
    this.interceptResponses = enabled && interceptResponses
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