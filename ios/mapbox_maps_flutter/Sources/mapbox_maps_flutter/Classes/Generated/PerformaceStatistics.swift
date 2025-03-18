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
final class PerformaceStatisticsError: Error {
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
      "PerformaceStatisticsError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func createConnectionError(withChannelName channelName: String) -> PerformaceStatisticsError {
  return PerformaceStatisticsError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Samplers which can be optionally enabled to collect performance statistics.
enum PerformanceSamplerOptions: Int {
  /// Enables the collection of `cumulativeValues`, which are GPU resource statistics.
  case cUMULATIVE = 0
  /// Enables the collection of `perFrameValues`, which are CPU timeline duration statistics.
  case pERFRAME = 1
}

/// Options for the following statistics collection behaviors:
/// - Specify the types of sampling: cumulative, per-frame, or both.
/// - Define the minimum elapsed time for collecting performance samples.
///
/// Generated class from Pigeon that represents data sent in messages.
struct PerformanceStatisticsOptions {
  /// List of optional samplers to be used to collect performance statistics.
  var samplerOptions: [PerformanceSamplerOptions]
  /// The minimum elapsed time required before performance statistics become available.
  /// It's important to note that the actual collection interval may exceed this duration since statistics are aggregated during render calls.
  /// The effective collection interval can be observed through the `PerformanceStatistics` instance.
  /// Setting `samplingDurationMillis` to 0 forces the collection of performance statistics every frame.
  /// 
  /// A negative sampling duration is an error and results in no operation.
  var samplingDurationMillis: Double

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PerformanceStatisticsOptions? {
    let samplerOptions = pigeonVar_list[0] as! [PerformanceSamplerOptions]
    let samplingDurationMillis = pigeonVar_list[1] as! Double

    return PerformanceStatisticsOptions(
      samplerOptions: samplerOptions,
      samplingDurationMillis: samplingDurationMillis
    )
  }
  func toList() -> [Any?] {
    return [
      samplerOptions,
      samplingDurationMillis,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct DurationStatistics {
  /// The largest measured duration over the sampling window.
  var maxMillis: Double
  /// The median duration over the sampling window.
  var medianMillis: Double

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> DurationStatistics? {
    let maxMillis = pigeonVar_list[0] as! Double
    let medianMillis = pigeonVar_list[1] as! Double

    return DurationStatistics(
      maxMillis: maxMillis,
      medianMillis: medianMillis
    )
  }
  func toList() -> [Any?] {
    return [
      maxMillis,
      medianMillis,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct CumulativeRenderingStatistics {
  /// The number of draw calls at the end of the collection window.
  var drawCalls: Int64
  /// The amount of texture memory in use at the end of the collection window.
  var textureBytes: Int64
  /// The amount of vertex memory (array and index buffer memory) in use at the end of the collection window.
  var vertexBytes: Int64
  /// The number of graphics pipeline programs created.
  var graphicsPrograms: Int64
  /// The total amount of time spent on all graphics pipeline program creation, in milliseconds.
  var graphicsProgramsCreationTimeMillis: Double
  /// The number of FBO switches.
  var fboSwitchCount: Int64

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> CumulativeRenderingStatistics? {
    let drawCalls = pigeonVar_list[0] as! Int64
    let textureBytes = pigeonVar_list[1] as! Int64
    let vertexBytes = pigeonVar_list[2] as! Int64
    let graphicsPrograms = pigeonVar_list[3] as! Int64
    let graphicsProgramsCreationTimeMillis = pigeonVar_list[4] as! Double
    let fboSwitchCount = pigeonVar_list[5] as! Int64

    return CumulativeRenderingStatistics(
      drawCalls: drawCalls,
      textureBytes: textureBytes,
      vertexBytes: vertexBytes,
      graphicsPrograms: graphicsPrograms,
      graphicsProgramsCreationTimeMillis: graphicsProgramsCreationTimeMillis,
      fboSwitchCount: fboSwitchCount
    )
  }
  func toList() -> [Any?] {
    return [
      drawCalls,
      textureBytes,
      vertexBytes,
      graphicsPrograms,
      graphicsProgramsCreationTimeMillis,
      fboSwitchCount,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct GroupPerformanceStatistics {
  /// The duration of the group or layer on the CPU timeline.
  var durationMillis: Double
  /// The name of the group or layer.
  var name: String

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> GroupPerformanceStatistics? {
    let durationMillis = pigeonVar_list[0] as! Double
    let name = pigeonVar_list[1] as! String

    return GroupPerformanceStatistics(
      durationMillis: durationMillis,
      name: name
    )
  }
  func toList() -> [Any?] {
    return [
      durationMillis,
      name,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PerFrameRenderingStatistics {
  /// The CPU timeline duration statistics of each render group, in descending order by duration.
  var topRenderGroups: [GroupPerformanceStatistics]
  /// The CPU timeline duration statistics of each layer, in descending order by duration.
  var topRenderLayers: [GroupPerformanceStatistics]
  /// The CPU timeline duration of the shadowmap render pass.
  var shadowMapDurationStatistics: DurationStatistics
  /// The CPU timeline duration of the renderer's resource (buffers, textures, images) upload pass.
  var uploadDurationStatistics: DurationStatistics

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PerFrameRenderingStatistics? {
    let topRenderGroups = pigeonVar_list[0] as! [GroupPerformanceStatistics]
    let topRenderLayers = pigeonVar_list[1] as! [GroupPerformanceStatistics]
    let shadowMapDurationStatistics = pigeonVar_list[2] as! DurationStatistics
    let uploadDurationStatistics = pigeonVar_list[3] as! DurationStatistics

    return PerFrameRenderingStatistics(
      topRenderGroups: topRenderGroups,
      topRenderLayers: topRenderLayers,
      shadowMapDurationStatistics: shadowMapDurationStatistics,
      uploadDurationStatistics: uploadDurationStatistics
    )
  }
  func toList() -> [Any?] {
    return [
      topRenderGroups,
      topRenderLayers,
      shadowMapDurationStatistics,
      uploadDurationStatistics,
    ]
  }
}

/// The performance statistics collected at the end of the sampling duration.
///
/// Generated class from Pigeon that represents data sent in messages.
struct PerformanceStatistics {
  /// The actual amount of time elapsed during statistics collection. Note that this duration is always a little bit larger
  /// than the configured duration, as collection happens at a fixed point during the map render call.
  var collectionDurationMillis: Double
  /// The CPU timeline duration statistics of the map render call.
  var mapRenderDurationStatistics: DurationStatistics
  /// Cumulative, continuously tracked, resource stats. Enable using the `CumulativeRenderingStats` performance sampler option.
  var cumulativeStatistics: CumulativeRenderingStatistics
  /// Aggregated, per-frame, timings. Enable using the  `PerFrameRenderingStats` performance sampler option.
  var perFrameStatistics: PerFrameRenderingStatistics

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PerformanceStatistics? {
    let collectionDurationMillis = pigeonVar_list[0] as! Double
    let mapRenderDurationStatistics = pigeonVar_list[1] as! DurationStatistics
    let cumulativeStatistics = pigeonVar_list[2] as! CumulativeRenderingStatistics
    let perFrameStatistics = pigeonVar_list[3] as! PerFrameRenderingStatistics

    return PerformanceStatistics(
      collectionDurationMillis: collectionDurationMillis,
      mapRenderDurationStatistics: mapRenderDurationStatistics,
      cumulativeStatistics: cumulativeStatistics,
      perFrameStatistics: perFrameStatistics
    )
  }
  func toList() -> [Any?] {
    return [
      collectionDurationMillis,
      mapRenderDurationStatistics,
      cumulativeStatistics,
      perFrameStatistics,
    ]
  }
}

private class PerformaceStatisticsPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return PerformanceSamplerOptions(rawValue: enumResultAsInt)
      }
      return nil
    case 130:
      return PerformanceStatisticsOptions.fromList(self.readValue() as! [Any?])
    case 131:
      return DurationStatistics.fromList(self.readValue() as! [Any?])
    case 132:
      return CumulativeRenderingStatistics.fromList(self.readValue() as! [Any?])
    case 133:
      return GroupPerformanceStatistics.fromList(self.readValue() as! [Any?])
    case 134:
      return PerFrameRenderingStatistics.fromList(self.readValue() as! [Any?])
    case 135:
      return PerformanceStatistics.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class PerformaceStatisticsPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? PerformanceSamplerOptions {
      super.writeByte(129)
      super.writeValue(value.rawValue)
    } else if let value = value as? PerformanceStatisticsOptions {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? DurationStatistics {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else if let value = value as? CumulativeRenderingStatistics {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? GroupPerformanceStatistics {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else if let value = value as? PerFrameRenderingStatistics {
      super.writeByte(134)
      super.writeValue(value.toList())
    } else if let value = value as? PerformanceStatistics {
      super.writeByte(135)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class PerformaceStatisticsPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return PerformaceStatisticsPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return PerformaceStatisticsPigeonCodecWriter(data: data)
  }
}

class PerformaceStatisticsPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = PerformaceStatisticsPigeonCodec(readerWriter: PerformaceStatisticsPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol PerformanceStatisticsListenerProtocol {
  func onPerformanceStatisticsCollected(statistics statisticsArg: PerformanceStatistics, completion: @escaping (Result<Void, PerformaceStatisticsError>) -> Void)
}
class PerformanceStatisticsListener: PerformanceStatisticsListenerProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: PerformaceStatisticsPigeonCodec {
    return PerformaceStatisticsPigeonCodec.shared
  }
  func onPerformanceStatisticsCollected(statistics statisticsArg: PerformanceStatistics, completion: @escaping (Result<Void, PerformaceStatisticsError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.mapbox_maps_flutter.PerformanceStatisticsListener.onPerformanceStatisticsCollected\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([statisticsArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PerformaceStatisticsError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
}
