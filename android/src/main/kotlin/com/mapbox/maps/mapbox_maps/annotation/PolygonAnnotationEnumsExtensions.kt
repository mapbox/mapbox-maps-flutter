// This file is generated.

import com.mapbox.maps.mapbox_maps.pigeons.*

// FLT to Android

fun FillTranslateAnchor.toFillTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor {
  return when (this) {
    FillTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.MAP
    FillTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported FillTranslateAnchor: $this"))
  }
}

// Android to FLT

fun com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.toFLTFillTranslateAnchor(): FillTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.MAP -> FillTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor.VIEWPORT -> FillTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported FillTranslateAnchor: $this"))
  }
}