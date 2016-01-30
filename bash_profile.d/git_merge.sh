function git_merge() {
  local git_merge_BRANCH_LIST=`git branch | grep "$1"`
  local git_merge_BRANCH_HITS=`echo $git_merge_BRANCH_LIST | wc -l`
  local git_merge_CURRENT_BRANCH=`git status | grep "On branch" | cut -b11-`
  if [ $git_merge_BRANCH_HITS -eq 1 ]; then
    if [ `echo $git_merge_BRANCH_HITS | grep -v "^ \* " | wc -l` -eq 0 ]; then
      echo "Cannot merge from current branch '$git_merge_CURRENT_BRANCH'"
      return 1
    fi
    local git_merge_BRANCH_TO_MERGE=`echo $git_merge_BRANCH_LIST | cut -b3-`
    git checkout $git_merge_BRANCH_TO_MERGE || return $?
    git pull || return $?
    git checkout $git_merge_CURRENT_BRANCH || return $?
    git merge $git_merge_BRANCH_TO_MERGE || return $?
  elif [ $git_merge_BRANCH_HITS -eq 0 ]; then
    echo "No branches found when searching for: $1"
    echo "Available ones:"
    git branch
    return 2
  elif [ $git_merge_BRANCH_HITS -gt 1 ]; then
    echo "Multiple branches found when searching for: $1"
    echo $git_merge_BRANCH_LIST
    return 3
  fi
}
