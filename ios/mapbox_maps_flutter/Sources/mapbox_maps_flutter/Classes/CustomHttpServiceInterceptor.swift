
import MapboxMaps

final class CustomHttpServiceInterceptor: HttpServiceInterceptorInterface {
   
   var customHeaders: [String: String] = [:]

   func onRequest(for request: HttpRequest, continuation: @escaping HttpServiceInterceptorRequestContinuation) {
       var modifiedHeaders = request.headers

       for (key, value) in customHeaders {
           modifiedHeaders[key] = value
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
