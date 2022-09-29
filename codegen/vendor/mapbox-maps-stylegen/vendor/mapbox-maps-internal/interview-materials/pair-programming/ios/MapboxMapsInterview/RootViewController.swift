import UIKit

// Using this as the injection root
class RootViewController: UIViewController {

    private let flickrAPI: FlickrAPIClient
    private let photoSearch: PhotoSearch

    required init?(coder: NSCoder) {
        // Use the API key from the instructions
        flickrAPI = FlickrAPIClient(key: APIKey.flickr, urlSession: .shared)
        photoSearch = PhotoSearch(flickrAPI: flickrAPI)
        super.init(coder: coder)
    }

    @IBSegueAction func makePhotosMapViewController(coder: NSCoder) -> PhotosMapViewController? {
        PhotosMapViewController(coder: coder, photoSearch: photoSearch)
    }

    @IBSegueAction func makePhotosListViewController(coder: NSCoder) -> PhotosListViewController? {
        PhotosListViewController(coder: coder, photoSearch: photoSearch)
    }
}
