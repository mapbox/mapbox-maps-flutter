@_spi(Experimental) import MapboxMaps

/// Converts a pigeon-generated `OrnamentPosition` into the native SDK's
/// `MapboxMaps.OrnamentPosition`. Shared by every ornament controller.
func toNativeOrnamentPosition(_ position: OrnamentPosition) -> MapboxMaps.OrnamentPosition {
    switch position {
    case .bOTTOMLEFT: return .bottomLeading
    case .bOTTOMRIGHT: return .bottomTrailing
    case .tOPLEFT: return .topLeading
    case .tOPRIGHT: return .topTrailing
    }
}

/// Converts a native `MapboxMaps.OrnamentPosition` back into the
/// pigeon-generated `OrnamentPosition`. Shared by every ornament controller.
func getFLT_SETTINGSOrnamentPosition(position: MapboxMaps.OrnamentPosition) -> OrnamentPosition {
    switch position {
    case .bottomLeading:
        return .bOTTOMLEFT
    case .bottomTrailing:
        return .bOTTOMRIGHT
    case .topLeading:
        return .tOPLEFT
    default:
        return .tOPRIGHT
    }
}
