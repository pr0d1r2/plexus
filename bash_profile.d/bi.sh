unalias bi
function bi() {
  is_new_bundler
  if [ $? -eq 0 ]; then
    echorun bundle install -j`bundler_threads` || return $?
  else
    echorun bundle install || return $?
  fi
}
