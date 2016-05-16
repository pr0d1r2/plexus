function osx_chrome_two_finger_swipe_disable() {
  defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
}
