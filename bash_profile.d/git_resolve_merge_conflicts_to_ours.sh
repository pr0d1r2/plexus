function git_resolve_merge_conflicts_to_ours() {
  local git_resolve_merge_conflicts_to_ours_FILE
  for git_resolve_merge_conflicts_to_ours_FILE in `git st | grep "^UU " | cut -b4-`
  do
    git checkout --ours $git_resolve_merge_conflicts_to_ours_FILE
  done
  for git_resolve_merge_conflicts_to_ours_FILE in `git st | grep "^AA " | cut -b4-`
  do
    git checkout --ours $git_resolve_merge_conflicts_to_ours_FILE
  done
}
