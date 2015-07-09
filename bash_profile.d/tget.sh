function tget() {
  local tget_MAGNET
  local tget_NAME
  local tget_NETWORK_DEVICE
  local tget_LPD_INTERFACE_PARAMS

  for tget_MAGNET in $@
  do
    tget_NAME=`echo $tget_MAGNET | md5`
    if [ ! -d ~/Downloads/$tget_NAME ]; then
      mkdir -p ~/Downloads/$tget_NAME || return $?
    fi
    cd ~/Downloads/$tget_NAME || return $?
    echo $tget_MAGNET > $tget_NAME.magnet
    tget_LPD_INTERFACE_PARAMS=()
    for tget_NETWORK_DEVICE in `network_devices_with_ip_address`
    do
      tget_LPD_INTERFACE_PARAMS+="--bt-lpd-interface=`network_device_ip_address $tget_NETWORK_DEVICE`"
    done
    aria2c --bt-save-metadata=true --bt-enable-lpd=true ${tget_LPD_INTERFACE_PARAMS[*]} --seed-ratio=1.5 --seed-time=300 `cat $tget_NAME.magnet`
  done
}
