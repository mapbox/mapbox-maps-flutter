import UIKit
import SDWebImage

final class PhotosListViewController: UIViewController {

    private let photoSearch: PhotoSearch
    @IBOutlet var queryTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    private let imageLoader = SDWebImageDownloader()

    private var imageDownloadsById = [String: ImageDownload]()

    required init?(coder: NSCoder, photoSearch: PhotoSearch) {
        self.photoSearch = photoSearch
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        queryTextField.text = photoSearch.query
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: PhotoSearch.resultsDidChange,
            object: photoSearch)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncQueryToTextField),
            name: PhotoSearch.queryDidChange,
            object: photoSearch)
    }

    @objc private func reload() {
        tableView.reloadData()
    }

    @objc private func syncQueryToTextField() {
        queryTextField.text = photoSearch.query
    }

    @IBAction func syncQueryToPhotoSearch() {
        photoSearch.query = queryTextField.text ?? ""
    }
}

extension PhotosListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photoSearch.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photoSearch.results[indexPath.row]
        let imageDownload = imageDownloadsById[photo.id] ?? ImageDownload(url: photo.thumbnailUrl, imageLoader: imageLoader)
        imageDownloadsById[photo.id] = imageDownload
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotosListCell
        cell.imageDownload = imageDownload
        cell.textLabel?.text = photo.title
        return cell
    }
}

extension PhotosListViewController: UITableViewDelegate {
}

class PhotosListCell: UITableViewCell {
    var imageDownloadCancelable: Cancelable? {
        didSet {
            oldValue?.cancel()
        }
    }

    var imageDownload: ImageDownload? {
        didSet {
            imageView?.image = imageDownload?.image ?? ImageDownload.placeholderImage
            imageDownloadCancelable = imageDownload?.loadImage { [weak self] (result) in
                self?.imageView?.image = try? result.get()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownload = nil
    }
}
