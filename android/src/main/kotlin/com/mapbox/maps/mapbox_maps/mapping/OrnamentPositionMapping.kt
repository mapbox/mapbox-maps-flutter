package com.mapbox.maps.mapbox_maps.mapping

import android.view.Gravity
import com.mapbox.maps.pigeons.FLTSettings

fun FLTSettings.OrnamentPosition.toPosition(): Int {
  return when (this) {
    FLTSettings.OrnamentPosition.BOTTOM_LEFT -> Gravity.BOTTOM or Gravity.START
    FLTSettings.OrnamentPosition.BOTTOM_RIGHT -> Gravity.BOTTOM or Gravity.END
    FLTSettings.OrnamentPosition.TOP_LEFT -> Gravity.TOP or Gravity.START
    FLTSettings.OrnamentPosition.TOP_RIGHT -> Gravity.TOP or Gravity.END
  }
}

fun Int.toOrnamentPosition(): FLTSettings.OrnamentPosition {
  return when (this) {
    Gravity.BOTTOM or Gravity.START -> FLTSettings.OrnamentPosition.BOTTOM_LEFT
    Gravity.BOTTOM or Gravity.END -> FLTSettings.OrnamentPosition.BOTTOM_RIGHT
    Gravity.TOP or Gravity.START -> FLTSettings.OrnamentPosition.TOP_LEFT
    else -> {
      FLTSettings.OrnamentPosition.TOP_RIGHT
    }
  }
}