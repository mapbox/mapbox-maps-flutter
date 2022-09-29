struct SearchResponse: Decodable {
    var photos: [Photo]

    enum CodingKeys: String, CodingKey {
        case photos
    }

    enum PhotosCodingKeys: String, CodingKey {
        case photo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photosContainer = try container.nestedContainer(keyedBy: PhotosCodingKeys.self, forKey: .photos)
        self.photos = try photosContainer.decode([Photo].self, forKey: .photo)
    }
}
