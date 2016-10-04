function system_git() {
  PATH="/usr/bin:/bin" /usr/bin/git $@ || return $?
}
