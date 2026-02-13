import Flutter
import MapboxMaps

final class CustomHttpServiceInterceptor: HttpServiceInterceptorInterface {
    static let shared = CustomHttpServiceInterceptor()

    var customHeaders: [String: String] = [:]
    var flutterChannel: FlutterMethodChannel?
    var interceptRequests: Bool = false
    var interceptResponses: Bool = false

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

        let semaphore = DispatchSemaphore(value: 0)
        var modifiedRequestMap: [String: Any]? = nil

        DispatchQueue.main.async {
            channel.invokeMethod("http#onRequest", arguments: requestMap) { result in
                if let resultMap = result as? [String: Any] {
                    modifiedRequestMap = resultMap
                }
                semaphore.signal()
            }
        }

        // Wait for Flutter response with a timeout (5 seconds)
        let waitResult = semaphore.wait(timeout: .now() + 5.0)

        var finalHeaders = currentHeaders
        var finalUrl = request.url
        var finalBody = request.body

        if waitResult == .success, let modified = modifiedRequestMap {
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

            // Note: method is not easily modifiable as it's an enum
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
        continuation(HttpRequestOrResponse.fromHttpRequest(modifiedRequest))
    }

    func onResponse(
        for response: HttpResponse,
        continuation: @escaping HttpServiceInterceptorResponseContinuation
    ) {
        // If Flutter callback is enabled, invoke it (non-blocking)
        if interceptResponses, let channel = flutterChannel {
            // response.result is Result<HttpResponseData, HttpRequestError>
            // We need to extract the success value
            var responseMap: [String: Any?]
            switch response.result {
            case .success(let responseData):
                responseMap = [
                    "url": response.request.url,
                    "statusCode": Int(responseData.code),
                    "headers": responseData.headers,
                    "data": responseData.data,
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

    func setInterceptorEnabled(enabled: Bool, interceptRequests: Bool, interceptResponses: Bool) {
        self.interceptRequests = enabled && interceptRequests
        self.interceptResponses = enabled && interceptResponses
        HttpServiceFactory.setHttpServiceInterceptorForInterceptor(self)
    }
}
