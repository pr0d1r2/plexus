function until_failure() {
  local until_failure_ERR
  local until_failure_SLEEP
  local until_failure_RUN
  local until_failure_ATTEMPTS
  local until_failure_ATTEMPT
  case $SLEEP in
    "")
      until_failure_SLEEP=60
      ;;
    [0-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_failure_SLEEP=$SLEEP
      ;;
  esac
  case $ATTEMPTS in
    "")
      until_failure_ATTEMPTS=10
      ;;
    [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_failure_ATTEMPTS=$ATTEMPTS
      ;;
  esac
  until_failure_ERR=0
  until_failure_RUN=1
  until_failure_ATTEMPT=1
  while [ $until_failure_ERR -eq 0 ]; do
    echo "until_failure: run #$until_failure_RUN (`date`)"
    $@
    until_failure_ERR=$?
    if [ $until_failure_ERR -eq 0 ]; then
      sleep $until_failure_SLEEP
      until_failure_RUN=$(( $until_failure_RUN + 1 ))
    else
      echo "until_failure: FAILURE: run #$until_failure_RUN (`date`)"
      return $until_failure_ERR
    fi
    if [ $until_failure_ATTEMPTS -eq $until_failure_ATTEMPT ]; then
      return 0
    fi
    until_failure_ATTEMPT=$(( $until_failure_ATTEMPT + 1 ))
  done
}
