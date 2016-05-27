function renice_named() {
  local renice_named_NAME
  for renice_named_NAME in $@
  do
    echo "# renice $renice_loop_LEVEL <$renice_named_NAME>"
    echorun sudo renice $renice_loop_LEVEL `ps -ax | grep "$renice_named_NAME" | grep -v grep | cut -b1-5`
  done
}
