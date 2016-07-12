function audio_restart() {
  sudo pkill coreaudiod || return $?
}
