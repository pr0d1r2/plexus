function qc() {
  echo 'OVERCOMMIT_DISABLE=1 git checkout $@'
  OVERCOMMIT_DISABLE=1 git checkout $@ || return $?
}
