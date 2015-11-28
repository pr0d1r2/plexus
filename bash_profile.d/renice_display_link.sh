function renice_display_link() {
  sudo renice -18 `ps -ax | grep DisplayLink | grep -v grep  | cut -b 1-5` || return $?
}
