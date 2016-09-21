function osx_ramdisk_custom() {
  case $1 in
    '')
      echo 'osx_ramdisk_custom SIZE_IN_MB MOUNTPOINT'
      ;;
  esac
  osx_ramdisk_custom_RAMFS_SIZE_SECTORS=$((${1}*1024*1024/512))
  osx_ramdisk_custom_RAMDISK_DEV=`echo $(hdid -nomount ram://${osx_ramdisk_custom_RAMFS_SIZE_SECTORS})`

  echo "osx_ramdisk_custom: avaiting ramdisk device present ..."
  local osx_ramdisk_custom_DEV_PRESENCE=1
  while [ $osx_ramdisk_custom_DEV_PRESENCE -gt 0 ]
  do
    sleep 1
    ls -la ${osx_ramdisk_custom_RAMDISK_DEV}
    osx_ramdisk_custom_DEV_PRESENCE=$?
  done

  newfs_hfs -v 'ram disk' ${osx_ramdisk_custom_RAMDISK_DEV} || return $?
  if [ ! -d ${2} ]; then
    mkdir -p ${2} || return $?
  fi
  mount -o noatime -t hfs ${osx_ramdisk_custom_RAMDISK_DEV} ${2} || return $?

  echo "remove with:"
  echo "umount ${2}"
  echo "diskutil eject ${osx_ramdisk_custom_RAMDISK_DEV}"
}
