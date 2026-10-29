plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "app.cadence.cadence"
    // permission_handler_android requires compiling against API 37.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Change before publishing if you own a different package namespace.
        applicationId = "app.cadence.cadence"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// Every release build (`flutter build apk --release`) also saves the APK as
// music.apk next to app-release.apk in build/app/outputs/flutter-apk.
val releaseApk = layout.buildDirectory.file("outputs/apk/release/app-release.apk")
val musicApk = layout.buildDirectory.file("outputs/flutter-apk/music.apk")
tasks.matching { it.name == "assembleRelease" }.configureEach {
    doLast {
        val apk = releaseApk.get().asFile
        if (!apk.exists()) throw GradleException("Release APK not found at $apk")
        val target = musicApk.get().asFile
        apk.copyTo(target, overwrite = true)
        println("Saved release APK as $target")
    }
}
