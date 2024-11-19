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
import struct Turf.Point

/// Error class for passing custom error details to Dart side.
final class ViewportInternalError: Error {
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
      "ViewportInternalError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? ViewportInternalError {
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

enum _ViewportTransitionType: Int {
  case defaultTransition = 0
  case fly = 1
  case easing = 2
}

enum _FollowPuckViewportStateBearing: Int {
  case constant = 0
  case heading = 1
  case course = 2
}

enum _ViewportStateType: Int {
  case idle = 0
  case overview = 1
  case followPuck = 2
  case styleDefault = 3
  case camera = 4
}

/// Generated class from Pigeon that represents data sent in messages.
struct _DefaultViewportTransitionOptions {
  var maxDurationMs: Int64

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _DefaultViewportTransitionOptions? {
    let maxDurationMs = pigeonVar_list[0] as! Int64

    return _DefaultViewportTransitionOptions(
      maxDurationMs: maxDurationMs
    )
  }
  func toList() -> [Any?] {
    return [
      maxDurationMs
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _FlyViewportTransitionOptions {
  var durationMs: Int64?

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _FlyViewportTransitionOptions? {
    let durationMs: Int64? = nilOrValue(pigeonVar_list[0])

    return _FlyViewportTransitionOptions(
      durationMs: durationMs
    )
  }
  func toList() -> [Any?] {
    return [
      durationMs
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _EasingViewportTransitionOptions {
  var durationMs: Int64
  var a: Double
  var b: Double
  var c: Double
  var d: Double

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _EasingViewportTransitionOptions? {
    let durationMs = pigeonVar_list[0] as! Int64
    let a = pigeonVar_list[1] as! Double
    let b = pigeonVar_list[2] as! Double
    let c = pigeonVar_list[3] as! Double
    let d = pigeonVar_list[4] as! Double

    return _EasingViewportTransitionOptions(
      durationMs: durationMs,
      a: a,
      b: b,
      c: c,
      d: d
    )
  }
  func toList() -> [Any?] {
    return [
      durationMs,
      a,
      b,
      c,
      d,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _ViewportTransitionStorage {
  var type: _ViewportTransitionType
  var options: Any?

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _ViewportTransitionStorage? {
    let type = pigeonVar_list[0] as! _ViewportTransitionType
    let options: Any? = pigeonVar_list[1]

    return _ViewportTransitionStorage(
      type: type,
      options: options
    )
  }
  func toList() -> [Any?] {
    return [
      type,
      options,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _OverviewViewportStateOptions {
  var geometry: String
  var geometryPadding: MbxEdgeInsets
  var bearing: Double?
  var pitch: Double?
  var padding: MbxEdgeInsets?
  var maxZoom: Double?
  var offset: ScreenCoordinate?
  var animationDurationMs: Int64

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _OverviewViewportStateOptions? {
    let geometry = pigeonVar_list[0] as! String
    let geometryPadding = pigeonVar_list[1] as! MbxEdgeInsets
    let bearing: Double? = nilOrValue(pigeonVar_list[2])
    let pitch: Double? = nilOrValue(pigeonVar_list[3])
    let padding: MbxEdgeInsets? = nilOrValue(pigeonVar_list[4])
    let maxZoom: Double? = nilOrValue(pigeonVar_list[5])
    let offset: ScreenCoordinate? = nilOrValue(pigeonVar_list[6])
    let animationDurationMs = pigeonVar_list[7] as! Int64

    return _OverviewViewportStateOptions(
      geometry: geometry,
      geometryPadding: geometryPadding,
      bearing: bearing,
      pitch: pitch,
      padding: padding,
      maxZoom: maxZoom,
      offset: offset,
      animationDurationMs: animationDurationMs
    )
  }
  func toList() -> [Any?] {
    return [
      geometry,
      geometryPadding,
      bearing,
      pitch,
      padding,
      maxZoom,
      offset,
      animationDurationMs,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _FollowPuckViewportStateOptions {
  var zoom: Double?
  var bearingValue: Double?
  var bearing: _FollowPuckViewportStateBearing?
  var pitch: Double?

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _FollowPuckViewportStateOptions? {
    let zoom: Double? = nilOrValue(pigeonVar_list[0])
    let bearingValue: Double? = nilOrValue(pigeonVar_list[1])
    let bearing: _FollowPuckViewportStateBearing? = nilOrValue(pigeonVar_list[2])
    let pitch: Double? = nilOrValue(pigeonVar_list[3])

    return _FollowPuckViewportStateOptions(
      zoom: zoom,
      bearingValue: bearingValue,
      bearing: bearing,
      pitch: pitch
    )
  }
  func toList() -> [Any?] {
    return [
      zoom,
      bearingValue,
      bearing,
      pitch,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct _ViewportStateStorage {
  var type: _ViewportStateType
  var options: Any?

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> _ViewportStateStorage? {
    let type = pigeonVar_list[0] as! _ViewportStateType
    let options: Any? = pigeonVar_list[1]

    return _ViewportStateStorage(
      type: type,
      options: options
    )
  }
  func toList() -> [Any?] {
    return [
      type,
      options,
    ]
  }
}

private class ViewportInternalPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return _ViewportTransitionType(rawValue: enumResultAsInt)
      }
      return nil
    case 130:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return _FollowPuckViewportStateBearing(rawValue: enumResultAsInt)
      }
      return nil
    case 131:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return _ViewportStateType(rawValue: enumResultAsInt)
      }
      return nil
    case 132:
      return MbxEdgeInsets.fromList(self.readValue() as! [Any?])
    case 133:
      return ScreenCoordinate.fromList(self.readValue() as! [Any?])
    case 134:
      return CameraOptions.fromList(self.readValue() as! [Any?])
    case 135:
      return Point.fromList(self.readValue() as! [Any?])
    case 136:
      return _DefaultViewportTransitionOptions.fromList(self.readValue() as! [Any?])
    case 137:
      return _FlyViewportTransitionOptions.fromList(self.readValue() as! [Any?])
    case 138:
      return _EasingViewportTransitionOptions.fromList(self.readValue() as! [Any?])
    case 139:
      return _ViewportTransitionStorage.fromList(self.readValue() as! [Any?])
    case 140:
      return _OverviewViewportStateOptions.fromList(self.readValue() as! [Any?])
    case 141:
      return _FollowPuckViewportStateOptions.fromList(self.readValue() as! [Any?])
    case 142:
      return _ViewportStateStorage.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class ViewportInternalPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? _ViewportTransitionType {
      super.writeByte(129)
      super.writeValue(value.rawValue)
    } else if let value = value as? _FollowPuckViewportStateBearing {
      super.writeByte(130)
      super.writeValue(value.rawValue)
    } else if let value = value as? _ViewportStateType {
      super.writeByte(131)
      super.writeValue(value.rawValue)
    } else if let value = value as? MbxEdgeInsets {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? ScreenCoordinate {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else if let value = value as? CameraOptions {
      super.writeByte(134)
      super.writeValue(value.toList())
    } else if let value = value as? Point {
      super.writeByte(135)
      super.writeValue(value.toList())
    } else if let value = value as? _DefaultViewportTransitionOptions {
      super.writeByte(136)
      super.writeValue(value.toList())
    } else if let value = value as? _FlyViewportTransitionOptions {
      super.writeByte(137)
      super.writeValue(value.toList())
    } else if let value = value as? _EasingViewportTransitionOptions {
      super.writeByte(138)
      super.writeValue(value.toList())
    } else if let value = value as? _ViewportTransitionStorage {
      super.writeByte(139)
      super.writeValue(value.toList())
    } else if let value = value as? _OverviewViewportStateOptions {
      super.writeByte(140)
      super.writeValue(value.toList())
    } else if let value = value as? _FollowPuckViewportStateOptions {
      super.writeByte(141)
      super.writeValue(value.toList())
    } else if let value = value as? _ViewportStateStorage {
      super.writeByte(142)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ViewportInternalPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ViewportInternalPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ViewportInternalPigeonCodecWriter(data: data)
  }
}

class ViewportInternalPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = ViewportInternalPigeonCodec(readerWriter: ViewportInternalPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol _ViewportMessenger {
  func transition(stateStorage: _ViewportStateStorage, transitionStorage: _ViewportTransitionStorage?, completion: @escaping (Result<Bool, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class _ViewportMessengerSetup {
  static var codec: FlutterStandardMessageCodec { ViewportInternalPigeonCodec.shared }
  /// Sets up an instance of `_ViewportMessenger` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: _ViewportMessenger?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let transitionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._ViewportMessenger.transition\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      transitionChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let stateStorageArg = args[0] as! _ViewportStateStorage
        let transitionStorageArg: _ViewportTransitionStorage? = nilOrValue(args[1])
        api.transition(stateStorage: stateStorageArg, transitionStorage: transitionStorageArg) { result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      transitionChannel.setMessageHandler(nil)
    }
  }
}
