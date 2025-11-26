# Suppress warnings from common annotations
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn org.bouncycastle.**

# XML parsing support
-keep class org.xmlpull.v1.** { *; }

# ML Kit Text Recognition
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.common.model.** { *; }
-dontwarn com.google.mlkit.vision.text.**
-keepattributes *Annotation*

# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
# If Razorpay SDK uses proguard.annotation.*
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# OverlayService
-keep class com.dexbytes.asetize.OverlayService { *; }

# Serializable class rules
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    private java.lang.Object readResolve();
}

# Kotlin support
-keep class kotlin.Metadata { *; }
-keep class kotlin.coroutines.** { *; }
-dontwarn kotlin.**

# Flutter support
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Prevent removal of generated BuildConfig
-keep class **.BuildConfig { *; }

# Preserve generic type info
-keepattributes Signature
