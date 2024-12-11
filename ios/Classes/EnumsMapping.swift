// This file is generated
import MapboxMaps

extension MapboxMaps.FillTranslateAnchor {

    init?(_ fltValue: FillTranslateAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTFillTranslateAnchor() -> FillTranslateAnchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.LineCap {

    init?(_ fltValue: LineCap?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .bUTT: self = .butt
        case .rOUND: self = .round
        case .sQUARE: self = .square
        }
    }

    func toFLTLineCap() -> LineCap? {
        switch self {
        case .butt: return .bUTT
        case .round: return .rOUND
        case .square: return .sQUARE
        default: return nil
        }
    }
}
extension MapboxMaps.LineJoin {

    init?(_ fltValue: LineJoin?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .bEVEL: self = .bevel
        case .rOUND: self = .round
        case .mITER: self = .miter
        case .nONE: self = .none
        }
    }

    func toFLTLineJoin() -> LineJoin? {
        switch self {
        case .bevel: return .bEVEL
        case .round: return .rOUND
        case .miter: return .mITER
        case .none: return .nONE
        default: return nil
        }
    }
}
extension MapboxMaps.LineTranslateAnchor {

    init?(_ fltValue: LineTranslateAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTLineTranslateAnchor() -> LineTranslateAnchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.IconAnchor {

    init?(_ fltValue: IconAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .cENTER: self = .center
        case .lEFT: self = .left
        case .rIGHT: self = .right
        case .tOP: self = .top
        case .bOTTOM: self = .bottom
        case .tOPLEFT: self = .topLeft
        case .tOPRIGHT: self = .topRight
        case .bOTTOMLEFT: self = .bottomLeft
        case .bOTTOMRIGHT: self = .bottomRight
        }
    }

    func toFLTIconAnchor() -> IconAnchor? {
        switch self {
        case .center: return .cENTER
        case .left: return .lEFT
        case .right: return .rIGHT
        case .top: return .tOP
        case .bottom: return .bOTTOM
        case .topLeft: return .tOPLEFT
        case .topRight: return .tOPRIGHT
        case .bottomLeft: return .bOTTOMLEFT
        case .bottomRight: return .bOTTOMRIGHT
        default: return nil
        }
    }
}
extension MapboxMaps.IconPitchAlignment {

    init?(_ fltValue: IconPitchAlignment?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        case .aUTO: self = .auto
        }
    }

    func toFLTIconPitchAlignment() -> IconPitchAlignment? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        case .auto: return .aUTO
        default: return nil
        }
    }
}
extension MapboxMaps.IconRotationAlignment {

    init?(_ fltValue: IconRotationAlignment?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        case .aUTO: self = .auto
        }
    }

    func toFLTIconRotationAlignment() -> IconRotationAlignment? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        case .auto: return .aUTO
        default: return nil
        }
    }
}
extension MapboxMaps.IconTextFit {

    init?(_ fltValue: IconTextFit?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .nONE: self = .none
        case .wIDTH: self = .width
        case .hEIGHT: self = .height
        case .bOTH: self = .both
        }
    }

    func toFLTIconTextFit() -> IconTextFit? {
        switch self {
        case .none: return .nONE
        case .width: return .wIDTH
        case .height: return .hEIGHT
        case .both: return .bOTH
        default: return nil
        }
    }
}
extension MapboxMaps.SymbolElevationReference {

    init?(_ fltValue: SymbolElevationReference?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .sEA: self = .sea
        case .gROUND: self = .ground
        }
    }

    func toFLTSymbolElevationReference() -> SymbolElevationReference? {
        switch self {
        case .sea: return .sEA
        case .ground: return .gROUND
        default: return nil
        }
    }
}
extension MapboxMaps.SymbolPlacement {

    init?(_ fltValue: SymbolPlacement?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .pOINT: self = .point
        case .lINE: self = .line
        case .lINECENTER: self = .lineCenter
        }
    }

    func toFLTSymbolPlacement() -> SymbolPlacement? {
        switch self {
        case .point: return .pOINT
        case .line: return .lINE
        case .lineCenter: return .lINECENTER
        default: return nil
        }
    }
}
extension MapboxMaps.SymbolZOrder {

    init?(_ fltValue: SymbolZOrder?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .aUTO: self = .auto
        case .vIEWPORTY: self = .viewportY
        case .sOURCE: self = .source
        }
    }

    func toFLTSymbolZOrder() -> SymbolZOrder? {
        switch self {
        case .auto: return .aUTO
        case .viewportY: return .vIEWPORTY
        case .source: return .sOURCE
        default: return nil
        }
    }
}
extension MapboxMaps.TextAnchor {

    init?(_ fltValue: TextAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .cENTER: self = .center
        case .lEFT: self = .left
        case .rIGHT: self = .right
        case .tOP: self = .top
        case .bOTTOM: self = .bottom
        case .tOPLEFT: self = .topLeft
        case .tOPRIGHT: self = .topRight
        case .bOTTOMLEFT: self = .bottomLeft
        case .bOTTOMRIGHT: self = .bottomRight
        }
    }

    func toFLTTextAnchor() -> TextAnchor? {
        switch self {
        case .center: return .cENTER
        case .left: return .lEFT
        case .right: return .rIGHT
        case .top: return .tOP
        case .bottom: return .bOTTOM
        case .topLeft: return .tOPLEFT
        case .topRight: return .tOPRIGHT
        case .bottomLeft: return .bOTTOMLEFT
        case .bottomRight: return .bOTTOMRIGHT
        default: return nil
        }
    }
}
extension MapboxMaps.TextJustify {

    init?(_ fltValue: TextJustify?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .aUTO: self = .auto
        case .lEFT: self = .left
        case .cENTER: self = .center
        case .rIGHT: self = .right
        }
    }

    func toFLTTextJustify() -> TextJustify? {
        switch self {
        case .auto: return .aUTO
        case .left: return .lEFT
        case .center: return .cENTER
        case .right: return .rIGHT
        default: return nil
        }
    }
}
extension MapboxMaps.TextPitchAlignment {

    init?(_ fltValue: TextPitchAlignment?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        case .aUTO: self = .auto
        }
    }

    func toFLTTextPitchAlignment() -> TextPitchAlignment? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        case .auto: return .aUTO
        default: return nil
        }
    }
}
extension MapboxMaps.TextRotationAlignment {

    init?(_ fltValue: TextRotationAlignment?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        case .aUTO: self = .auto
        }
    }

    func toFLTTextRotationAlignment() -> TextRotationAlignment? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        case .auto: return .aUTO
        default: return nil
        }
    }
}
extension MapboxMaps.TextTransform {

    init?(_ fltValue: TextTransform?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .nONE: self = .none
        case .uPPERCASE: self = .uppercase
        case .lOWERCASE: self = .lowercase
        }
    }

    func toFLTTextTransform() -> TextTransform? {
        switch self {
        case .none: return .nONE
        case .uppercase: return .uPPERCASE
        case .lowercase: return .lOWERCASE
        default: return nil
        }
    }
}
extension MapboxMaps.IconTranslateAnchor {

    init?(_ fltValue: IconTranslateAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTIconTranslateAnchor() -> IconTranslateAnchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.TextTranslateAnchor {

    init?(_ fltValue: TextTranslateAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTTextTranslateAnchor() -> TextTranslateAnchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.CirclePitchAlignment {

    init?(_ fltValue: CirclePitchAlignment?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTCirclePitchAlignment() -> CirclePitchAlignment? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.CirclePitchScale {

    init?(_ fltValue: CirclePitchScale?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTCirclePitchScale() -> CirclePitchScale? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.CircleTranslateAnchor {

    init?(_ fltValue: CircleTranslateAnchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTCircleTranslateAnchor() -> CircleTranslateAnchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
extension MapboxMaps.Anchor {

    init?(_ fltValue: Anchor?) {
        guard let fltValue else { return nil }

        switch fltValue {
        case .mAP: self = .map
        case .vIEWPORT: self = .viewport
        }
    }

    func toFLTAnchor() -> Anchor? {
        switch self {
        case .map: return .mAP
        case .viewport: return .vIEWPORT
        default: return nil
        }
    }
}
