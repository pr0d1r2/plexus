function git_current_hash() {
  git log --pretty=format:'%h' | head -n 1
}
