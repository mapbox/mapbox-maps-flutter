// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.attribution.generated.AttributionSettingsInterface

fun AttributionSettingsInterface.applyFromFLT(settings: FLTSettings.AttributionSettings, context: Context) {
  settings.iconColor?.let { iconColor = it.toInt() }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toFloat() }
  settings.marginTop?.let { marginTop = it.toFloat() }
  settings.marginRight?.let { marginRight = it.toFloat() }
  settings.marginBottom?.let { marginBottom = it.toFloat() }
  settings.clickable?.let { clickable = it }
}

fun AttributionSettingsInterface.toFLT() = FLTSettings.AttributionSettings.Builder().let { settings ->
  settings.setIconColor(iconColor.toLong())
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toDouble())
  settings.setMarginTop(marginTop.toDouble())
  settings.setMarginRight(marginRight.toDouble())
  settings.setMarginBottom(marginBottom.toDouble())
  settings.setClickable(clickable)
  settings.build()
}

// End of generated file.