function bu() {
  is_new_bundler
  if [ $? -eq 0 ]; then
    bundle update -j`bundler_threads` $@ || return $?
  else
    bundle update $@ || return $?
  fi
}
