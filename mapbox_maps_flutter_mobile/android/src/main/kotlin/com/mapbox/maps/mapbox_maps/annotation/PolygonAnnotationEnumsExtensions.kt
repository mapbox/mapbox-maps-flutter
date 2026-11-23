// This file is generated.

import com.mapbox.maps.mapbox_maps.pigeons.*

// FLT to Android

fun FillElevationReference.toFillElevationReference(): com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference {
  return when (this) {
    FillElevationReference.NONE -> com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.NONE
    FillElevationReference.HD_ROAD_BASE -> com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.HD_ROAD_BASE
    FillElevationReference.HD_ROAD_MARKUP -> com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.HD_ROAD_MARKUP
    else -> throw(RuntimeException("Unsupported FillElevationReference: $this"))
  }
}
fun FillTranslateAnchor.toFillTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor {
  return when (this) {
    FillTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.MAP
    FillTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported FillTranslateAnchor: $this"))
  }
}

// Android to FLT

fun com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.toFLTFillElevationReference(): FillElevationReference {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.NONE -> FillElevationReference.NONE
    com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.HD_ROAD_BASE -> FillElevationReference.HD_ROAD_BASE
    com.mapbox.maps.extension.style.layers.properties.generated.FillElevationReference.HD_ROAD_MARKUP -> FillElevationReference.HD_ROAD_MARKUP
    else -> throw(RuntimeException("Unsupported FillElevationReference: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.toFLTFillTranslateAnchor(): FillTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.MAP -> FillTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.VIEWPORT -> FillTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported FillTranslateAnchor: $this"))
  }
}