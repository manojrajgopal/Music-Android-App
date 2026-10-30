# youtubedl-android (MediaDownloader.kt) unpacks Python and ffmpeg with
# commons-compress and parses yt-dlp's JSON with Jackson; both create classes
# by reflection. R8 shrinks those classes in release builds and the library
# then fails on first use ("class ... is not a concrete class"), so every
# download fails.
-keep class com.yausername.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-keep class org.apache.commons.compress.** { *; }
-keep class org.apache.commons.io.** { *; }
-dontwarn org.apache.commons.compress.**
-dontwarn org.apache.commons.io.**
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
-dontwarn com.fasterxml.jackson.databind.**
-dontwarn java.beans.**
-dontwarn org.w3c.dom.bootstrap.**
