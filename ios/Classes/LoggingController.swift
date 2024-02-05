import MapboxMaps
import Foundation

final class LoggingController {
    static private var backend: FLT_LOGGINGLogWriterBackend?
    static private let instance = LoggingController()

    static func setup(_ binaryMessanger: FlutterBinaryMessenger) {
        backend = .init(binaryMessenger: binaryMessanger)
        LogConfiguration.registerLogWriterBackend(forLogWriter: instance)
    }
}

extension LoggingController: LogWriterBackend {
    func writeLog(for level: LoggingLevel, message: String) {
        DispatchQueue.main.async {
            LoggingController.backend?.writeLogLevel(
                level.toFLTLoggingLevel(),
                message: message,
                completion: { _ in }
            )
        }
    }
}
