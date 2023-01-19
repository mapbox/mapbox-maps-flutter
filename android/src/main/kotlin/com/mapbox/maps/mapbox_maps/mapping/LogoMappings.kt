// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.logo.generated.LogoSettingsInterface

fun LogoSettingsInterface.applyFromFLT(settings: FLTSettings.LogoSettings, context: Context) {
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toFloat() }
  settings.marginTop?.let { marginTop = it.toFloat() }
  settings.marginRight?.let { marginRight = it.toFloat() }
  settings.marginBottom?.let { marginBottom = it.toFloat() }
}

fun LogoSettingsInterface.toFLT() = FLTSettings.LogoSettings.Builder().let { settings ->
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toDouble())
  settings.setMarginTop(marginTop.toDouble())
  settings.setMarginRight(marginRight.toDouble())
  settings.setMarginBottom(marginBottom.toDouble())
  settings.build()
}

// End of generated file.