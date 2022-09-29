// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.scalebar.generated.ScaleBarSettingsInterface

fun ScaleBarSettingsInterface.applyFromFLT(settings: FLTSettings.ScaleBarSettings, context: Context) {
  settings.enabled?.let { enabled = it }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toFloat() }
  settings.marginTop?.let { marginTop = it.toFloat() }
  settings.marginRight?.let { marginRight = it.toFloat() }
  settings.marginBottom?.let { marginBottom = it.toFloat() }
  settings.textColor?.let { textColor = it.toInt() }
  settings.primaryColor?.let { primaryColor = it.toInt() }
  settings.secondaryColor?.let { secondaryColor = it.toInt() }
  settings.borderWidth?.let { borderWidth = it.toFloat() }
  settings.height?.let { height = it.toFloat() }
  settings.textBarMargin?.let { textBarMargin = it.toFloat() }
  settings.textBorderWidth?.let { textBorderWidth = it.toFloat() }
  settings.textSize?.let { textSize = it.toFloat() }
  settings.isMetricUnits?.let { isMetricUnits = it }
  settings.refreshInterval?.let { refreshInterval = it }
  settings.showTextBorder?.let { showTextBorder = it }
  settings.ratio?.let { ratio = it.toFloat() }
  settings.useContinuousRendering?.let { useContinuousRendering = it }
}

fun ScaleBarSettingsInterface.toFLT() = FLTSettings.ScaleBarSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toDouble())
  settings.setMarginTop(marginTop.toDouble())
  settings.setMarginRight(marginRight.toDouble())
  settings.setMarginBottom(marginBottom.toDouble())
  settings.setTextColor(textColor.toLong())
  settings.setPrimaryColor(primaryColor.toLong())
  settings.setSecondaryColor(secondaryColor.toLong())
  settings.setBorderWidth(borderWidth.toDouble())
  settings.setHeight(height.toDouble())
  settings.setTextBarMargin(textBarMargin.toDouble())
  settings.setTextBorderWidth(textBorderWidth.toDouble())
  settings.setTextSize(textSize.toDouble())
  settings.setIsMetricUnits(isMetricUnits)
  settings.setRefreshInterval(refreshInterval)
  settings.setShowTextBorder(showTextBorder)
  settings.setRatio(ratio.toDouble())
  settings.setUseContinuousRendering(useContinuousRendering)
  settings.build()
}

// End of generated file.