function sha512() {
  for sha512_FILE in $@
  do
    shasum -a 512 $sha512_FILE
  done
  unset sha512_FILE
}
