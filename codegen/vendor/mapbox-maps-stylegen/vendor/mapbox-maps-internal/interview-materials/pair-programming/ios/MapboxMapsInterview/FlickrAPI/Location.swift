struct Location: Decodable {
    var latitude: Double
    var longitude: Double

    enum Error: Swift.Error {
        case invalidLatitude(String)
        case invalidLongitude(String)
    }

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        guard let latitude = Double(latitudeString) else {
            throw Error.invalidLatitude(latitudeString)
        }
        guard let longitude = Double(longitudeString) else {
            throw Error.invalidLongitude(longitudeString)
        }
        self.latitude = latitude
        self.longitude = longitude
    }
}
