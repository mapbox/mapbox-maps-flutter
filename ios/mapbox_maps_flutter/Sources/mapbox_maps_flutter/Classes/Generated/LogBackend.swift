// Autogenerated from Pigeon (v25.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class LogBackendError: Error {
  let code: String
  let message: String?
  let details: Sendable?

  init(code: String, message: String?, details: Sendable?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "LogBackendError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
  }
}

private func createConnectionError(withChannelName channelName: String) -> LogBackendError {
  return LogBackendError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum LoggingLevel: Int {
  /// Verbose log data to understand how the code executes.
  case debug = 0
  /// Logs related to normal application behavior.
  case info = 1
  /// To log a situation that might be a problem, or an unusual situation.
  case warning = 2
  /// A log message providing information when a significant error occurred
  case error = 3
}

private class LogBackendPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return LoggingLevel(rawValue: enumResultAsInt)
      }
      return nil
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class LogBackendPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? LoggingLevel {
      super.writeByte(129)
      super.writeValue(value.rawValue)
    } else {
      super.writeValue(value)
    }
  }
}

private class LogBackendPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return LogBackendPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return LogBackendPigeonCodecWriter(data: data)
  }
}

class LogBackendPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = LogBackendPigeonCodec(readerWriter: LogBackendPigeonCodecReaderWriter())
}

/// An interface for implementing log writing backends, e.g. for using platform specific log backends or logging to a notification service.
///
/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol LogWriterBackendProtocol {
  /// Writes a log message with a given level.
  func writeLog(level levelArg: LoggingLevel, message messageArg: String, completion: @escaping (Result<Void, LogBackendError>) -> Void)
}
class LogWriterBackend: LogWriterBackendProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: LogBackendPigeonCodec {
    return LogBackendPigeonCodec.shared
  }
  /// Writes a log message with a given level.
  func writeLog(level levelArg: LoggingLevel, message messageArg: String, completion: @escaping (Result<Void, LogBackendError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.LogWriterBackend.writeLog\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([levelArg, messageArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(LogBackendError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
}
