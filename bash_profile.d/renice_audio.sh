function renice_audio() {
  renice_named coreaudiod
  renice_named AudioToolbox.framework
  renice_named CoreAudio.framework
}
