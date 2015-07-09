function network_devices() {
  ifconfig | grep "^[a-z]"| cut -f 1 -d :
}
