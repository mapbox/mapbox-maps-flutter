import MapboxMaps
import Foundation
import Flutter

final class LoggingController {
    static private var backend: LogWriterBackend?
    static private let instance = LoggingController()

    static func setup(_ binaryMessanger: FlutterBinaryMessenger) {
        backend = .init(binaryMessenger: binaryMessanger)
        LogConfiguration.registerLogWriterBackend(forLogWriter: instance)
    }
}

extension LoggingController: MapboxCommon.LogWriterBackend {
    func writeLog(for level: MapboxCommon.LoggingLevel, message: String) {
        DispatchQueue.main.async {
            LoggingController.backend?.writeLog(
                level: level.toFLTLoggingLevel(),
                message: message,
                completion: { _ in }
            )
        }
    }
}
