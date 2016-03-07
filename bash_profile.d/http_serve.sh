function http_serve() {
  ifconfig | grep "inet " | grep -v 127.0.0.1
  python -m SimpleHTTPServer || return $?
}
