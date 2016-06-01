function maxfiles_permanent() {
  maxfiles_permanent_content $@ > /tmp/limit.maxfiles.plist
  echorun sudo mv /tmp/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist || return $?
}
