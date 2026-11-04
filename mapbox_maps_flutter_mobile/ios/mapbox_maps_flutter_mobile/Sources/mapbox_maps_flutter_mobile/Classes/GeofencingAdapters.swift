import Foundation
import MapboxCommon
import Turf

// Pigeon codec adapters for Common's geofencing types. The wire format is
// `[feature, timestamp in milliseconds]`, matching `encode` and `decode` of
// the platform interface's GeofencingEvent and GeofenceState.

extension GeofencingEvent {
    static func fromList(_ list: [Any?]) -> GeofencingEvent? {
        guard let map = list[0] as? [String: Any],
              let feature = Turf.Feature.fromMap(map),
              let timestamp = list[1] as? NSNumber else { return nil }
        return GeofencingEvent(
            feature: feature,
            timestamp: Date(timeIntervalSince1970: timestamp.doubleValue / 1000)
        )
    }

    func toList() -> [Any?] {
        [feature.toMap(), Int64(timestamp.timeIntervalSince1970 * 1000)]
    }
}

extension GeofenceState {
    static func fromList(_ list: [Any?]) -> GeofenceState? {
        guard let map = list[0] as? [String: Any],
              let feature = Turf.Feature.fromMap(map) else { return nil }
        let timestamp = list[1] as? NSNumber
        return GeofenceState(
            feature: feature,
            timestamp: timestamp.map { Date(timeIntervalSince1970: $0.doubleValue / 1000) }
        )
    }

    func toList() -> [Any?] {
        [feature.toMap(), timestamp.map { Int64($0.timeIntervalSince1970 * 1000) }]
    }
}
