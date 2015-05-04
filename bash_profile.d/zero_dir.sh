function zero_dir() {
  if [ -d $1 ]; then
    rm -rf $1 && mkdir $1
  fi
}
