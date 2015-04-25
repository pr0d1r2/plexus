function check_youtube_dl_gui_brew_formula() {
  brew uninstall youtube-dl-gui
  brew untap pr0d1r2/contrib
  brew tap pr0d1r2/contrib
  brew install youtube-dl-gui
}
