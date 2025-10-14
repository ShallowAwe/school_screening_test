# Existing auto-generated warnings (safe to keep)
-dontwarn okhttp3.Call
-dontwarn okhttp3.Dispatcher
-dontwarn okhttp3.OkHttpClient
-dontwarn okhttp3.Request$Builder
-dontwarn okhttp3.Request
-dontwarn okhttp3.Response
-dontwarn okhttp3.ResponseBody
-dontwarn okio.BufferedSource
-dontwarn okio.Okio
-dontwarn okio.Sink

# ✅ Add proper keep rules for uCrop, OkHttp, and Okio
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

-keep class okio.** { *; }
-keep interface okio.** { *; }
