function bu() {
  is_new_bundler
  if [ $? -eq 0 ]; then
    bundle update -j`cpu_num` $@ || return $?
  else
    bundle update $@ || return $?
  fi
}
