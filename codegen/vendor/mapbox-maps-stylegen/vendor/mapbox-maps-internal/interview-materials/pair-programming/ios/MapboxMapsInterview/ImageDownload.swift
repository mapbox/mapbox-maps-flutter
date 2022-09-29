import Foundation
import SDWebImage

final class ImageDownload {

    static var placeholderImage: UIImage = {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 150, height: 150))
        return renderer.image { (context) in
            UIColor.gray.setFill()
            context.fill(renderer.format.bounds)
        }
    }()

    let url: URL
    var image: UIImage?
    private var downloadImageCancelable: Cancelable?
    private var loadImageCancelables = [LoadImageCancelable]()
    private let imageLoader: SDWebImageDownloader

    init(url: URL, imageLoader: SDWebImageDownloader) {
        self.url = url
        self.imageLoader = imageLoader
    }

    deinit {
        downloadImageCancelable?.cancel()
    }

    func loadImage(with completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancelable {
        let cancelable = LoadImageCancelable(completionBlock: completion)
        loadImageCancelables.append(cancelable)
        let mainThreadCompletion = { [weak self] (result: Result<UIImage, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.downloadImageCancelable = nil
                self.image = try? result.get()
                let loadImageCancelables = self.loadImageCancelables
                self.loadImageCancelables.removeAll()
                for loadImageCancelable in loadImageCancelables {
                    loadImageCancelable.completionBlock?(result)
                }
            }
        }
        guard image == nil else {
            mainThreadCompletion(.success(image!))
            return cancelable
        }
        guard downloadImageCancelable == nil else {
            // already loading
            return cancelable
        }
        downloadImageCancelable = imageLoader.downloadImage(with: url) { (image, _, error, _) in
            guard let image = image else {
                mainThreadCompletion(.failure(error!))
                return
            }
            mainThreadCompletion(.success(image))
        }
        return cancelable
    }
}

final private class LoadImageCancelable: Cancelable {

    var completionBlock: ((Result<UIImage, Error>) -> Void)?

    init(completionBlock: @escaping (Result<UIImage, Error>) -> Void) {
        self.completionBlock = completionBlock
    }

    func cancel() {
        completionBlock = nil
    }
}
