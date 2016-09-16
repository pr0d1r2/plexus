function git_directories_changed_vs_origin_master_non_unique() {
  local git_directories_changed_vs_origin_master_non_unique_FILE
  local git_directories_changed_vs_origin_master_non_unique_DIR
  for git_directories_changed_vs_origin_master_non_unique_FILE in `git_files_changed_vs_origin_master 2>/dev/null`
  do
    git_directories_changed_vs_origin_master_non_unique_DIR=`dirname $git_directories_changed_vs_origin_master_non_unique_FILE`
    if [ -d $git_directories_changed_vs_origin_master_non_unique_DIR ]; then
      echo $git_directories_changed_vs_origin_master_non_unique_DIR
    fi
  done
}
