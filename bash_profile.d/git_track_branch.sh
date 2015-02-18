function git_track_branch() {
  for git_track_branch_BRANCH in $1
  do
    git fetch origin
    git checkout --track -b $git_track_branch_BRANCH origin/$git_track_branch_BRANCH
    git pull
  done
}
