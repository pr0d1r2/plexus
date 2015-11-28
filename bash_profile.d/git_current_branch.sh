function git_current_branch() {
  git status | grep origin | cut -f 2 -d / | cut -f 1 -d "'"
}
