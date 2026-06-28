group = "com.mapbox.maps.mapbox_maps"
version = "1.0.0"

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://api.mapbox.com/downloads/v2/releases/maven")
        }
        maven {
            url = uri("https://api.mapbox.com/downloads/v2/snapshots/maven")
            authentication {
                register("basic", BasicAuthentication::class.java)
            }
            credentials {
                username = "mapbox"
                password = (System.getenv("SDK_REGISTRY_TOKEN") ?: (project.findProperty("SDK_REGISTRY_TOKEN") as? String)) ?: ""
            }
        }
    }
}

plugins {
    id("com.android.library")
}

android {
    compileSdk = 35

    namespace = "com.mapbox.maps.mapbox_maps"
    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }
    defaultConfig {
        minSdk = 21
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

val ktlintFile = file("$rootDir/gradle/ktlint.gradle")
val lintFile = file("$rootDir/gradle/lint.gradle")
if (ktlintFile.exists() && lintFile.exists()) {
    apply(from = ktlintFile)
    apply(from = lintFile)
}

dependencies {
    implementation("com.mapbox.maps:android-ndk27:11.25.0")
    implementation("androidx.annotation:annotation:1.5.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
}
