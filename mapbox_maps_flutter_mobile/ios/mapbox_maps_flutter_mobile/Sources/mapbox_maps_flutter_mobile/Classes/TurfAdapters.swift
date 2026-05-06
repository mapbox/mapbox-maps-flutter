import Foundation
import Turf

// Pigeon's default codec wraps custom data classes as `[Any?]` lists.
// Mobile's Dart-side codec (rewritten in mapbox_dart_generator.dart) uses
// `turf.<Name>.toJson()` / `turf.<Name>.fromJson()` which produces /
// consumes a bare GeoJSON `Map<String, dynamic>`
// (e.g. `{type: "Point", coordinates: [lng, lat]}`).
//
// To keep Dart ↔ Swift wire format identical, the Swift codec for these
// four turf types is rewritten in `mapbox_swift_generator.dart` to call
// `value.toMap()` / `<Name>.fromMap(...)` instead of `value.toList()` /
// `<Name>.fromList(...)`. `toMap()` is already provided by
// Extensions.swift for Point / LineString / Polygon, and Feature ships
// its own `toMap()`. Here we add the matching `fromMap()` decoders,
// which deserialize via turf's Codable conformance through
// JSONEncoder / JSONDecoder.

private func _turfDecode<T: Decodable>(_ map: [String: Any]) -> T? {
    guard let data = try? JSONSerialization.data(withJSONObject: map, options: []) else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}

extension Point {
    static func fromMap(_ map: [String: Any]) -> Point! {
        return _turfDecode(map)
    }
}

extension LineString {
    static func fromMap(_ map: [String: Any]) -> LineString? {
        return _turfDecode(map)
    }
}

extension Polygon {
    static func fromMap(_ map: [String: Any]) -> Polygon? {
        return _turfDecode(map)
    }
}

extension Feature {
    static func fromMap(_ map: [String: Any]) -> Feature? {
        return _turfDecode(map)
    }
}

extension Turf.Geometry {
    static func fromList(_ list: [Any?]) -> Turf.Geometry? {
        guard let raw = list.first as? [String: Any],
              let jsonData = try? JSONSerialization.data(withJSONObject: raw, options: []),
              let geometry = try? JSONDecoder().decode(Turf.Geometry.self, from: jsonData) else { return nil }

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

extension JSONValue {
    static func fromAny(_ any: Any) -> Self? {
        switch any {
        case let string as String:
            return .string(string)
        case let number as Double:
            return .number(number)
        case let number as Float:
            return .number(Double(number))
        case let number as Int:
            return .number(Double(number))
        case let boolean as Bool:
            return .boolean(boolean)
        case let array as [Any]:
            return .array(array.compactMap { fromAny($0) })
        case let obj as [String: Any]:
            return .object(obj.compactMapValues { fromAny($0) })
        default: return nil
        }
    }

    var toAny: Any {
        switch self {
        case .string(let string):
            return string
        case .number(let number):
            return number
        case .boolean(let boolean):
            return boolean
        case .array(let array):
            return array.compactMap { $0?.toAny }
        case .object(let object):
            return object.compactMapValues { $0?.toAny }
        }
    }
}
