function osx_create_install_pendrive_10_11_el_captain() {
  for osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT in $@
  do
    if [ -d $osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT ]; then
      mount | grep -q " on $osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT "
      if [ $? -eq 0 ]; then
        if [ -d /Applications/Install\ OS\ X\ El\ Capitan.app ]; then
          sudo /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/Resources/createinstallmedia \
            --volume $osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT \
            --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app \
            --nointeraction
        fi
      else
        echo "No mounted volume: $osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT"
        return 1002
      fi
    else
      echo "No directory: $osx_create_install_pendrive_10_11_el_captain_VOLUME_MOUNTPOINT"
      return 1001
    fi
  done
}
