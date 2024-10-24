import Foundation
import Turf

extension Point {
    static func fromList(_ list: [Any?]) -> Point! {
        // swiftlint:disable:next force_cast
        let rawPoint = list.first as! [String: Any]
        // swiftlint:disable:next force_cast
        let coordinates = rawPoint["coordinates"] as! [Double]

        return Point(
            LocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        )
    }

    func toList() -> [Any?] {
        return [
            ["coordinates": [coordinates.longitude, coordinates.latitude]]
        ]
    }
}

extension LineString {

    static func fromList(_ list: [Any?]) -> LineString? {
        guard let raw = list.first as? [String: Any] else { return nil }
        guard let coordinates = raw["coordinates"] as? [[Double]] else { return nil }

        return LineString(coordinates.map(LocationCoordinate2D.init(values:)))
    }

    func toList() -> [Any?] {
        [
            ["coordinates": coordinates.map(\.values)]
        ]
    }
}

extension Polygon {

    static func fromList(_ list: [Any?]) -> Polygon? {
        guard let raw = list.first as? [String: Any] else { return nil }
        guard let coordinates = raw["coordinates"] as? [[[Double]]] else { return nil }

        return Polygon(coordinates.map { values in
            values.map(LocationCoordinate2D.init(values:))
        })
    }

    func toList() -> [Any?] {
        [
            ["coordinates": coordinates.map { $0.map(\.values) }]
        ]
    }
}

extension Feature {
    static func fromList(_ list: [Any?]) -> Feature? {
        guard let raw = list.first as? [String: Any],
              let jsonData = try? JSONSerialization.data(withJSONObject: raw, options: []),
              let feature = try? JSONDecoder().decode(Feature.self, from: jsonData) else { return nil }

        return feature
    }

    func toList() -> [Any?] {
        return [
            self.toMap()
        ]
    }
}

extension Geometry {
    static func fromList(_ list: [Any?]) -> Geometry? {
        guard let raw = list.first as? [String: Any],
              let jsonData = try? JSONSerialization.data(withJSONObject: raw, options: []),
              let geometry = try? JSONDecoder().decode(Geometry.self, from: jsonData) else { return nil }

        return geometry
    }

    func toList() -> [Any?] {
        return [
            self.toMap()
        ]
    }
}

extension JSONObject {
    static func fromList(_ list: [Any?]) -> JSONObject? {
        guard let raw = list.first as? [String: Any] else { return nil }

        return JSONObject(turfRawValue: raw)
    }

    static func fromString(_ string: String) -> JSONObject? {
        guard let data = string.data(using: .utf8) else { return nil }

        return try? JSONDecoder().decode(JSONObject.self, from: data)
    }
}

extension LocationCoordinate2D {

    fileprivate init(values: [Double]) {
        self.init(latitude: values[1], longitude: values[0])
    }

    fileprivate var values: [Double] {
        [longitude, latitude]
    }
}
