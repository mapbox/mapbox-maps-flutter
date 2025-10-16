# Keep Mapbox lifecycle plugin
-keep class com.mapbox.maps.plugin.lifecycle.MapboxLifecyclePluginImpl { *; }
-keep class com.mapbox.maps.plugin.lifecycle.* { *; }
-keep class com.mapbox.maps.plugin.** { *; }
-keep class com.mapbox.maps.** { *; }

# Keep Flutter plugin classes
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Google Play Core classes (for Flutter deferred components)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }