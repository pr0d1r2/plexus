function git_rebase_undo() {
  git reset --hard ORIG_HEAD || return $?
}
