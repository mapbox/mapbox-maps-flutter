// This file is generated.
import MapboxMaps

extension MapboxMaps.DirectionalLight {
    init(_ fltValue: DirectionalLight) {
        self.init(id: fltValue.id)

        if let castShadows = fltValue.castShadows {
            self.castShadows = .constant(castShadows)
        }
        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let direction = fltValue.direction {
            self.direction = .constant(direction.compactMap { $0 })
        }
        self.directionTransition = fltValue.directionTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
        if let shadowIntensity = fltValue.shadowIntensity {
            self.shadowIntensity = .constant(shadowIntensity)
        }
        self.shadowIntensityTransition = fltValue.shadowIntensityTransition?.toStyleTransition()
    }
}
extension MapboxMaps.AmbientLight {
    init(_ fltValue: AmbientLight) {
        self.init(id: fltValue.id)

        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
    }
}
extension MapboxMaps.FlatLight {
    init(_ fltValue: FlatLight) {
        self.init(id: fltValue.id)

        if let anchor = fltValue.anchor {
            self.anchor = MapboxMaps.Anchor(anchor).map { Value.constant($0) }
        }
        if let color = fltValue.color {
            self.color = .constant(StyleColor(rgb: color))
        }
        self.colorTransition = fltValue.colorTransition?.toStyleTransition()
        if let intensity = fltValue.intensity {
            self.intensity = .constant(intensity)
        }
        self.intensityTransition = fltValue.intensityTransition?.toStyleTransition()
        if let position = fltValue.position {
            self.position = .constant(position.compactMap { $0 })
        }
        self.positionTransition = fltValue.positionTransition?.toStyleTransition()
    }
}
// End of generated file.
