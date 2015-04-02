function rsync_parallel_from() {
  rsync_parallel_from_THREADS="8"
  rsync_parallel_from_SSH_PORT="22"

  for PARAM in $@
  do
    case $PARAM in
      -j=[1-9] | -j=[1-9][0-9])
        rsync_parallel_from_THREADS=`echo $PARAM | cut -f 2 -d =`
        ;;
      -p=[1-9] | -p=[1-9][0-9] | -p=[1-9][0-9][0-9] | -p=[1-9][0-9][0-9][0-9] | -p=[1-6][0-9][0-9][0-9])
        rsync_parallel_from_SSH_PORT=`echo $PARAM | cut -f 2 -d =`
        ;;
      *:*)
        rsync_parallel_from_SSH_CREDENTIALS=`echo $PARAM | cut -f 1 -d :`
        rsync_parallel_from_REMOTE_DIRECTORY=`echo $PARAM | cut -f 2 -d :`
        ;;
      *)
        if [ -d $PARAM ]; then
          rsync_parallel_from_LOCAL_DIRECTORY="$PARAM"
        fi
        ;;
    esac
  done

  case $rsync_parallel_from_SSH_CREDENTIALS in
    "")
      echo "rsync_parallel_from user@host:/remote_dir/ /local_dir/"
      return 1
      ;;
  esac

  case $rsync_parallel_from_REMOTE_DIRECTORY in
    "")
      echo "rsync_parallel_from user@host:/remote_dir/ /local_dir/"
      return 2
      ;;
  esac

  case $rsync_parallel_from_LOCAL_DIRECTORY in
    "")
      echo "rsync_parallel_from user@host:/remote_dir/ /local_dir/"
      return 3
      ;;
  esac

  # create remote directories locally
  ssh -e "ssh -p $rsync_parallel_from_SSH_PORT" -c arcfour \
    $rsync_parallel_from_SSH_CREDENTIALS \
    find $rsync_parallel_from_REMOTE_DIRECTORY -type d -print0 | \
  sed -e "s|$rsync_parallel_from_REMOTE_DIRECTORY||g" | \
  xargs -0 -n1 -P$rsync_parallel_from_THREADS -I% \
    mkdir -p "$rsync_parallel_from_LOCAL_DIRECTORY/%"

  echo
  echo "Now we will start $rsync_parallel_from_THREADS in parallel on xargs ..."
  echo "To see progress run this on another terminal:"
  echo "watch du -sh '$rsync_parallel_from_LOCAL_DIRECTORY'"
  echo

  # rsync remote files one-by-one in parallel
  ssh -p $rsync_parallel_from_SSH_PORT -c arcfour \
    $rsync_parallel_from_SSH_CREDENTIALS \
    find $rsync_parallel_from_REMOTE_DIRECTORY -type f -print0 | \
  sed -e "s|$rsync_parallel_from_REMOTE_DIRECTORY||g" | \
  xargs -0 -P$rsync_parallel_from_THREADS -n1 -I% \
    rsync -e "ssh -c arcfour -p $rsync_parallel_from_SSH_PORT" -zs \
      $rsync_parallel_from_SSH_CREDENTIALS:"$rsync_parallel_from_REMOTE_DIRECTORY%" \
      "$rsync_parallel_from_LOCAL_DIRECTORY/%"

  # perform final traditional sync to ensure files are synced correctly
  rsync -e 'ssh -c arcfour' -zav --progress \
    $rsync_parallel_from_SSH_CREDENTIALS:$rsync_parallel_from_REMOTE_DIRECTORY \
    $rsync_parallel_from_LOCAL_DIRECTORY
}
