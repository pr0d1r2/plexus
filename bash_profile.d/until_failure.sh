function until_failure() {
  local until_failure_ERR
  local until_failure_SLEEP
  local until_failure_RUN
  case $SLEEP in
    "")
      until_failure_SLEEP=60
      ;;
    [0-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_failure_SLEEP=$SLEEP
      ;;
  esac
  until_failure_ERR=0
  until_failure_RUN=1
  while [ $until_failure_ERR -eq 0 ]; do
    echo "until_failure: run #$until_failure_RUN"
    $@
    until_failure_ERR=$?
    if [ $until_failure_ERR -eq 0 ]; then
      sleep $until_failure_SLEEP
      until_failure_RUN+=1
    else
      return $until_failure_ERR
    fi
  done
}
