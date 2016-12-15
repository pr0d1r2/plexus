function http_serve() {
  local http_serve_PORT="8000"
  case $1 in
    [1-9][0-9][0-9][0-9] | [1-6][0-9][0-9][0-9][0-9])
      http_serve_PORT=$1
      ;;
  esac
  ifconfig | grep "inet " | grep -v 127.0.0.1
  ruby -run -ehttpd . -p$http_serve_PORT || return $?
}
