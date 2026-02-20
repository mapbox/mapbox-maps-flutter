import Flutter
import MapboxMaps

final class CustomHttpServiceInterceptor: HttpServiceInterceptorInterface {
    static let shared = CustomHttpServiceInterceptor()

    // Thread synchronization lock for protecting mutable state
    private let lock = NSLock()

    private var _customHeaders: [String: String] = [:]
    private var _flutterChannel: FlutterMethodChannel?
    private var _interceptRequests: Bool = false
    private var _interceptResponses: Bool = false
    private var _includeResponseBody: Bool = false

    var customHeaders: [String: String] {
        get { lock.withLock { _customHeaders } }
        set { lock.withLock { _customHeaders = newValue } }
    }

    var flutterChannel: FlutterMethodChannel? {
        get { lock.withLock { _flutterChannel } }
        set { lock.withLock { _flutterChannel = newValue } }
    }

    var interceptRequests: Bool {
        get { lock.withLock { _interceptRequests } }
        set { lock.withLock { _interceptRequests = newValue } }
    }

    var interceptResponses: Bool {
        get { lock.withLock { _interceptResponses } }
        set { lock.withLock { _interceptResponses = newValue } }
    }

    var includeResponseBody: Bool {
        get { lock.withLock { _includeResponseBody } }
        set { lock.withLock { _includeResponseBody = newValue } }
    }

    private init() {}

    func onRequest(
        for request: HttpRequest, continuation: @escaping HttpServiceInterceptorRequestContinuation
    ) {
        var modifiedHeaders = request.headers

        // First apply static custom headers
        for (key, value) in customHeaders {
            modifiedHeaders[key] = value
        }

        // If Flutter callback is enabled, invoke it
        if interceptRequests, let channel = flutterChannel {
            invokeFlutterRequestCallback(
                request: request,
                currentHeaders: modifiedHeaders,
                channel: channel,
                continuation: continuation
            )
        } else {
            // No callback, just continue with static headers
            let modifiedRequest = HttpRequest(
                method: request.method,
                url: request.url,
                headers: modifiedHeaders,
                timeout: request.timeout,
                networkRestriction: request.networkRestriction,
                sdkInformation: request.sdkInformation,
                body: request.body,
                flags: request.flags
            )
            continuation(HttpRequestOrResponse.fromHttpRequest(modifiedRequest))
        }
    }

    private func invokeFlutterRequestCallback(
        request: HttpRequest,
        currentHeaders: [String: String],
        channel: FlutterMethodChannel,
        continuation: @escaping HttpServiceInterceptorRequestContinuation
    ) {
        let requestMap: [String: Any?] = [
            "url": request.url,
            "method": request.method.rawValue,
            "headers": currentHeaders,
            "body": request.body,
        ]

        // Use async continuation pattern - call continuation directly from the Flutter callback
        // This avoids blocking the calling thread and prevents deadlocks when called from main thread
        DispatchQueue.main.async {
            channel.invokeMethod("http#onRequest", arguments: requestMap) { result in
                var finalHeaders = currentHeaders
                var finalUrl = request.url
                var finalBody = request.body

                if let modified = result as? [String: Any] {
                    // Apply modified headers
                    if let newHeaders = modified["headers"] as? [String: String] {
                        finalHeaders = newHeaders
                    }

                    // Apply modified URL
                    if let newUrl = modified["url"] as? String {
                        finalUrl = newUrl
                    }

                    // Apply modified body
                    if let newBody = modified["body"] as? FlutterStandardTypedData {
                        finalBody = newBody.data
                    } else if let newBody = modified["body"] as? Data {
                        finalBody = newBody
                    }
                }

                let modifiedRequest = HttpRequest(
                    method: request.method,
                    url: finalUrl,
                    headers: finalHeaders,
                    timeout: request.timeout,
                    networkRestriction: request.networkRestriction,
                    sdkInformation: request.sdkInformation,
                    body: finalBody,
                    flags: request.flags
                )
                // Call continuation from inside the callback - this is safe because
                // the native backend request() call is async (queues the request and returns immediately)
                continuation(HttpRequestOrResponse.fromHttpRequest(modifiedRequest))
            }
        }
    }

    func onResponse(
        for response: HttpResponse,
        continuation: @escaping HttpServiceInterceptorResponseContinuation
    ) {
        // If Flutter callback is enabled, invoke it (non-blocking)
        if interceptResponses, let channel = flutterChannel {
            // Capture includeResponseBody value under lock to ensure thread safety
            let shouldIncludeBody = includeResponseBody

            // response.result is Result<HttpResponseData, HttpRequestError>
            // We need to extract the success value
            var responseMap: [String: Any?]
            switch response.result {
            case .success(let responseData):
                responseMap = [
                    "url": response.request.url,
                    "statusCode": Int(responseData.code),
                    "headers": responseData.headers,
                    // Only include response body if explicitly opted in (to avoid performance issues)
                    "data": shouldIncludeBody ? responseData.data : nil,
                    "requestHeaders": response.request.headers,
                ]
            case .failure(_):
                responseMap = [
                    "url": response.request.url,
                    "statusCode": -1,
                    "headers": [:] as [String: String],
                    "data": nil,
                    "requestHeaders": response.request.headers,
                ]
            }

            DispatchQueue.main.async {
                channel.invokeMethod("http#onResponse", arguments: responseMap, result: nil)
            }
        }

        continuation(response)
    }

    func setFlutterChannel(_ channel: FlutterMethodChannel?) {
        flutterChannel = channel
    }

    func setInterceptorEnabled(
        enabled: Bool,
        interceptRequests: Bool,
        interceptResponses: Bool,
        includeResponseBody: Bool = false
    ) {
        self.interceptRequests = enabled && interceptRequests
        self.interceptResponses = enabled && interceptResponses
        self.includeResponseBody = includeResponseBody
        HttpServiceFactory.setHttpServiceInterceptorForInterceptor(self)
    }
}
