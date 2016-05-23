function bepc_changed_vs_origin_master() {
  rspec_ensure_no_focus || return $?
  local bepc_changed_vs_origin_master_FILE
  local bepc_changed_vs_origin_master_FILES_EXISTING=()
  for bepc_changed_vs_origin_master_FILE in `git_files_changed_vs_origin_master | grep features | grep ".feature$"`
  do
    if [ -f $bepc_changed_vs_origin_master_FILE ]; then
      bepc_changed_vs_origin_master_FILES_EXISTING+=$bepc_changed_vs_origin_master_FILE
    fi
  done
  if [ `echo $bepc_changed_vs_origin_master_FILES_EXISTING | wc -l` -gt 0 ]; then
    echorun bepc `echo $bepc_changed_vs_origin_master_FILES_EXISTING | tr "\n" " "`
  else
    echo
    echo "$0: nothing to run"
  fi
}
