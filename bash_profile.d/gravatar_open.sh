function gravatar_open() {
  for gravatar_open_EMAIL in $@
  do
    open -a "Google Chrome" `gravatar_url "$gravatar_open_EMAIL"`
  done
}
