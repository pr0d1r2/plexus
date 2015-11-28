function renice_spotify_helper() {
  sudo renice -18 `ps -ax | grep "Spotify Helper" | grep -v grep | cut -b 1-5` || return $?
}
