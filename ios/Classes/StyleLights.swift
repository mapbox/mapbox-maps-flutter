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
    if let colorTransition = fltValue.colorTransition, let duration = colorTransition.duration, let delay = colorTransition.delay {
      self.colorTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let direction = fltValue.direction {
      self.direction = .constant(direction.map(\.doubleValue))
    }
    if let directionTransition = fltValue.directionTransition, let duration = directionTransition.duration, let delay = directionTransition.delay {
      self.directionTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let intensity = fltValue.intensity {
      self.intensity = .constant(intensity.doubleValue)
    }
    if let intensityTransition = fltValue.intensityTransition, let duration = intensityTransition.duration, let delay = intensityTransition.delay {
      self.intensityTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let shadowIntensity = fltValue.shadowIntensity {
      self.shadowIntensity = .constant(shadowIntensity.doubleValue)
    }
    if let shadowIntensityTransition = fltValue.shadowIntensityTransition, let duration = shadowIntensityTransition.duration, let delay = shadowIntensityTransition.delay {
      self.shadowIntensityTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
  }
}
extension AmbientLight {
  
  init(_ fltValue: FLTAmbientLight) {
    self.init(id: fltValue.id)

    if let color = fltValue.color {
      self.color = .constant(StyleColor(rgb: color.intValue))
    }
    if let colorTransition = fltValue.colorTransition, let duration = colorTransition.duration, let delay = colorTransition.delay {
      self.colorTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let intensity = fltValue.intensity {
      self.intensity = .constant(intensity.doubleValue)
    }
    if let intensityTransition = fltValue.intensityTransition, let duration = intensityTransition.duration, let delay = intensityTransition.delay {
      self.intensityTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
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
    if let colorTransition = fltValue.colorTransition, let duration = colorTransition.duration, let delay = colorTransition.delay {
      self.colorTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let intensity = fltValue.intensity {
      self.intensity = .constant(intensity.doubleValue)
    }
    if let intensityTransition = fltValue.intensityTransition, let duration = intensityTransition.duration, let delay = intensityTransition.delay {
      self.intensityTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
    if let position = fltValue.position {
      self.position = .constant(position.map(\.doubleValue))
    }
    if let positionTransition = fltValue.positionTransition, let duration = positionTransition.duration, let delay = positionTransition.delay {
      self.positionTransition = StyleTransition(
        duration: duration.doubleValue * 1000, 
        delay: delay.doubleValue * 1000)
    }
  }
}
// End of generated file.
