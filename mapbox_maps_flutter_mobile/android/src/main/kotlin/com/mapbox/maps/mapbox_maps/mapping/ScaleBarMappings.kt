// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.plugin.scalebar.generated.ScaleBarSettingsInterface

fun ScaleBarSettingsInterface.applyFromFLT(settings: ScaleBarSettings, context: Context) {
  updateSettings {
    settings.enabled?.let { this.enabled = it }
    settings.position?.let { this.position = it.toPosition() }
    settings.marginLeft?.let { this.marginLeft = it.toDevicePixels(context) }
    settings.marginTop?.let { this.marginTop = it.toDevicePixels(context) }
    settings.marginRight?.let { this.marginRight = it.toDevicePixels(context) }
    settings.marginBottom?.let { this.marginBottom = it.toDevicePixels(context) }
    settings.textColor?.let { this.textColor = it.toInt() }
    settings.primaryColor?.let { this.primaryColor = it.toInt() }
    settings.secondaryColor?.let { this.secondaryColor = it.toInt() }
    settings.borderWidth?.let { this.borderWidth = it.toDevicePixels(context) }
    settings.height?.let { this.height = it.toDevicePixels(context) }
    settings.textBarMargin?.let { this.textBarMargin = it.toDevicePixels(context) }
    settings.textBorderWidth?.let { this.textBorderWidth = it.toDevicePixels(context) }
    settings.textSize?.let { this.textSize = it.toFloat() }
    settings.isMetricUnits?.let { this.isMetricUnits = it }
    settings.refreshInterval?.let { this.refreshInterval = it }
    settings.showTextBorder?.let { this.showTextBorder = it }
    settings.ratio?.let { this.ratio = it.toFloat() }
    settings.useContinuousRendering?.let { this.useContinuousRendering = it }
  }
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