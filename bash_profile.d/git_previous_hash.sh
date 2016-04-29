function git_previous_hash() {
  git log --pretty=format:'%h' | head -n 2 | tail -n 1
}
