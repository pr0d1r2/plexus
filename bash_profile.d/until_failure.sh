function until_failure() {
  case $SLEEP in
    "")
      until_failure_SLEEP=60
      ;;
    [0-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_failure_SLEEP=$SLEEP
      ;;
  esac
  until_failure_ERR=0
  while [ $until_failure_ERR -eq 0 ]; do
    $@
    until_failure_ERR=$?
    if [ $until_failure_ERR -eq 0 ]; then
      sleep $until_failure_SLEEP
    fi
  done
  unset until_failure_ERR
  unset until_failure_SLEEP
}
