function branchize() {
  echo "$@" | tr ' ' '-' | tr '[A-Z]' '[a-z]' | tr '[' '-' | tr ']' '-' | tr '#' '-' | sed -e 's/--/-/g' | sed -e 's/--/-/g'
}
