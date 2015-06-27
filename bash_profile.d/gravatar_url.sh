function gravatar_url() {
  echo "https://secure.gravatar.com/avatar/`echo -n "$1" | tr '[:upper:]' '[:lower:]' | md5`?s=512"
}
