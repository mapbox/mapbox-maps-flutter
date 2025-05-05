// This file is generated.

import com.mapbox.maps.mapbox_maps.pigeons.*

// FLT to Android

fun CirclePitchAlignment.toCirclePitchAlignment(): com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment {
  return when (this) {
    CirclePitchAlignment.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment.MAP
    CirclePitchAlignment.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchAlignment: $this"))
  }
}
fun CirclePitchScale.toCirclePitchScale(): com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale {
  return when (this) {
    CirclePitchScale.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale.MAP
    CirclePitchScale.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchScale: $this"))
  }
}
fun CircleTranslateAnchor.toCircleTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor {
  return when (this) {
    CircleTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor.MAP
    CircleTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported CircleTranslateAnchor: $this"))
  }
}

// Android to FLT

fun com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment.toFLTCirclePitchAlignment(): CirclePitchAlignment {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment.MAP -> CirclePitchAlignment.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchAlignment.VIEWPORT -> CirclePitchAlignment.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchAlignment: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale.toFLTCirclePitchScale(): CirclePitchScale {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale.MAP -> CirclePitchScale.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.CirclePitchScale.VIEWPORT -> CirclePitchScale.VIEWPORT
    else -> throw(RuntimeException("Unsupported CirclePitchScale: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor.toFLTCircleTranslateAnchor(): CircleTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor.MAP -> CircleTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.CircleTranslateAnchor.VIEWPORT -> CircleTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported CircleTranslateAnchor: $this"))
  }
}