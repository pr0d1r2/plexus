function pgtune_mac() {
  local pgtune_mac_CONFIG=$1
  local pgtune_mac_RELOAD=0
  case $pgtune_mac_CONFIG in
    '')
      pgtune_mac_CONFIG="/usr/local/var/postgres/postgresql.conf"
      ;;
  esac
  if [ -f $pgtune_mac_CONFIG ]; then
    cat $pgtune_mac_CONFIG | grep -q "pgtune wizard"
    if [ $? -gt 0 ]; then
      echorun pgtune -T Web -i $pgtune_mac_CONFIG -o $pgtune_mac_CONFIG || return $?
      pgtune_mac_RELOAD=1
    fi
    cat $pgtune_mac_CONFIG | grep -q "full_page_writes = off"
    if [ $? -gt 0 ]; then
      echo "Disabling full_page_writes for better performance ..."
      cp $pgtune_mac_CONFIG ~/.postgresql.conf.tmp || return $?
      echo "full_page_writes = off" >> ~/.postgresql.conf.tmp || return $?
      mv ~/.postgresql.conf.tmp $pgtune_mac_CONFIG || return $?
      pgtune_mac_RELOAD=1
    fi
    cat $pgtune_mac_CONFIG | grep -q "fsync = off"
    if [ $? -gt 0 ]; then
      echo "Disabling fsync for better performance ..."
      cp $pgtune_mac_CONFIG ~/.postgresql.conf.tmp || return $?
      echo "fsync = off" >> ~/.postgresql.conf.tmp || return $?
      mv ~/.postgresql.conf.tmp $pgtune_mac_CONFIG || return $?
      pgtune_mac_RELOAD=1
    fi
    cat $pgtune_mac_CONFIG | grep -q "wal_level = minimal"
    if [ $? -gt 0 ]; then
      echo "Setting archive wal_level for better performance ..."
      cp $pgtune_mac_CONFIG ~/.postgresql.conf.tmp || return $?
      echo "wal_level = minimal" >> ~/.postgresql.conf.tmp || return $?
      mv ~/.postgresql.conf.tmp $pgtune_mac_CONFIG || return $?
      pgtune_mac_RELOAD=1
    fi
    if [ $pgtune_mac_RELOAD -eq 1 ]; then
      pgreload_mac || return $?
    fi
  else
    echo
    echo "Config file does not exist: $pgtune_mac_CONFIG"
    echo
    return 8472
  fi
}
