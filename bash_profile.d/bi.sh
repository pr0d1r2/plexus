unalias bi
function bi() {
  is_new_bundler
  if [ $? -eq 0 ]; then
    bundle install -j`bundler_threads` || return $?
  else
    bundle install || return $?
  fi
}
