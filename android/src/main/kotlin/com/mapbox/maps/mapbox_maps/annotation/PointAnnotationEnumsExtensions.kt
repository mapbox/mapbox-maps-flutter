// This file is generated.

import com.mapbox.maps.mapbox_maps.pigeons.*

// FLT to Android

fun IconAnchor.toIconAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor {
  return when (this) {
    IconAnchor.CENTER -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.CENTER
    IconAnchor.LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.LEFT
    IconAnchor.RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.RIGHT
    IconAnchor.TOP -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP
    IconAnchor.BOTTOM -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM
    IconAnchor.TOP_LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP_LEFT
    IconAnchor.TOP_RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP_RIGHT
    IconAnchor.BOTTOM_LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM_LEFT
    IconAnchor.BOTTOM_RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported IconAnchor: $this"))
  }
}
fun IconPitchAlignment.toIconPitchAlignment(): com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment {
  return when (this) {
    IconPitchAlignment.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.MAP
    IconPitchAlignment.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.VIEWPORT
    IconPitchAlignment.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconPitchAlignment: $this"))
  }
}
fun IconRotationAlignment.toIconRotationAlignment(): com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment {
  return when (this) {
    IconRotationAlignment.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.MAP
    IconRotationAlignment.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.VIEWPORT
    IconRotationAlignment.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconRotationAlignment: $this"))
  }
}
fun IconTextFit.toIconTextFit(): com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit {
  return when (this) {
    IconTextFit.NONE -> com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.NONE
    IconTextFit.WIDTH -> com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.WIDTH
    IconTextFit.HEIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.HEIGHT
    IconTextFit.BOTH -> com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.BOTH
    else -> throw(RuntimeException("Unsupported IconTextFit: $this"))
  }
}
fun SymbolPlacement.toSymbolPlacement(): com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement {
  return when (this) {
    SymbolPlacement.POINT -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.POINT
    SymbolPlacement.LINE -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.LINE
    SymbolPlacement.LINE_CENTER -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.LINE_CENTER
    else -> throw(RuntimeException("Unsupported SymbolPlacement: $this"))
  }
}
fun SymbolZOrder.toSymbolZOrder(): com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder {
  return when (this) {
    SymbolZOrder.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.AUTO
    SymbolZOrder.VIEWPORT_Y -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.VIEWPORT_Y
    SymbolZOrder.SOURCE -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.SOURCE
    else -> throw(RuntimeException("Unsupported SymbolZOrder: $this"))
  }
}
fun TextAnchor.toTextAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor {
  return when (this) {
    TextAnchor.CENTER -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.CENTER
    TextAnchor.LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.LEFT
    TextAnchor.RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.RIGHT
    TextAnchor.TOP -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP
    TextAnchor.BOTTOM -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM
    TextAnchor.TOP_LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP_LEFT
    TextAnchor.TOP_RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP_RIGHT
    TextAnchor.BOTTOM_LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM_LEFT
    TextAnchor.BOTTOM_RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported TextAnchor: $this"))
  }
}
fun TextJustify.toTextJustify(): com.mapbox.maps.extension.style.layers.properties.generated.TextJustify {
  return when (this) {
    TextJustify.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.AUTO
    TextJustify.LEFT -> com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.LEFT
    TextJustify.CENTER -> com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.CENTER
    TextJustify.RIGHT -> com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.RIGHT
    else -> throw(RuntimeException("Unsupported TextJustify: $this"))
  }
}
fun TextPitchAlignment.toTextPitchAlignment(): com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment {
  return when (this) {
    TextPitchAlignment.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.MAP
    TextPitchAlignment.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.VIEWPORT
    TextPitchAlignment.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextPitchAlignment: $this"))
  }
}
fun TextRotationAlignment.toTextRotationAlignment(): com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment {
  return when (this) {
    TextRotationAlignment.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.MAP
    TextRotationAlignment.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.VIEWPORT
    TextRotationAlignment.AUTO -> com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextRotationAlignment: $this"))
  }
}
fun TextTransform.toTextTransform(): com.mapbox.maps.extension.style.layers.properties.generated.TextTransform {
  return when (this) {
    TextTransform.NONE -> com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.NONE
    TextTransform.UPPERCASE -> com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.UPPERCASE
    TextTransform.LOWERCASE -> com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.LOWERCASE
    else -> throw(RuntimeException("Unsupported TextTransform: $this"))
  }
}
fun IconTranslateAnchor.toIconTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor {
  return when (this) {
    IconTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor.MAP
    IconTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported IconTranslateAnchor: $this"))
  }
}
fun SymbolElevationReference.toSymbolElevationReference(): com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference {
  return when (this) {
    SymbolElevationReference.SEA -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference.SEA
    SymbolElevationReference.GROUND -> com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference.GROUND
    else -> throw(RuntimeException("Unsupported SymbolElevationReference: $this"))
  }
}
fun TextTranslateAnchor.toTextTranslateAnchor(): com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor {
  return when (this) {
    TextTranslateAnchor.MAP -> com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor.MAP
    TextTranslateAnchor.VIEWPORT -> com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported TextTranslateAnchor: $this"))
  }
}

// Android to FLT

fun com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.toFLTIconAnchor(): IconAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.CENTER -> IconAnchor.CENTER
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.LEFT -> IconAnchor.LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.RIGHT -> IconAnchor.RIGHT
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP -> IconAnchor.TOP
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM -> IconAnchor.BOTTOM
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP_LEFT -> IconAnchor.TOP_LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.TOP_RIGHT -> IconAnchor.TOP_RIGHT
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM_LEFT -> IconAnchor.BOTTOM_LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor.BOTTOM_RIGHT -> IconAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported IconAnchor: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.toFLTIconPitchAlignment(): IconPitchAlignment {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.MAP -> IconPitchAlignment.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.VIEWPORT -> IconPitchAlignment.VIEWPORT
    com.mapbox.maps.extension.style.layers.properties.generated.IconPitchAlignment.AUTO -> IconPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconPitchAlignment: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.toFLTIconRotationAlignment(): IconRotationAlignment {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.MAP -> IconRotationAlignment.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.VIEWPORT -> IconRotationAlignment.VIEWPORT
    com.mapbox.maps.extension.style.layers.properties.generated.IconRotationAlignment.AUTO -> IconRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported IconRotationAlignment: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.toFLTIconTextFit(): IconTextFit {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.NONE -> IconTextFit.NONE
    com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.WIDTH -> IconTextFit.WIDTH
    com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.HEIGHT -> IconTextFit.HEIGHT
    com.mapbox.maps.extension.style.layers.properties.generated.IconTextFit.BOTH -> IconTextFit.BOTH
    else -> throw(RuntimeException("Unsupported IconTextFit: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.toFLTSymbolPlacement(): SymbolPlacement {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.POINT -> SymbolPlacement.POINT
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.LINE -> SymbolPlacement.LINE
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolPlacement.LINE_CENTER -> SymbolPlacement.LINE_CENTER
    else -> throw(RuntimeException("Unsupported SymbolPlacement: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.toFLTSymbolZOrder(): SymbolZOrder {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.AUTO -> SymbolZOrder.AUTO
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.VIEWPORT_Y -> SymbolZOrder.VIEWPORT_Y
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolZOrder.SOURCE -> SymbolZOrder.SOURCE
    else -> throw(RuntimeException("Unsupported SymbolZOrder: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.toFLTTextAnchor(): TextAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.CENTER -> TextAnchor.CENTER
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.LEFT -> TextAnchor.LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.RIGHT -> TextAnchor.RIGHT
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP -> TextAnchor.TOP
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM -> TextAnchor.BOTTOM
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP_LEFT -> TextAnchor.TOP_LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.TOP_RIGHT -> TextAnchor.TOP_RIGHT
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM_LEFT -> TextAnchor.BOTTOM_LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.TextAnchor.BOTTOM_RIGHT -> TextAnchor.BOTTOM_RIGHT
    else -> throw(RuntimeException("Unsupported TextAnchor: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.toFLTTextJustify(): TextJustify {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.AUTO -> TextJustify.AUTO
    com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.LEFT -> TextJustify.LEFT
    com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.CENTER -> TextJustify.CENTER
    com.mapbox.maps.extension.style.layers.properties.generated.TextJustify.RIGHT -> TextJustify.RIGHT
    else -> throw(RuntimeException("Unsupported TextJustify: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.toFLTTextPitchAlignment(): TextPitchAlignment {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.MAP -> TextPitchAlignment.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.VIEWPORT -> TextPitchAlignment.VIEWPORT
    com.mapbox.maps.extension.style.layers.properties.generated.TextPitchAlignment.AUTO -> TextPitchAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextPitchAlignment: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.toFLTTextRotationAlignment(): TextRotationAlignment {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.MAP -> TextRotationAlignment.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.VIEWPORT -> TextRotationAlignment.VIEWPORT
    com.mapbox.maps.extension.style.layers.properties.generated.TextRotationAlignment.AUTO -> TextRotationAlignment.AUTO
    else -> throw(RuntimeException("Unsupported TextRotationAlignment: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.toFLTTextTransform(): TextTransform {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.NONE -> TextTransform.NONE
    com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.UPPERCASE -> TextTransform.UPPERCASE
    com.mapbox.maps.extension.style.layers.properties.generated.TextTransform.LOWERCASE -> TextTransform.LOWERCASE
    else -> throw(RuntimeException("Unsupported TextTransform: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor.toFLTIconTranslateAnchor(): IconTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor.MAP -> IconTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.IconTranslateAnchor.VIEWPORT -> IconTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported IconTranslateAnchor: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference.toFLTSymbolElevationReference(): SymbolElevationReference {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference.SEA -> SymbolElevationReference.SEA
    com.mapbox.maps.extension.style.layers.properties.generated.SymbolElevationReference.GROUND -> SymbolElevationReference.GROUND
    else -> throw(RuntimeException("Unsupported SymbolElevationReference: $this"))
  }
}
fun com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor.toFLTTextTranslateAnchor(): TextTranslateAnchor {
  return when (this) {
    com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor.MAP -> TextTranslateAnchor.MAP
    com.mapbox.maps.extension.style.layers.properties.generated.TextTranslateAnchor.VIEWPORT -> TextTranslateAnchor.VIEWPORT
    else -> throw(RuntimeException("Unsupported TextTranslateAnchor: $this"))
  }
}