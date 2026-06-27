# ML Kit Face Detection
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }
-dontwarn com.google.mlkit.**

# TFLite
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# JNI native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**