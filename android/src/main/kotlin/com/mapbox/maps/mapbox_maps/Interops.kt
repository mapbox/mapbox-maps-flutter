package com.mapbox.maps.mapbox_maps

import androidx.annotation.Keep
import com.mapbox.common.MapboxOptions

@Keep
object MapboxOptions_Interops {

    @JvmStatic
    fun getAccessToken(): String {
        return MapboxOptions.accessToken
    }
}
