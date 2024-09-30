import Foundation
import MapboxMaps

protocol MapEventEncodable {
    var toJSON: [String: Any?] { get }
    var toJSONString: String { get }
}

extension EventTimeInterval {
    var toJSON: [String: Any] {
        [
            "begin": begin.microsecondsSince1970,
            "end": end.microsecondsSince1970
        ]
    }
}

extension MapboxMaps.CameraState {

    var toJSON: [String: Any] {
        return [
            "center": center.toDict(),
            "padding": ["top": padding.top, "left": padding.left, "bottom": padding.bottom, "right": padding.right],
            "zoom": zoom,
            "bearing": bearing,
            "pitch": pitch
        ]
    }
}

extension MapboxMaps.CanonicalTileID {
    var toJSON: [String: Any] {
        [
            "x": x,
            "y": y,
            "z": z
        ]
    }
}

extension MapLoaded: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "timeInterval": timeInterval.toJSON
        ]
    }
}

extension MapLoadingError: MapEventEncodable {
    var toJSON: [String: Any?] {
        return [
            "type": type.rawValue,
            "message": message,
            "sourceId": sourceId,
            "tileId": tileId?.toJSON,
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension StyleLoaded: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "timeInterval": timeInterval.toJSON
        ]
    }
}

extension StyleDataLoaded: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "type": type.rawValue,
            "timeInterval": timeInterval.toJSON
        ]
    }
}

extension CameraChanged: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "timestamp": timestamp.microsecondsSince1970,
            "cameraState": cameraState.toJSON,
        ]
    }
}

extension MapIdle: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension SourceAdded: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "sourceId": sourceId,
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension SourceRemoved: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "sourceId": sourceId,
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension SourceDataLoaded: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "sourceId": sourceId,
            "type": type.rawValue,
            "loaded": loaded,
            "tileId": tileId?.toJSON,
            "dataId": dataId,
            "timeInterval": timeInterval.toJSON
        ]
    }
}

extension StyleImageMissing: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "imageId": imageId,
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension StyleImageRemoveUnused: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "imageId": imageId,
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension RenderFrameStarted: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "timestamp": timestamp.microsecondsSince1970
        ]
    }
}

extension RenderFrameFinished: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "renderMode": renderMode.rawValue,
            "timeInterval": timeInterval.toJSON,
            "needsRepaint": needsRepaint,
            "placementChanged": placementChanged
        ]
    }
}

extension RequestInfo {
    var toJSON: [String: Any] {
        [
            "url": url,
            "resource": resource.rawValue,
            "priority": priority.rawValue,
            "loadingMethod": loadingMethod.map(\.rawValue)
        ]
    }
}

extension ResourceRequestError {
    var toJSON: [String: Any] {
        [
            "reason": reason.rawValue,
            "message": message
        ]
    }
}

extension ResponseInfo {
    var toJSON: [String: Any] {
        var result = [String: Any]()
        result["noContent"] = noContent
        result["notModified"] = notModified
        result["mustRevalidate"] = mustRevalidate
        result["source"] = source.rawValue
        result["size"] = size
        result["modified"] = modified?.microsecondsSince1970
        result["expires"] = expires?.microsecondsSince1970
        result["etag"] = etag
        result["error"] = error?.toJSON
        return result
    }
}

extension ResourceRequest: MapEventEncodable {
    var toJSON: [String: Any?] {
        [
            "source": source.rawValue,
            "request": request.toJSON,
            "response": response?.toJSON,
            "cancelled": cancelled,
            "timeInterval": timeInterval.toJSON
        ]
    }
}

extension MapEventEncodable {
    var toJSONString: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: toJSON.compactMapValues { $0 })
            return String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
}

// MARK: Date

private extension Date {

    var microsecondsSince1970: Int64 {
        Int64((timeIntervalSince1970 * 1_000_000).rounded())
    }
}
