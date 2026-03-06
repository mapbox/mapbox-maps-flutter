import Flutter
import MapboxMaps

protocol MapboxPigeonError: Sendable {
    associatedtype E: Error
    func toPigeonError() -> E
}

extension TileRegionError: MapboxPigeonError {
    func toPigeonError() -> OfflineMessengerError {
        let code: String
        let message: String

        switch self {
        case .canceled(let msg):
            code = "CANCELED"
            message = msg
        case .doesNotExist(let msg):
            code = "DOES_NOT_EXIST"
            message = msg
        case .tilesetDescriptor(let msg):
            code = "TILESET_DESCRIPTOR"
            message = msg
        case .diskFull(let msg):
            code = "DISK_FULL"
            message = msg
        case .other(let msg):
            code = "OTHER"
            message = msg
        case .tileCountExceeded(let msg):
            code = "TILE_COUNT_EXCEEDED"
            message = msg
        }

        return OfflineMessengerError(code: code, message: message, details: Thread.callStackSymbols)
    }
}

extension StylePackError: MapboxPigeonError {
    func toPigeonError() -> OfflineMessengerError {
        let code: String
        let message: String

        switch self {
        case .canceled(let msg):
            code = "CANCELED"
            message = msg
        case .doesNotExist(let msg):
            code = "DOES_NOT_EXIST"
            message = msg
        case .diskFull(let msg):
            code = "DISK_FULL"
            message = msg
        case .other(let msg):
            code = "OTHER"
            message = msg
        }

        return OfflineMessengerError(code: code, message: message, details: Thread.callStackSymbols)
    }
}

extension Result {

    func mapPigeonError() -> Result<Success, Swift.Error> {
        mapError { error in
            if let error = error as? any MapboxPigeonError {
                return error.toPigeonError()
            }
            return error
        }
    }
}
