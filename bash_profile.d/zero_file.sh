function zero_file() {
  if [ -f $1 ]; then
    echo -n > $1
  fi
}
