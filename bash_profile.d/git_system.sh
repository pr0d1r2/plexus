function git_system() {
  PATH="/usr/bin:/bin" /usr/bin/git $@ || return $?
}
