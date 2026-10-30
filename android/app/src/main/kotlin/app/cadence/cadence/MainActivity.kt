package app.cadence.cadence

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine

// AudioServiceActivity keeps the Flutter engine shared with the background
// playback service so the UI reconnects to the running audio session.
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MediaDownloader(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }
}
