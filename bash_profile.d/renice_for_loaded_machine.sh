function renice_for_loaded_machine() {
  echorun renice_audio && \
  echorun renice_bluetooth_music && \
  echorun renice_usb && \
  echorun renice_display_link
  return $?
}
