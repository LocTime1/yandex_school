plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ← Добавляем сразу после plugins
configurations.all {
    // убираем дублирование класса androidx.annotation.experimental.R
    exclude(group = "androidx.annotation", module = "annotation-experimental")
}

android {
    namespace = "com.example.yandex_homework_1"
    compileSdk = flutter.compileSdkVersion

    // ← Явно указываем NDK версии 27.x, которой совместимы ваши плагины
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.yandex_homework_1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
