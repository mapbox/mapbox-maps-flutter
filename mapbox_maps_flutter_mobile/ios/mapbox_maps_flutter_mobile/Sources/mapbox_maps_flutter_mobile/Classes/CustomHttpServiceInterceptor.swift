import MapboxMaps

final class CustomHttpServiceInterceptor: HttpServiceInterceptorInterface {

    /// Shared instance so host-scoped headers accumulate across calls and a
    /// single interceptor is registered for the process.
    static let shared = CustomHttpServiceInterceptor()

    // Deprecated: headers applied to every request regardless of host.
    var customHeaders: [String: String] = [:]

    // Headers scoped to a specific host, keyed by lowercased host. Attached
    // only to requests whose parsed URL host matches the key exactly.
    private var headersByHost: [String: [String: String]] = [:]

    /// Attaches `headers` only to requests whose URL host matches `host`
    /// exactly (case-insensitive). An empty `headers` map removes the entry.
    func setHeaders(_ headers: [String: String], forHost host: String) {
        let key = host.lowercased()
        var updated = headersByHost
        if headers.isEmpty {
            updated.removeValue(forKey: key)
        } else {
            updated[key] = headers
        }
        headersByHost = updated
    }

    /// Removes all custom headers, both global and host-scoped.
    func clearAll() {
        customHeaders = [:]
        headersByHost = [:]
    }

    func onRequest(for request: HttpRequest, continuation: @escaping HttpServiceInterceptorRequestContinuation) {
        var modifiedHeaders = request.headers

        // Deprecated global headers are applied to every host.
        for (key, value) in customHeaders {
            modifiedHeaders[key] = value
        }

        // Host-scoped headers take precedence over the global ones. Match on
        // the exact, lowercased host of the parsed URL -- never a substring, so
        // "api.mapbox.com.attacker.example" does not match "api.mapbox.com".
        if let host = URL(string: request.url)?.host?.lowercased(),
           let scoped = headersByHost[host] {
            for (key, value) in scoped {
                modifiedHeaders[key] = value
            }
        }

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

    func onResponse(for response: HttpResponse, continuation: @escaping HttpServiceInterceptorResponseContinuation) {
        continuation(response)
    }
}
