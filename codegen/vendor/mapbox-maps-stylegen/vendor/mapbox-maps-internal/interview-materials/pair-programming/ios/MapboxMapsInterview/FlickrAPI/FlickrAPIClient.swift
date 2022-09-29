import Foundation

final class FlickrAPIClient {

    enum Error: Swift.Error {
        case unableToConstructURL
        case requestFailed(Swift.Error)
        case nonSuccessStatusCode(Int)
        case noResponseData
        case decodingFailure(Swift.Error)
    }

    private let key: String
    private let urlSession: URLSession

    init(key: String, urlSession: URLSession) {
        self.key = key
        self.urlSession = urlSession
    }

    /// Flickr Image Search API: https://www.flickr.com/services/api/explore/flickr.photos.search
    func search(withText text: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Cancelable {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "has_geo", value: "1"),
            URLQueryItem(name: "text", value: text)]
        return get(components, completion: completion)
    }

    /// Flickr Get Location API: https://www.flickr.com/services/api/flickr.photos.geo.getLocation.html
    func getLocation(forPhotoWithId id: String, completion: @escaping (Result<PhotoLocation, Error>) -> Void) -> Cancelable {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.geo.getLocation"),
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "photo_id", value: id)]
        return get(components, completion: completion)
    }

    private func get<T>(_ urlComponents: URLComponents, completion: @escaping (Result<T, Error>) -> Void) -> Cancelable where T: Decodable {

        let mainQueueCompletion = { (result: Result<T, Error>) in
            DispatchQueue.main.async { completion(result) }
        }

        guard let url = urlComponents.url else {
            mainQueueCompletion(.failure(.unableToConstructURL))
            return EmptyCancelable()
        }

        let dataTask = urlSession
            .dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    let nsError = error! as NSError
                    guard nsError.domain != NSURLErrorDomain || nsError.code != NSURLErrorCancelled else {
                        // don't call completion block if the request was canceled
                        return
                    }
                    mainQueueCompletion(.failure(.requestFailed(error!)))
                    return
                }

                let statusCode = (response as! HTTPURLResponse).statusCode
                guard statusCode / 100 == 2 else {
                    mainQueueCompletion(.failure(.nonSuccessStatusCode(statusCode)))
                    return
                }

                guard let data = data else {
                    mainQueueCompletion(.failure(.noResponseData))
                    return
                }

                mainQueueCompletion(
                    Result {
                        try JSONDecoder().decode(T.self, from: data)
                    }
                    .mapError(Error.decodingFailure)
                )
            }
        dataTask.resume()
        return dataTask
    }
}
