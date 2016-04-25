function git_files_changed_vs_origin_master() {
  git_current_branch | grep -q "^master$"
  if [ $? -eq 0 ]; then
    echo "You are currently in 'master' branch!"
    return 8472
  fi
  git fetch || return $?
  git diff --name-status origin/master | grep -v "^D" | cut -f 2
  return $?
}
