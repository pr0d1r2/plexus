function git_directories_changed_vs_origin_master_non_unique() {
  local git_directories_changed_vs_origin_master_non_unique_FILE
  for git_directories_changed_vs_origin_master_non_unique_FILE in `git_files_changed_vs_origin_master 2>/dev/null`
  do
    dirname $git_directories_changed_vs_origin_master_non_unique_FILE
  done
}
