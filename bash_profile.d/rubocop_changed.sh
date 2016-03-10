function rubocop_changed() {
  git status --porcelain | grep -v "^D" | cut -c4- | xargs rubocop
}
