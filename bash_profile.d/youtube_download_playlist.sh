function youtube_download_playlist() {
  tor_service
  torsocks youtube-dl --proxy socks5://127.0.0.1:9050 -o '%(playlist)s - %(playlist_id)s/%(playlist_index)s - %(id)s - %(title)s.%(ext)s' $@
}
