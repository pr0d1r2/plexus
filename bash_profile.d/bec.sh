function bec() {
  bundle exec cucumber $@ || return $?
}
