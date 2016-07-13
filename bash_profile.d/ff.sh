function ff() {
  local ff_FILE
  local ff_FILE_FOUND
  for ff_FILE in $@
  do
    for ff_FILE_FOUND in `find . -name "$ff_FILE" -type f`
    do
      echo $ff_FILE_FOUND
    done
  done
}
