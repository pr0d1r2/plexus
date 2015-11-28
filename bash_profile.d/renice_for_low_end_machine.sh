function renice_for_low_end_machine() {
  renice_audio && \
  renice_bluetooth_music && \
  renice_display_link
  return $?
}
