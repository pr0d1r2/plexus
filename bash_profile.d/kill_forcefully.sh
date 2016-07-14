function kill_forcefully() {
  local kill_forcefully_PID
  for kill_forcefully_PID in $@
  do
    echorun kill $kill_forcefully_PID &
  done
  sleep 1
  wait
  for kill_forcefully_PID in $@
  do
    echorun kill -9 $kill_forcefully_PID &
  done
  wait
}
