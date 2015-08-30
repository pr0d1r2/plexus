function mysql_reload() {
  launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
}
