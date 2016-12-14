function git_checkout_matching_remote() {
  local git_checkout_matching_remote_BRANCH=`git branch -r | grep "$@"`
  if [ `echo $git_checkout_matching_remote_BRANCH | wc -l` -gt 1 ]; then
    echo
    echo "No unique remote branch for '$@':"
    echo $git_checkout_matching_remote_BRANCH
    echo
    return 1
  fi
  case $git_checkout_matching_remote_BRANCH in
    "")
      echo
      echo "No remote branch for '$@'"
      echo
      return 2
      ;;
    *)
      git_checkout_matching_remote_BRANCH=`echo $git_checkout_matching_remote_BRANCH | cut -b3- | cut -f 2 -d /`
      git checkout $git_checkout_matching_remote_BRANCH || return $?
      ;;
  esac
}
