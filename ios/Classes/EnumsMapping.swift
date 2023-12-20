// This file is generated
import MapboxMaps

extension FillTranslateAnchor {

    init?(_ fltValue: FLTFillTranslateAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTFillTranslateAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTFillTranslateAnchor() -> FLTFillTranslateAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTFillTranslateAnchorBox() -> FLTFillTranslateAnchorBox? {
        toFLTFillTranslateAnchor().map(FLTFillTranslateAnchorBox.init(value:))
    }
}
extension LineCap {

    init?(_ fltValue: FLTLineCap) {
        switch fltValue {
        case .BUTT: self = .butt
        case .ROUND: self = .round
        case .SQUARE: self = .square
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTLineCapBox) {
        self.init(fltValueBox.value)
    }

    func toFLTLineCap() -> FLTLineCap? {
        switch self {
        case .butt: return .BUTT
        case .round: return .ROUND
        case .square: return .SQUARE
        default: return nil
        }
    }

    func toFLTLineCapBox() -> FLTLineCapBox? {
        toFLTLineCap().map(FLTLineCapBox.init(value:))
    }
}
extension LineJoin {

    init?(_ fltValue: FLTLineJoin) {
        switch fltValue {
        case .BEVEL: self = .bevel
        case .ROUND: self = .round
        case .MITER: self = .miter
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTLineJoinBox) {
        self.init(fltValueBox.value)
    }

    func toFLTLineJoin() -> FLTLineJoin? {
        switch self {
        case .bevel: return .BEVEL
        case .round: return .ROUND
        case .miter: return .MITER
        default: return nil
        }
    }

    func toFLTLineJoinBox() -> FLTLineJoinBox? {
        toFLTLineJoin().map(FLTLineJoinBox.init(value:))
    }
}
extension LineTranslateAnchor {

    init?(_ fltValue: FLTLineTranslateAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTLineTranslateAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTLineTranslateAnchor() -> FLTLineTranslateAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTLineTranslateAnchorBox() -> FLTLineTranslateAnchorBox? {
        toFLTLineTranslateAnchor().map(FLTLineTranslateAnchorBox.init(value:))
    }
}
extension IconAnchor {

    init?(_ fltValue: FLTIconAnchor) {
        switch fltValue {
        case .CENTER: self = .center
        case .LEFT: self = .left
        case .RIGHT: self = .right
        case .TOP: self = .top
        case .BOTTOM: self = .bottom
        case .TOP_LEFT: self = .topLeft
        case .TOP_RIGHT: self = .topRight
        case .BOTTOM_LEFT: self = .bottomLeft
        case .BOTTOM_RIGHT: self = .bottomRight
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTIconAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTIconAnchor() -> FLTIconAnchor? {
        switch self {
        case .center: return .CENTER
        case .left: return .LEFT
        case .right: return .RIGHT
        case .top: return .TOP
        case .bottom: return .BOTTOM
        case .topLeft: return .TOP_LEFT
        case .topRight: return .TOP_RIGHT
        case .bottomLeft: return .BOTTOM_LEFT
        case .bottomRight: return .BOTTOM_RIGHT
        default: return nil
        }
    }

    func toFLTIconAnchorBox() -> FLTIconAnchorBox? {
        toFLTIconAnchor().map(FLTIconAnchorBox.init(value:))
    }
}
extension IconPitchAlignment {

    init?(_ fltValue: FLTIconPitchAlignment) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        case .AUTO: self = .auto
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTIconPitchAlignmentBox) {
        self.init(fltValueBox.value)
    }

    func toFLTIconPitchAlignment() -> FLTIconPitchAlignment? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        case .auto: return .AUTO
        default: return nil
        }
    }

    func toFLTIconPitchAlignmentBox() -> FLTIconPitchAlignmentBox? {
        toFLTIconPitchAlignment().map(FLTIconPitchAlignmentBox.init(value:))
    }
}
extension IconRotationAlignment {

    init?(_ fltValue: FLTIconRotationAlignment) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        case .AUTO: self = .auto
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTIconRotationAlignmentBox) {
        self.init(fltValueBox.value)
    }

    func toFLTIconRotationAlignment() -> FLTIconRotationAlignment? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        case .auto: return .AUTO
        default: return nil
        }
    }

    func toFLTIconRotationAlignmentBox() -> FLTIconRotationAlignmentBox? {
        toFLTIconRotationAlignment().map(FLTIconRotationAlignmentBox.init(value:))
    }
}
extension IconTextFit {

    init?(_ fltValue: FLTIconTextFit) {
        switch fltValue {
        case .NONE: self = .none
        case .WIDTH: self = .width
        case .HEIGHT: self = .height
        case .BOTH: self = .both
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTIconTextFitBox) {
        self.init(fltValueBox.value)
    }

    func toFLTIconTextFit() -> FLTIconTextFit? {
        switch self {
        case .none: return .NONE
        case .width: return .WIDTH
        case .height: return .HEIGHT
        case .both: return .BOTH
        default: return nil
        }
    }

    func toFLTIconTextFitBox() -> FLTIconTextFitBox? {
        toFLTIconTextFit().map(FLTIconTextFitBox.init(value:))
    }
}
extension SymbolPlacement {

    init?(_ fltValue: FLTSymbolPlacement) {
        switch fltValue {
        case .POINT: self = .point
        case .LINE: self = .line
        case .LINE_CENTER: self = .lineCenter
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTSymbolPlacementBox) {
        self.init(fltValueBox.value)
    }

    func toFLTSymbolPlacement() -> FLTSymbolPlacement? {
        switch self {
        case .point: return .POINT
        case .line: return .LINE
        case .lineCenter: return .LINE_CENTER
        default: return nil
        }
    }

    func toFLTSymbolPlacementBox() -> FLTSymbolPlacementBox? {
        toFLTSymbolPlacement().map(FLTSymbolPlacementBox.init(value:))
    }
}
extension SymbolZOrder {

    init?(_ fltValue: FLTSymbolZOrder) {
        switch fltValue {
        case .AUTO: self = .auto
        case .VIEWPORT_Y: self = .viewportY
        case .SOURCE: self = .source
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTSymbolZOrderBox) {
        self.init(fltValueBox.value)
    }

    func toFLTSymbolZOrder() -> FLTSymbolZOrder? {
        switch self {
        case .auto: return .AUTO
        case .viewportY: return .VIEWPORT_Y
        case .source: return .SOURCE
        default: return nil
        }
    }

    func toFLTSymbolZOrderBox() -> FLTSymbolZOrderBox? {
        toFLTSymbolZOrder().map(FLTSymbolZOrderBox.init(value:))
    }
}
extension TextAnchor {

    init?(_ fltValue: FLTTextAnchor) {
        switch fltValue {
        case .CENTER: self = .center
        case .LEFT: self = .left
        case .RIGHT: self = .right
        case .TOP: self = .top
        case .BOTTOM: self = .bottom
        case .TOP_LEFT: self = .topLeft
        case .TOP_RIGHT: self = .topRight
        case .BOTTOM_LEFT: self = .bottomLeft
        case .BOTTOM_RIGHT: self = .bottomRight
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextAnchor() -> FLTTextAnchor? {
        switch self {
        case .center: return .CENTER
        case .left: return .LEFT
        case .right: return .RIGHT
        case .top: return .TOP
        case .bottom: return .BOTTOM
        case .topLeft: return .TOP_LEFT
        case .topRight: return .TOP_RIGHT
        case .bottomLeft: return .BOTTOM_LEFT
        case .bottomRight: return .BOTTOM_RIGHT
        default: return nil
        }
    }

    func toFLTTextAnchorBox() -> FLTTextAnchorBox? {
        toFLTTextAnchor().map(FLTTextAnchorBox.init(value:))
    }
}
extension TextJustify {

    init?(_ fltValue: FLTTextJustify) {
        switch fltValue {
        case .AUTO: self = .auto
        case .LEFT: self = .left
        case .CENTER: self = .center
        case .RIGHT: self = .right
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextJustifyBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextJustify() -> FLTTextJustify? {
        switch self {
        case .auto: return .AUTO
        case .left: return .LEFT
        case .center: return .CENTER
        case .right: return .RIGHT
        default: return nil
        }
    }

    func toFLTTextJustifyBox() -> FLTTextJustifyBox? {
        toFLTTextJustify().map(FLTTextJustifyBox.init(value:))
    }
}
extension TextPitchAlignment {

    init?(_ fltValue: FLTTextPitchAlignment) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        case .AUTO: self = .auto
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextPitchAlignmentBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextPitchAlignment() -> FLTTextPitchAlignment? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        case .auto: return .AUTO
        default: return nil
        }
    }

    func toFLTTextPitchAlignmentBox() -> FLTTextPitchAlignmentBox? {
        toFLTTextPitchAlignment().map(FLTTextPitchAlignmentBox.init(value:))
    }
}
extension TextRotationAlignment {

    init?(_ fltValue: FLTTextRotationAlignment) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        case .AUTO: self = .auto
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextRotationAlignmentBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextRotationAlignment() -> FLTTextRotationAlignment? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        case .auto: return .AUTO
        default: return nil
        }
    }

    func toFLTTextRotationAlignmentBox() -> FLTTextRotationAlignmentBox? {
        toFLTTextRotationAlignment().map(FLTTextRotationAlignmentBox.init(value:))
    }
}
extension TextTransform {

    init?(_ fltValue: FLTTextTransform) {
        switch fltValue {
        case .NONE: self = .none
        case .UPPERCASE: self = .uppercase
        case .LOWERCASE: self = .lowercase
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextTransformBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextTransform() -> FLTTextTransform? {
        switch self {
        case .none: return .NONE
        case .uppercase: return .UPPERCASE
        case .lowercase: return .LOWERCASE
        default: return nil
        }
    }

    func toFLTTextTransformBox() -> FLTTextTransformBox? {
        toFLTTextTransform().map(FLTTextTransformBox.init(value:))
    }
}
extension IconTranslateAnchor {

    init?(_ fltValue: FLTIconTranslateAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTIconTranslateAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTIconTranslateAnchor() -> FLTIconTranslateAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTIconTranslateAnchorBox() -> FLTIconTranslateAnchorBox? {
        toFLTIconTranslateAnchor().map(FLTIconTranslateAnchorBox.init(value:))
    }
}
extension TextTranslateAnchor {

    init?(_ fltValue: FLTTextTranslateAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTTextTranslateAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTTextTranslateAnchor() -> FLTTextTranslateAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTTextTranslateAnchorBox() -> FLTTextTranslateAnchorBox? {
        toFLTTextTranslateAnchor().map(FLTTextTranslateAnchorBox.init(value:))
    }
}
extension CirclePitchAlignment {

    init?(_ fltValue: FLTCirclePitchAlignment) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTCirclePitchAlignmentBox) {
        self.init(fltValueBox.value)
    }

    func toFLTCirclePitchAlignment() -> FLTCirclePitchAlignment? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTCirclePitchAlignmentBox() -> FLTCirclePitchAlignmentBox? {
        toFLTCirclePitchAlignment().map(FLTCirclePitchAlignmentBox.init(value:))
    }
}
extension CirclePitchScale {

    init?(_ fltValue: FLTCirclePitchScale) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTCirclePitchScaleBox) {
        self.init(fltValueBox.value)
    }

    func toFLTCirclePitchScale() -> FLTCirclePitchScale? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTCirclePitchScaleBox() -> FLTCirclePitchScaleBox? {
        toFLTCirclePitchScale().map(FLTCirclePitchScaleBox.init(value:))
    }
}
extension CircleTranslateAnchor {

    init?(_ fltValue: FLTCircleTranslateAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTCircleTranslateAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTCircleTranslateAnchor() -> FLTCircleTranslateAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTCircleTranslateAnchorBox() -> FLTCircleTranslateAnchorBox? {
        toFLTCircleTranslateAnchor().map(FLTCircleTranslateAnchorBox.init(value:))
    }
}
extension Anchor {

    init?(_ fltValue: FLTAnchor) {
        switch fltValue {
        case .MAP: self = .map
        case .VIEWPORT: self = .viewport
        @unknown default: return nil
        }
    }

    init?(_ fltValueBox: FLTAnchorBox) {
        self.init(fltValueBox.value)
    }

    func toFLTAnchor() -> FLTAnchor? {
        switch self {
        case .map: return .MAP
        case .viewport: return .VIEWPORT
        default: return nil
        }
    }

    func toFLTAnchorBox() -> FLTAnchorBox? {
        toFLTAnchor().map(FLTAnchorBox.init(value:))
    }
}
