function rubocop_changed_in_branch() {
  rubocop $@ `git_files_changed_vs_origin_master` || return $?
}
