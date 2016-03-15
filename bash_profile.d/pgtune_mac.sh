function pgtune_mac() {
  local pgtune_mac_CONFIG=$1
  case $pgtune_mac_CONFIG in
    '')
      pgtune_mac_CONFIG="/usr/local/var/postgres/postgresql.conf"
      ;;
  esac
  if [ -f $pgtune_mac_CONFIG ]; then
    cat $pgtune_mac_CONFIG | grep -q "pgtune wizard"
    if [ $? -gt 0 ]; then
      echorun pgtune -T Web -i $pgtune_mac_CONFIG -o $pgtune_mac_CONFIG || return $?
      pgreload_mac || return $?
    fi
  else
    echo
    echo "Config file does not exist: $pgtune_mac_CONFIG"
    echo
    return 8472
  fi
}
