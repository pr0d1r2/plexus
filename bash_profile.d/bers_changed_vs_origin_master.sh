function bers_changed_vs_origin_master() {
  local bers_changed_vs_origin_master_FILES=`git_files_changed_vs_origin_master | grep spec | grep "_spec.rb$"`
  if [ `echo $bers_changed_vs_origin_master_FILES | wc -l` -gt 0 ]; then
    echorun bers `echo $bers_changed_vs_origin_master_FILES | tr "\n" " "`
  else
    echo
    echo "$0: nothing to run"
  fi
}
