function osx_ramdisk() {
  mount | grep -q " on /Volumes/RAMdisk "
  if [ $? -eq 0 ]; then
    echo "$0: already initialized:"
    mount | grep " on /Volumes/RAMdisk "
    return 8472
  fi

  # 12G by default
  osx_ramdisk_SIZE="25165824"

  local osx_ramdisk_PARAM
  for osx_ramdisk_PARAM in $@
  do
    case $osx_ramdisk_PARAM in
      [1-9] | [1-9][0-9])
        osx_ramdisk_SIZE=$(expr $osx_ramdisk_PARAM \* 1024 \* 2048)
        ;;
    esac
  done

  diskutil erasevolume HFS+ 'RAMdisk' `hdiutil attach -nomount ram://$osx_ramdisk_SIZE`
}
