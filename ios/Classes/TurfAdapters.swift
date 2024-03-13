import Foundation
import Turf

extension Point {
    static func fromList(_ list: [Any?]) -> Point! {
        let rawPoint = list.first as! [String: Any]
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
