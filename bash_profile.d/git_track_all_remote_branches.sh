function git_track_all_remote_branches() {
  local git_track_all_remote_branches_BRANCH
  for git_track_all_remote_branches_BRANCH in `git branch -r  | grep -v "\->" | cut -f 2 -d /`
  do
    git checkout $git_track_all_remote_branches_BRANCH && \
    git branch --set-upstream-to=origin/$git_track_all_remote_branches_BRANCH $git_track_all_remote_branches_BRANCH && \
    git pull
    echo
  done
}
