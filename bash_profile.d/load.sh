function load() {
  uptime | awk -F "load averages: " {' print $2 '}
}
