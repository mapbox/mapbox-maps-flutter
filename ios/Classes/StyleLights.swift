// This file is generated.
import MapboxMaps

extension DirectionalLight {
    init(_ fltValue: FLTDirectionalLight) {
        self.init(id: fltValue.id)

        if let castShadows = fltValue.castShadows {
            self.castShadows = .constant(castShadows.boolValue)
        }
        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color.intValue))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let direction = fltValue.direction {
            self.direction = .constant(direction.map(\.doubleValue))
        }
        self.directionTransition = fltValue.directionTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity.doubleValue)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
        if let shadowIntensity = fltValue.shadowIntensity {
            self.shadowIntensity = .constant(shadowIntensity.doubleValue)
        }
        self.shadowIntensityTransition = fltValue.shadowIntensityTransition?.toStyleTransition()
    }
}
extension AmbientLight {
    init(_ fltValue: FLTAmbientLight) {
        self.init(id: fltValue.id)

        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color.intValue))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity.doubleValue)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
    }
}
extension FlatLight {
    init(_ fltValue: FLTFlatLight) {
        self.init(id: fltValue.id)

        if let anchor = fltValue.anchor {
            self.anchor = Anchor(anchor).map { Value.constant($0) }
        }
        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color.intValue))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity.doubleValue)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
        if let position = fltValue.position {
            self.position = .constant(position.map(\.doubleValue))
        }
        self.positionTransition = fltValue.positionTransition?.toStyleTransition()
    }
}
// End of generated file.
