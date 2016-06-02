function git_directories_changed_vs_origin_master() {
  git_directories_changed_vs_origin_master_non_unique | sort | uniq
}
