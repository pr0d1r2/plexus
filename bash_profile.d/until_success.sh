function until_success() {
  case $SLEEP in
    "")
      until_success_SLEEP=60
      ;;
    [0-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
      until_success_SLEEP=$SLEEP
      ;;
  esac
  until_success_ERR=1
  while [ $until_success_ERR -gt 0 ]; do
    $@
    until_success_ERR=$?
    if [ $until_success_ERR -gt 0 ]; then
      sleep $until_success_SLEEP
    fi
  done
  unset until_success_ERR
  unset until_success_SLEEP
}
