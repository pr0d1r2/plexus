function git_files_changed_in_commit() {
  local git_files_changed_in_commit_SHA1
  for git_files_changed_in_commit_SHA1 in $@
  do
    git diff-tree --no-commit-id --name-only -r $git_files_changed_in_commit_SHA1
  done
}
