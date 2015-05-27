function sha256() {
  for sha256_FILE in $@
  do
    shasum -a 256 $sha256_FILE
  done
  unset sha256_FILE
}
