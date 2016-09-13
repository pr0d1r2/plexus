function git_stash_pull_pop() {
  git stash && git pull && git stash pop
  return $?
}
