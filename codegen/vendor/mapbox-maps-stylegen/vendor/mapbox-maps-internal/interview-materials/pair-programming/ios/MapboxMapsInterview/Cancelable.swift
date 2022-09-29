import Foundation
import SDWebImage

protocol Cancelable {
    func cancel()
}

final class EmptyCancelable: Cancelable {
    func cancel() {}
}

extension URLSessionDataTask: Cancelable {}

extension SDWebImageDownloadToken: Cancelable {}
