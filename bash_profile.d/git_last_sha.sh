function git_last_sha() {
  if [ ! -d .git ]; then
    return 8472
  fi
  git_log | head -n1 | cut -f 1 -d " "
}
