function bers() {
  if [ -x bin/rspec ]; then
    be bin/rspec $@ || return $?
  else
    be rspec $@ || return $?
  fi
}
