function renice_named() {
  local renice_named_NAME
  local renice_named_LEVEL="-18"
  case $NICE in
    -[1-9] | 1[0-8] | [0-9] | 1[0-9] | 20)
      renice_named_LEVEL=$NICE
      ;;
  esac
  for renice_named_NAME in $@
  do
    ps -ax | grep "$renice_named_NAME" | grep -v grep | grep -q "$renice_named_NAME"
    if [ $? -eq 0 ]; then
      echo "# renice $renice_named_LEVEL <$renice_named_NAME>"
      echorun sudo renice $renice_named_LEVEL `ps -ax | grep "$renice_named_NAME" | grep -v grep | cut -b1-5`
    fi
  done
}
