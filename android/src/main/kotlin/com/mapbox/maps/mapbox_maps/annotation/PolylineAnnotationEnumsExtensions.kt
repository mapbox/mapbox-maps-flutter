// This file is generated.

import com.mapbox.maps.extension.style.layers.properties.generated.LineCap
import com.mapbox.maps.extension.style.layers.properties.generated.LineJoin
import com.mapbox.maps.extension.style.layers.properties.generated.LineTranslateAnchor
import com.mapbox.maps.pigeons.FLTPolylineAnnotationMessager

// FLT to Android

fun FLTPolylineAnnotationMessager.LineCap.toLineCap(): LineCap {
  return when (this) {
    FLTPolylineAnnotationMessager.LineCap.BUTT -> LineCap.BUTT
    FLTPolylineAnnotationMessager.LineCap.ROUND -> LineCap.ROUND
    FLTPolylineAnnotationMessager.LineCap.SQUARE -> LineCap.SQUARE
  }
}
fun FLTPolylineAnnotationMessager.LineJoin.toLineJoin(): LineJoin {
  return when (this) {
    FLTPolylineAnnotationMessager.LineJoin.BEVEL -> LineJoin.BEVEL
    FLTPolylineAnnotationMessager.LineJoin.ROUND -> LineJoin.ROUND
    FLTPolylineAnnotationMessager.LineJoin.MITER -> LineJoin.MITER
  }
}
fun FLTPolylineAnnotationMessager.LineTranslateAnchor.toLineTranslateAnchor(): LineTranslateAnchor {
  return when (this) {
    FLTPolylineAnnotationMessager.LineTranslateAnchor.MAP -> LineTranslateAnchor.MAP
    FLTPolylineAnnotationMessager.LineTranslateAnchor.VIEWPORT -> LineTranslateAnchor.VIEWPORT
  }
}

// Android to FLT

fun LineCap.toFLTLineCap(): FLTPolylineAnnotationMessager.LineCap {
  return when (this) {
    LineCap.BUTT -> FLTPolylineAnnotationMessager.LineCap.BUTT
    LineCap.ROUND -> FLTPolylineAnnotationMessager.LineCap.ROUND
    LineCap.SQUARE -> FLTPolylineAnnotationMessager.LineCap.SQUARE
    else -> throw(RuntimeException("Unsupported LineCap: $this"))
  }
}
fun LineJoin.toFLTLineJoin(): FLTPolylineAnnotationMessager.LineJoin {
  return when (this) {
    LineJoin.BEVEL -> FLTPolylineAnnotationMessager.LineJoin.BEVEL
    LineJoin.ROUND -> FLTPolylineAnnotationMessager.LineJoin.ROUND
    LineJoin.MITER -> FLTPolylineAnnotationMessager.LineJoin.MITER
    else -> throw(RuntimeException("Unsupported LineJoin: $this"))
  }
}
fun LineTranslateAnchor.toFLTLineTranslateAnchor(): FLTPolylineAnnotationMessager.LineTranslateAnchor {
  return when (this) {
    LineTranslateAnchor.MAP -> FLTPolylineAnnotationMessager.LineTranslateAnchor.MAP
    LineTranslateAnchor.VIEWPORT -> FLTPolylineAnnotationMessager.LineTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported LineTranslateAnchor: $this"))
  }
}