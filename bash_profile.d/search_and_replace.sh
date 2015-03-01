function search_and_replace() {
  find . -type f -exec grep "$1" -l {} ";" -exec rpl $1 $2 {} ";"
}
