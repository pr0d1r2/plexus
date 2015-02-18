function bi() {
  is_new_bundler
  if [ $? -eq 0 ]; then
    bundle install -j`cpu_num` || return $?
  else
    bundle install || return $?
  fi
}
