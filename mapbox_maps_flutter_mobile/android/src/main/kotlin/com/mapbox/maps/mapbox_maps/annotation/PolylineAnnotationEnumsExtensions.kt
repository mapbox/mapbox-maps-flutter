// This file is generated.

import com.mapbox.maps.mapbox_maps.pigeons.*

// FLT to Android

fun LineCap.toLineCap(): com.mapbox.maps.extension.style.layers.properties.generated.LineCap {
  return when (this) {
    LineCap.BUTT -> com.mapbox.maps.extension.style.layers.properties.generated.LineCap.BUTT
    LineCap.ROUND -> com.mapbox.maps.extension.style.layers.properties.generated.LineCap.ROUND
    LineCap.SQUARE -> com.mapbox.maps.extension.style.layers.properties.generated.LineCap.SQUARE
    else -> throw(RuntimeException("Unsupported LineCap: $this"))
  }
}
fun LineElevationReference.toLineElevationReference(): com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference {
  return when (this) {
    LineElevationReference.NONE -> com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.NONE
    LineElevationReference.SEA -> com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.SEA
    LineElevationReference.GROUND -> com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.GROUND
    LineElevationReference.HD_ROAD_MARKUP -> com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.HD_ROAD_MARKUP
    else -> throw(RuntimeException("Unsupported LineElevationReference: $this"))
  }
}
fun LineJoin.toLineJoin(): com.mapbox.maps.extension.style.layers.properties.generated.LineJoin {
  return when (this) {
    LineJoin.BEVEL -> com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.BEVEL
    LineJoin.ROUND -> com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.ROUND
    LineJoin.MITER -> com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.MITER
    LineJoin.NONE -> com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.NONE
    else -> throw(RuntimeException("Unsupported LineJoin: $this"))
  }
}
fun LineWidthUnit.toLineWidthUnit(): com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit {
  return when (this) {
    LineWidthUnit.PIXELS -> com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit.PIXELS
    LineWidthUnit.METERS -> com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit.METERS
    else -> throw(RuntimeException("Unsupported LineWidthUnit: $this"))
  }
}
fun LineTranslateAnchor.toLineTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor {
  return when (this) {
    LineTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor.MAP
    LineTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported LineTranslateAnchor: $this"))
  }
}

// Android to FLT

fun com.mapbox.maps.extension.style.layers.properties.generated.LineCap.toFLTLineCap(): LineCap {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.LineCap.BUTT -> LineCap.BUTT
    com.mapbox.maps.extension.style.layers.properties.generated.LineCap.ROUND -> LineCap.ROUND
    com.mapbox.maps.extension.style.layers.properties.generated.LineCap.SQUARE -> LineCap.SQUARE
    else -> throw(RuntimeException("Unsupported LineCap: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.toFLTLineElevationReference(): LineElevationReference {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.NONE -> LineElevationReference.NONE
    com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.SEA -> LineElevationReference.SEA
    com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.GROUND -> LineElevationReference.GROUND
    com.mapbox.maps.extension.style.layers.properties.generated.LineElevationReference.HD_ROAD_MARKUP -> LineElevationReference.HD_ROAD_MARKUP
    else -> throw(RuntimeException("Unsupported LineElevationReference: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.toFLTLineJoin(): LineJoin {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.BEVEL -> LineJoin.BEVEL
    com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.ROUND -> LineJoin.ROUND
    com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.MITER -> LineJoin.MITER
    com.mapbox.maps.extension.style.layers.properties.generated.LineJoin.NONE -> LineJoin.NONE
    else -> throw(RuntimeException("Unsupported LineJoin: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit.toFLTLineWidthUnit(): LineWidthUnit {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit.PIXELS -> LineWidthUnit.PIXELS
    com.mapbox.maps.extension.style.layers.properties.generated.LineWidthUnit.METERS -> LineWidthUnit.METERS
    else -> throw(RuntimeException("Unsupported LineWidthUnit: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor.toFLTLineTranslateAnchor(): LineTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor.MAP -> LineTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor.VIEWPORT -> LineTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported LineTranslateAnchor: $this"))
  }
}