// This file is generated.
package com.mapbox.maps.mapbox_maps.mapping

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import com.mapbox.maps.mapbox_maps.toDevicePixels
import com.mapbox.maps.mapbox_maps.toLogicalPixels
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.scalebar.generated.ScaleBarSettingsInterface
import java.io.ByteArrayOutputStream

fun ScaleBarSettingsInterface.applyFromFLT(settings: FLTSettings.ScaleBarSettings, context: Context) {
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

fun ScaleBarSettingsInterface.toFLT(context: Context) = FLTSettings.ScaleBarSettings.Builder().let { settings ->
  settings.setEnabled(enabled)
  settings.setPosition(position.toOrnamentPosition())
  settings.setMarginLeft(marginLeft.toLogicalPixels(context))
  settings.setMarginTop(marginTop.toLogicalPixels(context))
  settings.setMarginRight(marginRight.toLogicalPixels(context))
  settings.setMarginBottom(marginBottom.toLogicalPixels(context))
  settings.setTextColor(textColor.toUInt().toLong())
  settings.setPrimaryColor(primaryColor.toUInt().toLong())
  settings.setSecondaryColor(secondaryColor.toUInt().toLong())
  settings.setBorderWidth(borderWidth.toLogicalPixels(context))
  settings.setHeight(height.toLogicalPixels(context))
  settings.setTextBarMargin(textBarMargin.toLogicalPixels(context))
  settings.setTextBorderWidth(textBorderWidth.toLogicalPixels(context))
  settings.setTextSize(textSize.toDouble())
  settings.setIsMetricUnits(isMetricUnits)
  settings.setRefreshInterval(refreshInterval)
  settings.setShowTextBorder(showTextBorder)
  settings.setRatio(ratio.toDouble())
  settings.setUseContinuousRendering(useContinuousRendering)
  settings.build()
}

// End of generated file.
