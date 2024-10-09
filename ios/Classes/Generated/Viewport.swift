// Autogenerated from Pigeon (v22.4.0), do not edit directly.
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
final class ViewportError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "ViewportError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? ViewportError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Configuration options for [ViewportManager].
///
/// Generated class from Pigeon that represents data sent in messages.
struct ViewportOptions {
  /// Indicates whether the [ViewportManager] should idle when the user interacts with the map using gestures.
  ///
  /// Set this property to [false] to enable building a custom [ViewportState] that
  /// can work simultaneously with certain types of gestures.
  ///
  /// Defaults to [true].
  var transitionsToIdleUponUserInteraction: Bool

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> ViewportOptions? {
    let transitionsToIdleUponUserInteraction = pigeonVar_list[0] as! Bool

    return ViewportOptions(
      transitionsToIdleUponUserInteraction: transitionsToIdleUponUserInteraction
    )
  }
  func toList() -> [Any?] {
    return [
      transitionsToIdleUponUserInteraction
    ]
  }
}

private class ViewportPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      return ViewportOptions.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class ViewportPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? ViewportOptions {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ViewportPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ViewportPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ViewportPigeonCodecWriter(data: data)
  }
}

class ViewportPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = ViewportPigeonCodec(readerWriter: ViewportPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol _ViewportManager {
  func getOptions() throws -> ViewportOptions
  func setOptions(options: ViewportOptions) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class _ViewportManagerSetup {
  static var codec: FlutterStandardMessageCodec { ViewportPigeonCodec.shared }
  /// Sets up an instance of `_ViewportManager` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: _ViewportManager?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let getOptionsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._ViewportManager.getOptions\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getOptionsChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getOptions()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getOptionsChannel.setMessageHandler(nil)
    }
    let setOptionsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._ViewportManager.setOptions\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setOptionsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let optionsArg = args[0] as! ViewportOptions
        do {
          try api.setOptions(options: optionsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setOptionsChannel.setMessageHandler(nil)
    }
  }
}
