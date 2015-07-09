function network_devices_with_ip_address() {
  local network_devices_with_ip_address_DEVICE
  for network_devices_with_ip_address_DEVICE in `network_devices`
  do
    if [ `ifconfig $network_devices_with_ip_address_DEVICE | grep "inet " | wc -l` -gt 0 ]; then
      echo $network_devices_with_ip_address_DEVICE
    fi
  done
}
