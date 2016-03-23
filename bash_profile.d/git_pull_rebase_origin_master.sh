function git_pull_rebase_origin_master() {
  git pull --rebase origin master || return $?
}
