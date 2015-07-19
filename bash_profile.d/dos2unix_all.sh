function dos2unix_all() {
  find . -type f | grep -v "^./.git" | xargs dos2unix
}
