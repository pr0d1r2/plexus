function tor_service() {
  local tor_service_CMD
  for tor_service_CMD in tor torsocks
  do
    which $tor_service_CMD 1>/dev/null 2>/dev/null
    if [ $? -gt 0 ]; then
      brew install $tor_service_CMD || return $?
    fi
  done
  brew services start tor || return $?
}
