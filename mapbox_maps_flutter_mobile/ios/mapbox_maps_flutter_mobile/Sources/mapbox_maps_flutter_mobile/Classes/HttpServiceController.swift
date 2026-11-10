import MapboxMaps

/// Applies process-wide HTTP settings. No map is necessary.
final class HttpServiceController: _HttpServiceMessenger {
    private static let invalidArguments = "INVALID_ARGUMENTS"

    func setCustomHeaders(headers: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        let interceptor = CustomHttpServiceInterceptor.shared
        interceptor.customHeaders = headers
        HttpServiceFactory.setHttpServiceInterceptorForInterceptor(interceptor)
        completion(.success(()))
    }

    func setCustomHeadersForHost(
        host: String,
        headers: [String: String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard !host.isEmpty else {
            completion(.failure(HttpServiceMessengerError(
                code: Self.invalidArguments,
                message: "host cannot be empty",
                details: nil
            )))
            return
        }
        let interceptor = CustomHttpServiceInterceptor.shared
        interceptor.setHeaders(headers, forHost: host)
        HttpServiceFactory.setHttpServiceInterceptorForInterceptor(interceptor)
        completion(.success(()))
    }

    func clearCustomHeaders(completion: @escaping (Result<Void, Error>) -> Void) {
        CustomHttpServiceInterceptor.shared.clearAll()
        completion(.success(()))
    }

    func setMaxRequestsPerHost(max: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        HttpServiceFactory.setMaxRequestsPerHostForMax(UInt8(clamping: max))
        completion(.success(()))
    }
}
