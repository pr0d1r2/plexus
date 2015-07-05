function git_log() {
  git log --pretty=format:"%h - %an : %s" $@
  return $?
}
