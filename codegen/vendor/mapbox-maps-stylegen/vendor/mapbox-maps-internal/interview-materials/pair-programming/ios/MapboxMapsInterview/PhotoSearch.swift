import Foundation

final class PhotoSearch {

    static let queryDidChange = Notification.Name("mapbox.photoSearch.queryDidChange")
    static let resultsDidChange = Notification.Name("mapbox.photoSearch.resultsDidChange")

    var query = "" {
        didSet {
            results.removeAll()
            if query != oldValue {
                debouncer.updateQuery(query)
                NotificationCenter.default.post(name: Self.queryDidChange, object: self)
            }
        }
    }

    private(set) var results = [Photo]() {
        didSet {
            if results != oldValue {
                NotificationCenter.default.post(name: Self.resultsDidChange, object: self)
            }
        }
    }

    private var searchCancelable: Cancelable? {
        didSet {
            oldValue?.cancel()
        }
    }

    private let flickrAPI: FlickrAPIClient
    private let debouncer: QueryDebouncer

    init(flickrAPI: FlickrAPIClient) {
        self.flickrAPI = flickrAPI
        self.debouncer = QueryDebouncer(query: query, delay: 0.2)
        debouncer.delegate = self
    }
}

extension PhotoSearch: QueryDebouncerDelegate {
    func queryDebouncer(_ debouncer: QueryDebouncer, didUpdateQuery query: String) {
        searchCancelable = flickrAPI.search(withText: query) { [weak self] (result) in
            guard case let .success(searchResponse) = result else {
                print("Search failed with error: \(result)")
                return
            }
            self?.results = searchResponse.photos
        }
    }
}
