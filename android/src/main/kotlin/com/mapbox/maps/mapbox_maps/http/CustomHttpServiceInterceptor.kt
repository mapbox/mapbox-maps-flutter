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

class CustomHttpServiceInterceptor : HttpServiceInterceptorInterface {
  // Thread synchronization lock for protecting mutable state
  private val lock = Any()

  private var customHeaders: MutableMap<String, String> = mutableMapOf()
  private var flutterChannel: MethodChannel? = null
  private var interceptRequests: Boolean = false
  private var interceptResponses: Boolean = false
  private var includeResponseBody: Boolean = false
  private val mainHandler = Handler(Looper.getMainLooper())

  override fun onRequest(request: HttpRequest, continuation: HttpServiceInterceptorRequestContinuation) {
    val currentHeaders = HashMap(request.headers)

    // Thread-safe access to mutable state
    val (headers, shouldIntercept, channel) = synchronized(lock) {
      Triple(HashMap(customHeaders), interceptRequests, flutterChannel)
    }

    // First apply static custom headers
    currentHeaders.putAll(headers)

    // If Flutter callback is enabled, invoke it
    if (shouldIntercept && channel != null) {
      invokeFlutterRequestCallback(request, currentHeaders, channel, continuation)
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
    channel: MethodChannel,
    continuation: HttpServiceInterceptorRequestContinuation
  ) {
    val requestMap = mapOf(
      "url" to request.url,
      "method" to request.method.name,
      "headers" to currentHeaders,
      "body" to request.body
    )

    // Use async continuation pattern - call continuation directly from the Flutter callback
    // This avoids blocking the calling thread and prevents deadlocks when called from main thread
    mainHandler.post {
      channel.invokeMethod("http#onRequest", requestMap, object : MethodChannel.Result {
        override fun success(result: Any?) {
          val builder = request.toBuilder()

          @Suppress("UNCHECKED_CAST")
          val modified = result as? Map<String, Any?>

          if (modified != null) {
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
          } else {
            builder.headers(currentHeaders)
          }

          val modifiedRequest = builder.build()
          val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
          // Call continuation from inside the callback - this is safe because
          // the native backend request() call is async (queues the request and returns immediately)
          continuation.run(requestOrResponse)
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
          // On error, continue with original request + custom headers
          val modifiedRequest = request.toBuilder()
            .headers(currentHeaders)
            .build()
          val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
          continuation.run(requestOrResponse)
        }

        override fun notImplemented() {
          // Not implemented, continue with original request + custom headers
          val modifiedRequest = request.toBuilder()
            .headers(currentHeaders)
            .build()
          val requestOrResponse = HttpRequestOrResponse(modifiedRequest)
          continuation.run(requestOrResponse)
        }
      })
    }
  }

  override fun onResponse(response: HttpResponse, continuation: HttpServiceInterceptorResponseContinuation) {
    // Thread-safe access to mutable state
    val (shouldIntercept, channel, shouldIncludeBody) = synchronized(lock) {
      Triple(interceptResponses, flutterChannel, includeResponseBody)
    }

    // If Flutter callback is enabled, invoke it (non-blocking)
    if (shouldIntercept && channel != null) {
      // response.result is Expected<HttpRequestError, HttpResponseData>
      // We need to check if it's a success and extract the value
      val responseData = response.result.value
      val responseMap = if (responseData != null) {
        mapOf(
          "url" to response.request.url,
          "statusCode" to responseData.code,
          "headers" to responseData.headers,
          // Only include response body if explicitly opted in (to avoid performance issues)
          "data" to if (shouldIncludeBody) responseData.data else null,
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
        channel.invokeMethod("http#onResponse", responseMap, object : MethodChannel.Result {
          override fun success(result: Any?) {}
          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
          override fun notImplemented() {}
        })
      }
    }

    continuation.run(response)
  }

  fun setCustomHeaders(headers: Map<String, String>) {
    synchronized(lock) {
      customHeaders.clear()
      customHeaders.putAll(headers)
    }
    HttpServiceFactory.setHttpServiceInterceptor(this)
  }

  fun setFlutterChannel(channel: MethodChannel?) {
    synchronized(lock) {
      flutterChannel = channel
    }
  }

  fun setInterceptorEnabled(
    enabled: Boolean,
    interceptRequests: Boolean,
    interceptResponses: Boolean,
    includeResponseBody: Boolean = false
  ) {
    synchronized(lock) {
      this.interceptRequests = enabled && interceptRequests
      this.interceptResponses = enabled && interceptResponses
      this.includeResponseBody = includeResponseBody
    }
    HttpServiceFactory.setHttpServiceInterceptor(this)
  }

  companion object {
    @Volatile
    private var instance: CustomHttpServiceInterceptor? = null

    fun getInstance(): CustomHttpServiceInterceptor {
      return instance ?: synchronized(this) {
        instance ?: CustomHttpServiceInterceptor().also { instance = it }
      }
    }
  }
}