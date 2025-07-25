package com.mapbox.maps.mapbox_maps_example

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    companion object {
        private const val TAG = "MainActivity"
        
        init {
            try {
                System.loadLibrary("mapbox-maps-flutter-support")
                Log.d(TAG, "Successfully loaded mapbox-maps-flutter-support library")
            } catch (e: UnsatisfiedLinkError) {
                Log.e(TAG, "Failed to load mapbox-maps-flutter-support library", e)
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "MainActivity onCreate - Native library should be loaded")
    }
}