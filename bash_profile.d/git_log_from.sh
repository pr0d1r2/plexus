function git_log_from() {
  git_log $1..HEAD
  return $?
}
