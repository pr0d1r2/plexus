function git_files_changed() {
  git status --porcelain | grep -v "^D" | cut -c4-
}
