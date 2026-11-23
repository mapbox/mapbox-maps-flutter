import CoreGraphics
@_spi(Experimental) import MapboxMaps

/// Native SDK holds less state than Flutter's API surface promises, so the
/// glue layer keeps its own shadow.
///
/// Caches the 4 margin values Flutter exposes per ornament, since the native
/// SDK stores only a single `CGPoint` (the 2 values for the current position).
struct OrnamentMargins {
    private(set) var left: Double
    private(set) var top: Double
    private(set) var right: Double
    private(set) var bottom: Double

    /// Seeds all 4 fields from the ornament's current native `CGPoint`
    init(seedingFrom point: CGPoint) {
        left = point.x
        right = point.x
        top = point.y
        bottom = point.y
    }

    /// Applies a partial update (only non-nil values change) and returns the
    /// `CGPoint` the native SDK stores for `position`
    mutating func apply(
        marginLeft: Double?,
        marginTop: Double?,
        marginRight: Double?,
        marginBottom: Double?,
        for position: MapboxMaps.OrnamentPosition
    ) -> CGPoint {
        if let marginLeft { left = marginLeft }
        if let marginTop { top = marginTop }
        if let marginRight { right = marginRight }
        if let marginBottom { bottom = marginBottom }

        switch position {
        case .bottomLeading: return CGPoint(x: left, y: bottom)
        case .bottomTrailing: return CGPoint(x: right, y: bottom)
        case .topLeading: return CGPoint(x: left, y: top)
        default: return CGPoint(x: right, y: top)  // .topTrailing
        }
    }
}
