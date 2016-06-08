function renice_bluetooth_music() {
  echorun renice_bluetooth_audio && \
  echorun renice_spotify_helper
  return $?
}
