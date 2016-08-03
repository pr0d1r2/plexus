function git_fixup_last() {
  local git_fixup_last_SHA
  for git_fixup_last_SHA in `git_last_sha`
  do
    case $1 in
      '')
        git commit -a --fixup $git_fixup_last_SHA || return $?
        ;;
      *)
        git commit $@ --fixup $git_fixup_last_SHA || return $?
        ;;
    esac
  done
}
