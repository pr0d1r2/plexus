function tget_leech() {
  local tget_leech_MAGNET
  local tget_leech_NAME

  for tget_leech_MAGNET in $@
  do
    tget_leech_NAME=`echo $tget_leech_MAGNET | md5`
    if [ ! -d ~/Downloads/$tget_leech_NAME ]; then
      mkdir -p ~/Downloads/$tget_leech_NAME || return $?
    fi
    cd ~/Downloads/$tget_leech_NAME || return $?

    echo $tget_leech_MAGNET > $tget_leech_NAME.magnet
    aria2c -u 2k --seed-time=0 --bt-save-metadata=true `cat $tget_leech_NAME.magnet`
  done
}
