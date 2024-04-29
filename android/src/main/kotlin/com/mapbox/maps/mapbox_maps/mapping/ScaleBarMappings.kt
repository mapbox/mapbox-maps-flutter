// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.scalebar.generated.ScaleBarSettingsInterface

fun ScaleBarSettingsInterface.applyFromFLT(settings: ScaleBarSettings, context: Context) {
  settings.enabled?.let { enabled = it }
  settings.position?.let { position = it.toPosition() }
  settings.marginLeft?.let { marginLeft = it.toDevicePixels(context) }
  settings.marginTop?.let { marginTop = it.toDevicePixels(context) }
  settings.marginRight?.let { marginRight = it.toDevicePixels(context) }
  settings.marginBottom?.let { marginBottom = it.toDevicePixels(context) }
  settings.textColor?.let { textColor = it.toInt() }
  settings.primaryColor?.let { primaryColor = it.toInt() }
  settings.secondaryColor?.let { secondaryColor = it.toInt() }
  settings.borderWidth?.let { borderWidth = it.toDevicePixels(context) }
  settings.height?.let { height = it.toDevicePixels(context) }
  settings.textBarMargin?.let { textBarMargin = it.toDevicePixels(context) }
  settings.textBorderWidth?.let { textBorderWidth = it.toDevicePixels(context) }
  settings.textSize?.let { textSize = it.toFloat() }
  settings.isMetricUnits?.let { isMetricUnits = it }
  settings.refreshInterval?.let { refreshInterval = it }
  settings.showTextBorder?.let { showTextBorder = it }
  settings.ratio?.let { ratio = it.toFloat() }
  settings.useContinuousRendering?.let { useContinuousRendering = it }
}

fun ScaleBarSettingsInterface.toFLT(context: Context) = ScaleBarSettings(
  enabled = enabled,
  position = position.toOrnamentPosition(),
  marginLeft = marginLeft.toLogicalPixels(context),
  marginTop = marginTop.toLogicalPixels(context),
  marginRight = marginRight.toLogicalPixels(context),
  marginBottom = marginBottom.toLogicalPixels(context),
  textColor = textColor.toUInt().toLong(),
  primaryColor = primaryColor.toUInt().toLong(),
  secondaryColor = secondaryColor.toUInt().toLong(),
  borderWidth = borderWidth.toLogicalPixels(context),
  height = height.toLogicalPixels(context),
  textBarMargin = textBarMargin.toLogicalPixels(context),
  textBorderWidth = textBorderWidth.toLogicalPixels(context),
  textSize = textSize.toDouble(),
  isMetricUnits = isMetricUnits,
  refreshInterval = refreshInterval,
  showTextBorder = showTextBorder,
  ratio = ratio.toDouble(),
  useContinuousRendering = useContinuousRendering,
)

// End of generated file.