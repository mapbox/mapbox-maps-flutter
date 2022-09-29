struct PhotoLocation: Decodable {
    var id: String
    var location: Location

    enum CodingKeys: String, CodingKey {
        case photo
    }

    enum PhotoCodingKeys: String, CodingKey {
        case id
        case location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photoContainer = try container.nestedContainer(keyedBy: PhotoCodingKeys.self, forKey: .photo)
        id = try photoContainer.decode(String.self, forKey: .id)
        location = try photoContainer.decode(Location.self, forKey: .location)
    }
}
