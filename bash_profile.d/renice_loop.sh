function renice_loop() {
  local renice_loop_LEVEL="-18"
  local renice_loop_INTERVAL=5
  local renice_loop_PROCESS_NAME
  case $NICE in
    -[1-9] | 1[0-8] | [0-9] | 1[0-9] | 20)
      renice_loop_LEVEL=$NICE
      ;;
  esac
  case $INTERVAL in
    [1-9] | [1-9][0-9] | [1-9][0-9][0-9])
      renice_loop_INTERVAL=$INTERVAL
      ;;
  esac
  while do
    for renice_loop_PROCESS_NAME in $@
    do
      NICE="$renice_loop_LEVEL" renice_named $renice_loop_PROCESS_NAME
    done
    sleep $renice_loop_INTERVAL
    echo
  done
}
