package app.cadence.cadence

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.yausername.ffmpeg.FFmpeg
import com.yausername.youtubedl_android.YoutubeDL
import com.yausername.youtubedl_android.YoutubeDLRequest
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.File
import java.util.Collections
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

/**
 * Saves the best audio a link offers, using yt-dlp and ffmpeg bundled in the
 * APK. Covers YouTube (videos, Shorts, YouTube Music), Instagram, TikTok, X,
 * Facebook, SoundCloud, direct files and the other sites yt-dlp reads.
 *
 * The format choice follows the server module this was modelled on: take the
 * best audio-only stream (falling back to the best complete file), ranked by
 * audio bitrate, then let ffmpeg pull the audio out in its own codec — no
 * re-encode, so nothing is lost.
 *
 * Sites change often and an old extractor is the usual cause of a failed
 * download, so yt-dlp is updated daily, and a failed download updates it and
 * tries again before giving up.
 */
class MediaDownloader(private val context: Context, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    private val main = Handler(Looper.getMainLooper())

    // One worker: downloads and the extractor update never overlap, so an
    // update cannot replace yt-dlp underneath a running download.
    private val worker = Executors.newSingleThreadExecutor()
    private val cancelled = Collections.synchronizedSet(HashSet<String>())
    private var ready = false
    private var forcedUpdate = false

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "warmUp" -> {
                worker.execute {
                    runCatching { ensureReady(); refreshExtractor(force = false) }
                }
                result.success(null)
            }
            "download" -> {
                val url = call.argument<String>("url")!!
                val id = call.argument<String>("id")!!
                val dir = File(call.argument<String>("dir")!!)
                worker.execute {
                    try {
                        val saved = download(url, id, dir)
                        main.post { result.success(saved) }
                    } catch (e: YoutubeDL.CanceledException) {
                        main.post { result.error("cancelled", "Download cancelled.", null) }
                    } catch (e: Throwable) {
                        Log.e(TAG, "Download failed for $url", e)
                        main.post { result.error("failed", e.message ?: e.toString(), null) }
                    } finally {
                        cancelled.remove(id)
                    }
                }
            }
            "cancel" -> {
                val id = call.argument<String>("id")!!
                cancelled.add(id)
                YoutubeDL.getInstance().destroyProcessById(id)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun ensureReady() {
        if (ready) return
        YoutubeDL.getInstance().init(context)
        FFmpeg.getInstance().init(context)
        ready = true
    }

    /**
     * Updates yt-dlp from its GitHub releases: once a day normally, or right
     * away (nightly channel, at most once per app run) after a failure.
     */
    private fun refreshExtractor(force: Boolean) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val last = prefs.getLong(KEY_UPDATED_AT, 0)
        if (force) {
            if (forcedUpdate) return
            forcedUpdate = true
        } else if (System.currentTimeMillis() - last < UPDATE_INTERVAL_MS) {
            return
        }
        val channel = if (force) YoutubeDL.UpdateChannel.NIGHTLY else YoutubeDL.UpdateChannel.STABLE
        // The updater opens connections without a read timeout; bound it so a
        // stalled GitHub request cannot hold up the download.
        val updater = Executors.newSingleThreadExecutor()
        try {
            updater.submit { YoutubeDL.getInstance().updateYoutubeDL(context, channel) }
                .get(UPDATE_TIMEOUT_S, TimeUnit.SECONDS)
            prefs.edit().putLong(KEY_UPDATED_AT, System.currentTimeMillis()).apply()
        } catch (e: Exception) {
            // Keep the current extractor; it may still handle this link.
            Log.w(TAG, "yt-dlp update failed", e)
        } finally {
            updater.shutdown()
        }
    }

    private fun download(url: String, id: String, dir: File): Map<String, Any?> {
        ensureReady()
        refreshExtractor(force = false)
        var failure: Exception? = null
        // 1: best audio, tagged, with cover art. 2: same after a forced
        // update. 3: plain m4a with no extras, for sources the extras trip on.
        for (attempt in 1..3) {
            if (attempt == 2) refreshExtractor(force = true)
            if (id in cancelled) throw YoutubeDL.CanceledException()
            try {
                return runOnce(url, id, dir, plain = attempt == 3)
            } catch (e: YoutubeDL.CanceledException) {
                throw e
            } catch (e: Exception) {
                if (id in cancelled) throw YoutubeDL.CanceledException()
                Log.w(TAG, "Download attempt $attempt failed for $url", e)
                failure = e
            }
        }
        throw failure!!
    }

    private fun runOnce(url: String, id: String, dir: File, plain: Boolean): Map<String, Any?> {
        dir.deleteRecursively()
        dir.mkdirs()
        val request = YoutubeDLRequest(url)
            .addOption("-f", "bestaudio/best")
            // The audio half of the server's QUALITY_SORT: highest bitrate wins.
            .addOption("-S", "abr,br,size")
            .addOption("-x")
            .addOption("--audio-format", if (plain) "m4a" else "best")
            .addOption("--audio-quality", "0")
            .addOption("--no-playlist")
            .addOption("--newline")
            .addOption("--no-mtime")
            .addOption("--retries", 10)
            .addOption("--fragment-retries", 10)
            .addOption("--socket-timeout", 20)
            .addOption("--write-info-json")
            // Fixed names inside a private folder: a remote title never
            // becomes a path. The real name is built from the title in Dart.
            .addOption("-o", "${dir.absolutePath}/media.%(ext)s")
            .addOption("-o", "infojson:${dir.absolutePath}/info")
        if (!plain) {
            request
                .addOption("--embed-metadata")
                .addOption("--write-thumbnail")
                .addOption("--convert-thumbnails", "jpg")
                .addOption("-o", "thumbnail:${dir.absolutePath}/cover.%(ext)s")
        }
        YoutubeDL.getInstance().execute(request, id) { progress, _, line ->
            val value: Double? = when {
                line.startsWith("[download]") && progress >= 0 -> progress / 100.0
                else -> null
            }
            if (value != null || line.startsWith("[ExtractAudio]")) {
                main.post { channel.invokeMethod("progress", mapOf("id" to id, "progress" to value)) }
            }
        }

        val media = pickOutput(dir)
        if (!plain && media.extension.lowercase() !in AUDIO_EXTENSIONS) {
            throw IllegalStateException("Unexpected container .${media.extension}")
        }
        val info = File(dir, "info.info.json").takeIf { it.isFile }
            ?.let { runCatching { JSONObject(it.readText()) }.getOrNull() }
        val cover = File(dir, "cover.jpg").takeIf { it.isFile && it.length() > 0 }
        return mapOf(
            "path" to media.absolutePath,
            "ext" to media.extension.lowercase(),
            "title" to info?.text("track", "title", "fulltitle"),
            "artist" to info?.text("artist", "creator", "uploader", "channel"),
            "album" to info?.text("album"),
            "durationMs" to info?.optDouble("duration")?.takeIf { !it.isNaN() }?.let { (it * 1000).toLong() },
            "cover" to cover?.absolutePath,
        )
    }

    /** The finished file among whatever yt-dlp left in the folder: the largest non-side-car. */
    private fun pickOutput(dir: File): File {
        val files = dir.listFiles().orEmpty().filter {
            it.isFile && it.length() > 0 &&
                !it.name.endsWith(".part") && !it.name.endsWith(".ytdl") && !it.name.endsWith(".temp") &&
                it.extension.lowercase() !in SIDECAR_EXTENSIONS
        }
        return files.maxByOrNull { it.length() } ?: throw IllegalStateException("The download produced no file")
    }

    private fun JSONObject.text(vararg keys: String): String? =
        keys.firstNotNullOfOrNull { key -> optString(key).takeIf { has(key) && !isNull(key) && it.isNotBlank() } }

    companion object {
        const val CHANNEL = "cadence/media_downloader"
        private const val TAG = "MediaDownloader"
        private const val PREFS = "media_downloader"
        private const val KEY_UPDATED_AT = "ytdlp_updated_at"
        private const val UPDATE_INTERVAL_MS = 24L * 60 * 60 * 1000
        private const val UPDATE_TIMEOUT_S = 60L
        private val AUDIO_EXTENSIONS = setOf("opus", "ogg", "m4a", "mp3", "flac", "wav", "aac")
        private val SIDECAR_EXTENSIONS =
            setOf("jpg", "jpeg", "png", "webp", "json", "srt", "vtt", "ass", "description")
    }
}
