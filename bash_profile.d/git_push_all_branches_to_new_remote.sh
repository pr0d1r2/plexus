function git_push_all_branches_to_new_remote() {
  case $1 in
    "")
      echo "Please give new remote name as first parameter!"
      return 1
      ;;
  esac
  local git_push_all_branches_to_new_remote_BRANCH
  for git_push_all_branches_to_new_remote_BRANCH in `git branch | grep -v master`
  do
    git checkout $git_push_all_branches_to_new_remote_BRANCH && \
    git push -u $1 $git_push_all_branches_to_new_remote_BRANCH
    echo
  done
}
