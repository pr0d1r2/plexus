function renice_audio() {
  sudo renice -18 `ps -ax | grep coreaudiod | grep -v grep | cut -b 1-5`
  sudo renice -18 `ps -ax | grep AudioToolbox.framework | grep -v grep | cut -b 1-5`
  sudo renice -18 `ps -ax | grep CoreAudio.framework | grep -v grep | cut -b 1-5`
}
