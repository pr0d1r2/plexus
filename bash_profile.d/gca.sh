function gca() {
  git commit -a $@ || return $?
}
