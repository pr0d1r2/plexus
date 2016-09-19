function git_files_changed_vs_origin_master_existing() {
  local git_files_changed_vs_origin_master_existing_FILE
  for git_files_changed_vs_origin_master_existing_FILE in `git_files_changed_vs_origin_master`
  do
    if [ -f $git_files_changed_vs_origin_master_existing_FILE ]; then
      echo $git_files_changed_vs_origin_master_existing_FILE
    fi
  done
}
