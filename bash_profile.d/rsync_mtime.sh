function rsync_mtime() {
  local rsync_mtime_FILE
  local rsync_mtime_LIST="/tmp/.rsync_mtime-$$"
  local rsync_mtime_REMOTE="$1"
  local rsync_mtime_PATH_REMOTE="$2"
  local rsync_mtime_PATH_LOCAL="$3"
  local rsync_mtime_MTIME="$4"
  local rsync_mtime_PORT="$5"

  if [ -z "$rsync_mtime_MTIME" ]; then
    rsync_mtime_MTIME="2"
  fi
  if [ -z "$rsync_mtime_PORT" ]; then
    rsync_mtime_PORT="22"
  fi

  touch $rsync_mtime_LIST
  chmod go-rwxs $rsync_mtime_LIST

  # directories (mandatory '/' at end to avoid double send)
  ssh -p $rsync_mtime_PORT \
      $rsync_mtime_REMOTE \
      "cd $rsync_mtime_PATH_REMOTE ; find -mtime -$rsync_mtime_MTIME -maxdepth 1 -type d -exec echo {} \;" | \
    grep -v "^.$" | \
    cut -b3- > $rsync_mtime_LIST

  while read rsync_mtime_FILE
  do
    rsync -s \
          --progress -av \
          -e "ssh -p $rsync_mtime_PORT" \
          "$rsync_mtime_REMOTE:$rsync_mtime_PATH_REMOTE/$rsync_mtime_FILE/" \
          "$rsync_mtime_PATH_LOCAL/$rsync_mtime_FILE/"
  done < $rsync_mtime_LIST

  # files (no '/' at end)
  ssh -p $rsync_mtime_PORT \
      $rsync_mtime_REMOTE \
      "cd $rsync_mtime_PATH_REMOTE ; find -mtime -$rsync_mtime_MTIME -maxdepth 1 -type f -exec echo {} \;" | \
    grep -v "^.$" | \
    cut -b3- > $rsync_mtime_LIST

  while read rsync_mtime_FILE
  do
    rsync -s \
          --progress -av \
          -e "ssh -p $rsync_mtime_PORT" \
          "$rsync_mtime_REMOTE:$rsync_mtime_PATH_REMOTE/$rsync_mtime_FILE" \
          "$rsync_mtime_PATH_LOCAL/$rsync_mtime_FILE"
  done < $rsync_mtime_LIST

  rm -f $rsync_mtime_LIST
}
