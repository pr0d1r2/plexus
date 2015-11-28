function renice_bluetooth_music() {
  renice_bluetooth_audio && \
  renice_spotify_helper
  return $?
}
