package app.cadence.cadence

import com.ryanheise.audioservice.AudioServiceActivity

// AudioServiceActivity keeps the Flutter engine shared with the background
// playback service so the UI reconnects to the running audio session.
class MainActivity : AudioServiceActivity()
