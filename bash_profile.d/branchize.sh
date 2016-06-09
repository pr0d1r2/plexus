function branchize() {
  echo "$@" | tr ' ' '-' | tr '[A-Z]' '[a-z]'
}
