function git_new_branch() {
  git checkout -b `branchize $@` || return $?
}
