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
import struct Turf.Point

/// Error class for passing custom error details to Dart side.
final class SnapshotterMessengerError: Error {
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
      "SnapshotterMessengerError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
  }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? SnapshotterMessengerError {
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

private func createConnectionError(withChannelName channelName: String) -> SnapshotterMessengerError {
  return SnapshotterMessengerError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Set of options for taking map snapshot with `map snapshotter`.
///
/// Generated class from Pigeon that represents data sent in messages.
struct MapSnapshotOptions {
  /// Dimensions of the snapshot in `logical pixels`.
  var size: Size
  /// Ratio between the number device-independent and screen pixels.
  var pixelRatio: Double
  /// Glyphs rasterization options to use for client-side text rendering.
  /// By default, `GlyphsRasterizationOptions` will use `NoGlyphsRasterizedLocally` mode.
  var glyphsRasterizationOptions: GlyphsRasterizationOptions? = nil
  /// Flag that determines if the logo should be shown on the snapshot.
  var showsLogo: Bool? = nil
  /// Flag that determines if attribution should be shown on the snapshot.
  var showsAttribution: Bool? = nil


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> MapSnapshotOptions? {
    let size = pigeonVar_list[0] as! Size
    let pixelRatio = pigeonVar_list[1] as! Double
    let glyphsRasterizationOptions: GlyphsRasterizationOptions? = nilOrValue(pigeonVar_list[2])
    let showsLogo: Bool? = nilOrValue(pigeonVar_list[3])
    let showsAttribution: Bool? = nilOrValue(pigeonVar_list[4])

    return MapSnapshotOptions(
      size: size,
      pixelRatio: pixelRatio,
      glyphsRasterizationOptions: glyphsRasterizationOptions,
      showsLogo: showsLogo,
      showsAttribution: showsAttribution
    )
  }
  func toList() -> [Any?] {
    return [
      size,
      pixelRatio,
      glyphsRasterizationOptions,
      showsLogo,
      showsAttribution,
    ]
  }
}

private class SnapshotterMessengerPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return GlyphsRasterizationMode(rawValue: enumResultAsInt)
      }
      return nil
    case 130:
      return Point.fromList(self.readValue() as! [Any?])
    case 131:
      return MbxEdgeInsets.fromList(self.readValue() as! [Any?])
    case 132:
      return ScreenCoordinate.fromList(self.readValue() as! [Any?])
    case 133:
      return CameraOptions.fromList(self.readValue() as! [Any?])
    case 134:
      return Size.fromList(self.readValue() as! [Any?])
    case 135:
      return CoordinateBounds.fromList(self.readValue() as! [Any?])
    case 136:
      return CameraState.fromList(self.readValue() as! [Any?])
    case 137:
      return MbxImage.fromList(self.readValue() as! [Any?])
    case 138:
      return GlyphsRasterizationOptions.fromList(self.readValue() as! [Any?])
    case 139:
      return TileCoverOptions.fromList(self.readValue() as! [Any?])
    case 140:
      return CanonicalTileID.fromList(self.readValue() as! [Any?])
    case 141:
      return MapSnapshotOptions.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class SnapshotterMessengerPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? GlyphsRasterizationMode {
      super.writeByte(129)
      super.writeValue(value.rawValue)
    } else if let value = value as? Point {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? MbxEdgeInsets {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else if let value = value as? ScreenCoordinate {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? CameraOptions {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else if let value = value as? Size {
      super.writeByte(134)
      super.writeValue(value.toList())
    } else if let value = value as? CoordinateBounds {
      super.writeByte(135)
      super.writeValue(value.toList())
    } else if let value = value as? CameraState {
      super.writeByte(136)
      super.writeValue(value.toList())
    } else if let value = value as? MbxImage {
      super.writeByte(137)
      super.writeValue(value.toList())
    } else if let value = value as? GlyphsRasterizationOptions {
      super.writeByte(138)
      super.writeValue(value.toList())
    } else if let value = value as? TileCoverOptions {
      super.writeByte(139)
      super.writeValue(value.toList())
    } else if let value = value as? CanonicalTileID {
      super.writeByte(140)
      super.writeValue(value.toList())
    } else if let value = value as? MapSnapshotOptions {
      super.writeByte(141)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class SnapshotterMessengerPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return SnapshotterMessengerPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return SnapshotterMessengerPigeonCodecWriter(data: data)
  }
}

class SnapshotterMessengerPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = SnapshotterMessengerPigeonCodec(readerWriter: SnapshotterMessengerPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol OnSnapshotStyleListenerProtocol {
  func onDidFinishLoadingStyle(completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void)
  func onDidFullyLoadStyle(completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void)
  func onDidFailLoadingStyle(message messageArg: String, completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void)
  func onStyleImageMissing(imageId imageIdArg: String, completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void)
}
class OnSnapshotStyleListener: OnSnapshotStyleListenerProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: SnapshotterMessengerPigeonCodec {
    return SnapshotterMessengerPigeonCodec.shared
  }
  func onDidFinishLoadingStyle(completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFinishLoadingStyle\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(SnapshotterMessengerError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
  func onDidFullyLoadStyle(completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFullyLoadStyle\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(SnapshotterMessengerError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
  func onDidFailLoadingStyle(message messageArg: String, completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFailLoadingStyle\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([messageArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(SnapshotterMessengerError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
  func onStyleImageMissing(imageId imageIdArg: String, completion: @escaping (Result<Void, SnapshotterMessengerError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onStyleImageMissing\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([imageIdArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(SnapshotterMessengerError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol _SnapshotterInstanceManager {
  func setupSnapshotterForSuffix(suffix: String, eventTypes: [Int64], options: MapSnapshotOptions) throws
  func tearDownSnapshotterForSuffix(suffix: String) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class _SnapshotterInstanceManagerSetup {
  static var codec: FlutterStandardMessageCodec { SnapshotterMessengerPigeonCodec.shared }
  /// Sets up an instance of `_SnapshotterInstanceManager` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: _SnapshotterInstanceManager?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let setupSnapshotterForSuffixChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterInstanceManager.setupSnapshotterForSuffix\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setupSnapshotterForSuffixChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let suffixArg = args[0] as! String
        let eventTypesArg = args[1] as! [Int64]
        let optionsArg = args[2] as! MapSnapshotOptions
        do {
          try api.setupSnapshotterForSuffix(suffix: suffixArg, eventTypes: eventTypesArg, options: optionsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setupSnapshotterForSuffixChannel.setMessageHandler(nil)
    }
    let tearDownSnapshotterForSuffixChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterInstanceManager.tearDownSnapshotterForSuffix\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      tearDownSnapshotterForSuffixChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let suffixArg = args[0] as! String
        do {
          try api.tearDownSnapshotterForSuffix(suffix: suffixArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      tearDownSnapshotterForSuffixChannel.setMessageHandler(nil)
    }
  }
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol _SnapshotterMessenger {
  func getSize() throws -> Size
  func setSize(size: Size) throws
  func getCameraState() throws -> CameraState
  func setCamera(cameraOptions: CameraOptions) throws
  func start(completion: @escaping (Result<FlutterStandardTypedData?, Error>) -> Void)
  func cancel() throws
  func coordinateBounds(camera: CameraOptions) throws -> CoordinateBounds
  func camera(coordinates: [Point], padding: MbxEdgeInsets?, bearing: Double?, pitch: Double?) throws -> CameraOptions
  func tileCover(options: TileCoverOptions) throws -> [CanonicalTileID]
  func clearData(completion: @escaping (Result<Void, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class _SnapshotterMessengerSetup {
  static var codec: FlutterStandardMessageCodec { SnapshotterMessengerPigeonCodec.shared }
  /// Sets up an instance of `_SnapshotterMessenger` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: _SnapshotterMessenger?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let getSizeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.getSize\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getSizeChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getSize()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getSizeChannel.setMessageHandler(nil)
    }
    let setSizeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.setSize\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setSizeChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let sizeArg = args[0] as! Size
        do {
          try api.setSize(size: sizeArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setSizeChannel.setMessageHandler(nil)
    }
    let getCameraStateChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.getCameraState\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getCameraStateChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getCameraState()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getCameraStateChannel.setMessageHandler(nil)
    }
    let setCameraChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.setCamera\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setCameraChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let cameraOptionsArg = args[0] as! CameraOptions
        do {
          try api.setCamera(cameraOptions: cameraOptionsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setCameraChannel.setMessageHandler(nil)
    }
    let startChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.start\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startChannel.setMessageHandler { _, reply in
        api.start { result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      startChannel.setMessageHandler(nil)
    }
    let cancelChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.cancel\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      cancelChannel.setMessageHandler { _, reply in
        do {
          try api.cancel()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      cancelChannel.setMessageHandler(nil)
    }
    let coordinateBoundsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.coordinateBounds\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      coordinateBoundsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let cameraArg = args[0] as! CameraOptions
        do {
          let result = try api.coordinateBounds(camera: cameraArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      coordinateBoundsChannel.setMessageHandler(nil)
    }
    let cameraChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.camera\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      cameraChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let coordinatesArg = args[0] as! [Point]
        let paddingArg: MbxEdgeInsets? = nilOrValue(args[1])
        let bearingArg: Double? = nilOrValue(args[2])
        let pitchArg: Double? = nilOrValue(args[3])
        do {
          let result = try api.camera(coordinates: coordinatesArg, padding: paddingArg, bearing: bearingArg, pitch: pitchArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      cameraChannel.setMessageHandler(nil)
    }
    let tileCoverChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.tileCover\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      tileCoverChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let optionsArg = args[0] as! TileCoverOptions
        do {
          let result = try api.tileCover(options: optionsArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      tileCoverChannel.setMessageHandler(nil)
    }
    let clearDataChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessenger.clearData\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      clearDataChannel.setMessageHandler { _, reply in
        api.clearData { result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      clearDataChannel.setMessageHandler(nil)
    }
  }
}
