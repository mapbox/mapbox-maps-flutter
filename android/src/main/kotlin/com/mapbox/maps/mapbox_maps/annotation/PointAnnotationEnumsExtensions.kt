// This file is generated.

import com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor
import com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment
import com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment
import com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit
import com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor
import com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement
import com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder
import com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor
import com.mapbox.maps.extension.style.layers.properties.generated.TextJustify
import com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment
import com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment
import com.mapbox.maps.extension.style.layers.properties.generated.TextTransform
import com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor
import com.mapbox.maps.pigeons.FLTPointAnnotationMessager

// FLT to Android

fun FLTPointAnnotationMessager.IconAnchor.toIconAnchor(): IconAnchor {
  return when (this) {
    FLTPointAnnotationMessager.IconAnchor.CENTER -> IconAnchor.CENTER
    FLTPointAnnotationMessager.IconAnchor.LEFT -> IconAnchor.LEFT
    FLTPointAnnotationMessager.IconAnchor.RIGHT -> IconAnchor.RIGHT
    FLTPointAnnotationMessager.IconAnchor.TOP -> IconAnchor.TOP
    FLTPointAnnotationMessager.IconAnchor.BOTTOM -> IconAnchor.BOTTOM
    FLTPointAnnotationMessager.IconAnchor.TOP_LEFT -> IconAnchor.TOP_LEFT
    FLTPointAnnotationMessager.IconAnchor.TOP_RIGHT -> IconAnchor.TOP_RIGHT
    FLTPointAnnotationMessager.IconAnchor.BOTTOM_LEFT -> IconAnchor.BOTTOM_LEFT
    FLTPointAnnotationMessager.IconAnchor.BOTTOM_RIGHT -> IconAnchor.BOTTOM_RIGHT
  }
}
fun FLTPointAnnotationMessager.IconPitchAlignment.toIconPitchAlignment(): IconPitchAlignment {
  return when (this) {
    FLTPointAnnotationMessager.IconPitchAlignment.MAP -> IconPitchAlignment.MAP
    FLTPointAnnotationMessager.IconPitchAlignment.VIEWPORT -> IconPitchAlignment.VIEWPORT
    FLTPointAnnotationMessager.IconPitchAlignment.AUTO -> IconPitchAlignment.AUTO
  }
}
fun FLTPointAnnotationMessager.IconRotationAlignment.toIconRotationAlignment(): IconRotationAlignment {
  return when (this) {
    FLTPointAnnotationMessager.IconRotationAlignment.MAP -> IconRotationAlignment.MAP
    FLTPointAnnotationMessager.IconRotationAlignment.VIEWPORT -> IconRotationAlignment.VIEWPORT
    FLTPointAnnotationMessager.IconRotationAlignment.AUTO -> IconRotationAlignment.AUTO
  }
}
fun FLTPointAnnotationMessager.IconTextFit.toIconTextFit(): IconTextFit {
  return when (this) {
    FLTPointAnnotationMessager.IconTextFit.NONE -> IconTextFit.NONE
    FLTPointAnnotationMessager.IconTextFit.WIDTH -> IconTextFit.WIDTH
    FLTPointAnnotationMessager.IconTextFit.HEIGHT -> IconTextFit.HEIGHT
    FLTPointAnnotationMessager.IconTextFit.BOTH -> IconTextFit.BOTH
  }
}
fun FLTPointAnnotationMessager.SymbolPlacement.toSymbolPlacement(): SymbolPlacement {
  return when (this) {
    FLTPointAnnotationMessager.SymbolPlacement.POINT -> SymbolPlacement.POINT
    FLTPointAnnotationMessager.SymbolPlacement.LINE -> SymbolPlacement.LINE
    FLTPointAnnotationMessager.SymbolPlacement.LINE_CENTER -> SymbolPlacement.LINE_CENTER
  }
}
fun FLTPointAnnotationMessager.SymbolZOrder.toSymbolZOrder(): SymbolZOrder {
  return when (this) {
    FLTPointAnnotationMessager.SymbolZOrder.AUTO -> SymbolZOrder.AUTO
    FLTPointAnnotationMessager.SymbolZOrder.VIEWPORT_Y -> SymbolZOrder.VIEWPORT_Y
    FLTPointAnnotationMessager.SymbolZOrder.SOURCE -> SymbolZOrder.SOURCE
  }
}
fun FLTPointAnnotationMessager.TextAnchor.toTextAnchor(): TextAnchor {
  return when (this) {
    FLTPointAnnotationMessager.TextAnchor.CENTER -> TextAnchor.CENTER
    FLTPointAnnotationMessager.TextAnchor.LEFT -> TextAnchor.LEFT
    FLTPointAnnotationMessager.TextAnchor.RIGHT -> TextAnchor.RIGHT
    FLTPointAnnotationMessager.TextAnchor.TOP -> TextAnchor.TOP
    FLTPointAnnotationMessager.TextAnchor.BOTTOM -> TextAnchor.BOTTOM
    FLTPointAnnotationMessager.TextAnchor.TOP_LEFT -> TextAnchor.TOP_LEFT
    FLTPointAnnotationMessager.TextAnchor.TOP_RIGHT -> TextAnchor.TOP_RIGHT
    FLTPointAnnotationMessager.TextAnchor.BOTTOM_LEFT -> TextAnchor.BOTTOM_LEFT
    FLTPointAnnotationMessager.TextAnchor.BOTTOM_RIGHT -> TextAnchor.BOTTOM_RIGHT
  }
}
fun FLTPointAnnotationMessager.TextJustify.toTextJustify(): TextJustify {
  return when (this) {
    FLTPointAnnotationMessager.TextJustify.AUTO -> TextJustify.AUTO
    FLTPointAnnotationMessager.TextJustify.LEFT -> TextJustify.LEFT
    FLTPointAnnotationMessager.TextJustify.CENTER -> TextJustify.CENTER
    FLTPointAnnotationMessager.TextJustify.RIGHT -> TextJustify.RIGHT
  }
}
fun FLTPointAnnotationMessager.TextPitchAlignment.toTextPitchAlignment(): TextPitchAlignment {
  return when (this) {
    FLTPointAnnotationMessager.TextPitchAlignment.MAP -> TextPitchAlignment.MAP
    FLTPointAnnotationMessager.TextPitchAlignment.VIEWPORT -> TextPitchAlignment.VIEWPORT
    FLTPointAnnotationMessager.TextPitchAlignment.AUTO -> TextPitchAlignment.AUTO
  }
}
fun FLTPointAnnotationMessager.TextRotationAlignment.toTextRotationAlignment(): TextRotationAlignment {
  return when (this) {
    FLTPointAnnotationMessager.TextRotationAlignment.MAP -> TextRotationAlignment.MAP
    FLTPointAnnotationMessager.TextRotationAlignment.VIEWPORT -> TextRotationAlignment.VIEWPORT
    FLTPointAnnotationMessager.TextRotationAlignment.AUTO -> TextRotationAlignment.AUTO
  }
}
fun FLTPointAnnotationMessager.TextTransform.toTextTransform(): TextTransform {
  return when (this) {
    FLTPointAnnotationMessager.TextTransform.NONE -> TextTransform.NONE
    FLTPointAnnotationMessager.TextTransform.UPPERCASE -> TextTransform.UPPERCASE
    FLTPointAnnotationMessager.TextTransform.LOWERCASE -> TextTransform.LOWERCASE
  }
}
fun FLTPointAnnotationMessager.IconTranslateAnchor.toIconTranslateAnchor(): IconTranslateAnchor {
  return when (this) {
    FLTPointAnnotationMessager.IconTranslateAnchor.MAP -> IconTranslateAnchor.MAP
    FLTPointAnnotationMessager.IconTranslateAnchor.VIEWPORT -> IconTranslateAnchor.VIEWPORT
  }
}
fun FLTPointAnnotationMessager.TextTranslateAnchor.toTextTranslateAnchor(): TextTranslateAnchor {
  return when (this) {
    FLTPointAnnotationMessager.TextTranslateAnchor.MAP -> TextTranslateAnchor.MAP
    FLTPointAnnotationMessager.TextTranslateAnchor.VIEWPORT -> TextTranslateAnchor.VIEWPORT
  }
}

// Android to FLT

fun IconAnchor.toFLTIconAnchor(): FLTPointAnnotationMessager.IconAnchor {
  return when (this) {
    IconAnchor.CENTER -> FLTPointAnnotationMessager.IconAnchor.CENTER
    IconAnchor.LEFT -> FLTPointAnnotationMessager.IconAnchor.LEFT
    IconAnchor.RIGHT -> FLTPointAnnotationMessager.IconAnchor.RIGHT
    IconAnchor.TOP -> FLTPointAnnotationMessager.IconAnchor.TOP
    IconAnchor.BOTTOM -> FLTPointAnnotationMessager.IconAnchor.BOTTOM
    IconAnchor.TOP_LEFT -> FLTPointAnnotationMessager.IconAnchor.TOP_LEFT
    IconAnchor.TOP_RIGHT -> FLTPointAnnotationMessager.IconAnchor.TOP_RIGHT
    IconAnchor.BOTTOM_LEFT -> FLTPointAnnotationMessager.IconAnchor.BOTTOM_LEFT
    IconAnchor.BOTTOM_RIGHT -> FLTPointAnnotationMessager.IconAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported IconAnchor: $this"))
  }
}
fun IconPitchAlignment.toFLTIconPitchAlignment(): FLTPointAnnotationMessager.IconPitchAlignment {
  return when (this) {
    IconPitchAlignment.MAP -> FLTPointAnnotationMessager.IconPitchAlignment.MAP
    IconPitchAlignment.VIEWPORT -> FLTPointAnnotationMessager.IconPitchAlignment.VIEWPORT
    IconPitchAlignment.AUTO -> FLTPointAnnotationMessager.IconPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconPitchAlignment: $this"))
  }
}
fun IconRotationAlignment.toFLTIconRotationAlignment(): FLTPointAnnotationMessager.IconRotationAlignment {
  return when (this) {
    IconRotationAlignment.MAP -> FLTPointAnnotationMessager.IconRotationAlignment.MAP
    IconRotationAlignment.VIEWPORT -> FLTPointAnnotationMessager.IconRotationAlignment.VIEWPORT
    IconRotationAlignment.AUTO -> FLTPointAnnotationMessager.IconRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconRotationAlignment: $this"))
  }
}
fun IconTextFit.toFLTIconTextFit(): FLTPointAnnotationMessager.IconTextFit {
  return when (this) {
    IconTextFit.NONE -> FLTPointAnnotationMessager.IconTextFit.NONE
    IconTextFit.WIDTH -> FLTPointAnnotationMessager.IconTextFit.WIDTH
    IconTextFit.HEIGHT -> FLTPointAnnotationMessager.IconTextFit.HEIGHT
    IconTextFit.BOTH -> FLTPointAnnotationMessager.IconTextFit.BOTH
    else -> throw(RuntimeException("Unsupported IconTextFit: $this"))
  }
}
fun SymbolPlacement.toFLTSymbolPlacement(): FLTPointAnnotationMessager.SymbolPlacement {
  return when (this) {
    SymbolPlacement.POINT -> FLTPointAnnotationMessager.SymbolPlacement.POINT
    SymbolPlacement.LINE -> FLTPointAnnotationMessager.SymbolPlacement.LINE
    SymbolPlacement.LINE_CENTER -> FLTPointAnnotationMessager.SymbolPlacement.LINE_CENTER
    else -> throw(RuntimeException("Unsupported SymbolPlacement: $this"))
  }
}
fun SymbolZOrder.toFLTSymbolZOrder(): FLTPointAnnotationMessager.SymbolZOrder {
  return when (this) {
    SymbolZOrder.AUTO -> FLTPointAnnotationMessager.SymbolZOrder.AUTO
    SymbolZOrder.VIEWPORT_Y -> FLTPointAnnotationMessager.SymbolZOrder.VIEWPORT_Y
    SymbolZOrder.SOURCE -> FLTPointAnnotationMessager.SymbolZOrder.SOURCE
    else -> throw(RuntimeException("Unsupported SymbolZOrder: $this"))
  }
}
fun TextAnchor.toFLTTextAnchor(): FLTPointAnnotationMessager.TextAnchor {
  return when (this) {
    TextAnchor.CENTER -> FLTPointAnnotationMessager.TextAnchor.CENTER
    TextAnchor.LEFT -> FLTPointAnnotationMessager.TextAnchor.LEFT
    TextAnchor.RIGHT -> FLTPointAnnotationMessager.TextAnchor.RIGHT
    TextAnchor.TOP -> FLTPointAnnotationMessager.TextAnchor.TOP
    TextAnchor.BOTTOM -> FLTPointAnnotationMessager.TextAnchor.BOTTOM
    TextAnchor.TOP_LEFT -> FLTPointAnnotationMessager.TextAnchor.TOP_LEFT
    TextAnchor.TOP_RIGHT -> FLTPointAnnotationMessager.TextAnchor.TOP_RIGHT
    TextAnchor.BOTTOM_LEFT -> FLTPointAnnotationMessager.TextAnchor.BOTTOM_LEFT
    TextAnchor.BOTTOM_RIGHT -> FLTPointAnnotationMessager.TextAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported TextAnchor: $this"))
  }
}
fun TextJustify.toFLTTextJustify(): FLTPointAnnotationMessager.TextJustify {
  return when (this) {
    TextJustify.AUTO -> FLTPointAnnotationMessager.TextJustify.AUTO
    TextJustify.LEFT -> FLTPointAnnotationMessager.TextJustify.LEFT
    TextJustify.CENTER -> FLTPointAnnotationMessager.TextJustify.CENTER
    TextJustify.RIGHT -> FLTPointAnnotationMessager.TextJustify.RIGHT
    else -> throw(RuntimeException("Unsupported TextJustify: $this"))
  }
}
fun TextPitchAlignment.toFLTTextPitchAlignment(): FLTPointAnnotationMessager.TextPitchAlignment {
  return when (this) {
    TextPitchAlignment.MAP -> FLTPointAnnotationMessager.TextPitchAlignment.MAP
    TextPitchAlignment.VIEWPORT -> FLTPointAnnotationMessager.TextPitchAlignment.VIEWPORT
    TextPitchAlignment.AUTO -> FLTPointAnnotationMessager.TextPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextPitchAlignment: $this"))
  }
}
fun TextRotationAlignment.toFLTTextRotationAlignment(): FLTPointAnnotationMessager.TextRotationAlignment {
  return when (this) {
    TextRotationAlignment.MAP -> FLTPointAnnotationMessager.TextRotationAlignment.MAP
    TextRotationAlignment.VIEWPORT -> FLTPointAnnotationMessager.TextRotationAlignment.VIEWPORT
    TextRotationAlignment.AUTO -> FLTPointAnnotationMessager.TextRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextRotationAlignment: $this"))
  }
}
fun TextTransform.toFLTTextTransform(): FLTPointAnnotationMessager.TextTransform {
  return when (this) {
    TextTransform.NONE -> FLTPointAnnotationMessager.TextTransform.NONE
    TextTransform.UPPERCASE -> FLTPointAnnotationMessager.TextTransform.UPPERCASE
    TextTransform.LOWERCASE -> FLTPointAnnotationMessager.TextTransform.LOWERCASE
    else -> throw(RuntimeException("Unsupported TextTransform: $this"))
  }
}
fun IconTranslateAnchor.toFLTIconTranslateAnchor(): FLTPointAnnotationMessager.IconTranslateAnchor {
  return when (this) {
    IconTranslateAnchor.MAP -> FLTPointAnnotationMessager.IconTranslateAnchor.MAP
    IconTranslateAnchor.VIEWPORT -> FLTPointAnnotationMessager.IconTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported IconTranslateAnchor: $this"))
  }
}
fun TextTranslateAnchor.toFLTTextTranslateAnchor(): FLTPointAnnotationMessager.TextTranslateAnchor {
  return when (this) {
    TextTranslateAnchor.MAP -> FLTPointAnnotationMessager.TextTranslateAnchor.MAP
    TextTranslateAnchor.VIEWPORT -> FLTPointAnnotationMessager.TextTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported TextTranslateAnchor: $this"))
  }
}