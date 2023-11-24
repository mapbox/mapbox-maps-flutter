// This file is generated.

import com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment
import com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale
import com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor
import com.mapbox.maps.pigeons.FLTCircleAnnotationMessager

// FLT to Android

fun FLTCircleAnnotationMessager.CirclePitchAlignment.toCirclePitchAlignment(): CirclePitchAlignment {
  return when (this) {
    FLTCircleAnnotationMessager.CirclePitchAlignment.MAP -> CirclePitchAlignment.MAP
    FLTCircleAnnotationMessager.CirclePitchAlignment.VIEWPORT -> CirclePitchAlignment.VIEWPORT
  }
}
fun FLTCircleAnnotationMessager.CirclePitchScale.toCirclePitchScale(): CirclePitchScale {
  return when (this) {
    FLTCircleAnnotationMessager.CirclePitchScale.MAP -> CirclePitchScale.MAP
    FLTCircleAnnotationMessager.CirclePitchScale.VIEWPORT -> CirclePitchScale.VIEWPORT
  }
}
fun FLTCircleAnnotationMessager.CircleTranslateAnchor.toCircleTranslateAnchor(): CircleTranslateAnchor {
  return when (this) {
    FLTCircleAnnotationMessager.CircleTranslateAnchor.MAP -> CircleTranslateAnchor.MAP
    FLTCircleAnnotationMessager.CircleTranslateAnchor.VIEWPORT -> CircleTranslateAnchor.VIEWPORT
  }
}

// Android to FLT

fun CirclePitchAlignment.toFLTCirclePitchAlignment(): FLTCircleAnnotationMessager.CirclePitchAlignment {
  return when (this) {
    CirclePitchAlignment.MAP -> FLTCircleAnnotationMessager.CirclePitchAlignment.MAP
    CirclePitchAlignment.VIEWPORT -> FLTCircleAnnotationMessager.CirclePitchAlignment.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchAlignment: $this"))
  }
}
fun CirclePitchScale.toFLTCirclePitchScale(): FLTCircleAnnotationMessager.CirclePitchScale {
  return when (this) {
    CirclePitchScale.MAP -> FLTCircleAnnotationMessager.CirclePitchScale.MAP
    CirclePitchScale.VIEWPORT -> FLTCircleAnnotationMessager.CirclePitchScale.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchScale: $this"))
  }
}
fun CircleTranslateAnchor.toFLTCircleTranslateAnchor(): FLTCircleAnnotationMessager.CircleTranslateAnchor {
  return when (this) {
    CircleTranslateAnchor.MAP -> FLTCircleAnnotationMessager.CircleTranslateAnchor.MAP
    CircleTranslateAnchor.VIEWPORT -> FLTCircleAnnotationMessager.CircleTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported CircleTranslateAnchor: $this"))
  }
}