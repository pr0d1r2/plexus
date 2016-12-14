function qp() {
  echo 'OVERCOMMIT_DISABLE=1 git pull'
  OVERCOMMIT_DISABLE=1 git pull || return $?
}
