function network_device_ip_address() {
  ifconfig $1 | grep "inet " | cut -f 2 -d " "
}
