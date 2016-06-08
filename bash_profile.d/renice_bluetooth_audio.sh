function renice_bluetooth_audio() {
  sudo renice -18 `ps -ax | grep bluetoothaudiod | grep -v grep | cut -b 1-5`
}
