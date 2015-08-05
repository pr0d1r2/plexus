function until_success() {
  local until_success_ERR
  local until_success_SLEEP
  local until_success_RUN
  case $SLEEP in
    "")
      until_success_SLEEP=60
      ;;
    [0-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_success_SLEEP=$SLEEP
      ;;
  esac
  until_success_ERR=1
  until_success_RUN=1
  while [ $until_success_ERR -gt 0 ]; do
    echo "until_success: run #$until_success_RUN (`date`)"
    $@
    until_success_ERR=$?
    if [ $until_success_ERR -gt 0 ]; then
      sleep $until_success_SLEEP
      until_success_RUN=$(( $until_success_RUN + 1 ))
    fi
  done
  echo "until_success: SUCCESS: run #$until_failure_RUN (`date`)"
}
