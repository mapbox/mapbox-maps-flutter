package com.mapbox.maps.mapbox_maps.mapping

import android.view.Gravity
import com.mapbox.maps.mapbox_maps.pigeons.OrnamentPosition

fun OrnamentPosition.toPosition(): Int {
  return when (this) {
    OrnamentPosition.BOTTOM_LEFT -> Gravity.BOTTOM or Gravity.START
    OrnamentPosition.BOTTOM_RIGHT -> Gravity.BOTTOM or Gravity.END
    OrnamentPosition.TOP_LEFT -> Gravity.TOP or Gravity.START
    OrnamentPosition.TOP_RIGHT -> Gravity.TOP or Gravity.END
  }
}

fun Int.toOrnamentPosition(): OrnamentPosition {
  return when (this) {
    Gravity.BOTTOM or Gravity.START -> OrnamentPosition.BOTTOM_LEFT
    Gravity.BOTTOM or Gravity.END -> OrnamentPosition.BOTTOM_RIGHT
    Gravity.TOP or Gravity.START -> OrnamentPosition.TOP_LEFT
    else -> {
      OrnamentPosition.TOP_RIGHT
    }
  }
}