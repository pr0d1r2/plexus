function git_checkout_matching() {
  local git_checkout_matching_BRANCH=`git branch | grep "$@"`
  if [ `echo $git_checkout_matching_BRANCH | wc -l` -gt 1 ]; then
    echo
    echo "No unique branch for '$@':"
    echo $git_checkout_matching_BRANCH
    echo
    return 1
  fi
  case $git_checkout_matching_BRANCH in
    "")
      echo
      echo "No branch for '$@'"
      echo
      return 2
      ;;
  esac
  git_checkout_matching_BRANCH=`echo $git_checkout_matching_BRANCH | cut -b3-`
  git checkout $git_checkout_matching_BRANCH || return $?
}
