function git_list_files_in_commit() {
  local git_list_files_in_commit_SHA
  case $1 in
    '')
      git diff-tree --no-commit-id --name-only -r HEAD || return $?
      ;;
    *)
      for git_list_files_in_commit_SHA in $@
      do
        git diff-tree --no-commit-id --name-only -r $git_list_files_in_commit_SHA || return $?
      done
      ;;
  esac
}
