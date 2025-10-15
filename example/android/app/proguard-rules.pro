# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

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