// This file is generated.

import com.mapbox.maps.extension.style.layers.properties.generated.FillTranslateAnchor
import com.mapbox.maps.pigeons.FLTPolygonAnnotationMessager

// FLT to Android

fun FLTPolygonAnnotationMessager.FillTranslateAnchor.toFillTranslateAnchor(): FillTranslateAnchor {
  return when (this) {
    FLTPolygonAnnotationMessager.FillTranslateAnchor.MAP -> FillTranslateAnchor.MAP
    FLTPolygonAnnotationMessager.FillTranslateAnchor.VIEWPORT -> FillTranslateAnchor.VIEWPORT
  }
}

// Android to FLT

fun FillTranslateAnchor.toFLTFillTranslateAnchor(): FLTPolygonAnnotationMessager.FillTranslateAnchor {
  return when (this) {
    FillTranslateAnchor.MAP -> FLTPolygonAnnotationMessager.FillTranslateAnchor.MAP
    FillTranslateAnchor.VIEWPORT -> FLTPolygonAnnotationMessager.FillTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported FillTranslateAnchor: $this"))
  }
}