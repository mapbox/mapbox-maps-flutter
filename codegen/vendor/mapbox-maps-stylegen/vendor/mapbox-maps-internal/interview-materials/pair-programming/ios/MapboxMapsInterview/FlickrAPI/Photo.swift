import Foundation

struct Photo: Equatable, Decodable {
    var id: String
    var farm: Int
    var server: String
    var secret: String
    var title: String

    // Flickr Get Image API: https://www.flickr.com/services/api/misc.urls.html
    var thumbnailUrl: URL {
        URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_q.jpg")!
    }
}
