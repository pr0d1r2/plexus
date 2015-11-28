function deploy_current_branch_to_staging() {
  local deploy_current_branch_to_staging_BRANCH
  deploy_current_branch_to_staging_BRANCH=`git_current_branch`
  echo "3c3
< set :branch, 'master'
---
> set :branch, '$deploy_current_branch_to_staging_BRANCH'" | patch -p0 config/deploy/staging.rb
  bundle exec cap staging deploy || return $?
  git checkout config/deploy/staging.rb || return $?
}
