function renice_for_loaded_machine() {
  renice_audio && \
  renice_bluetooth_music && \
  renice_usb && \
  renice_display_link
  return $?
}
