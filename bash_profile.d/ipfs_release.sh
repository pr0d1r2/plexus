function ipfs_release() {
  if [ ! -d .git ]; then
    echo "There is no .git directory in CWD. Exiting ..."
    return 1
  fi
  ipfs_release_NAME=`basename \`pwd\``
  ipfs_release_SRC=`pwd`
  ipfs_release_DST="/tmp/.ipfs_release-$ipfs_release_NAME"
  rsync -av $ipfs_release_SRC/ $ipfs_release_DST/ --exclude .git || return $?
  cd $ipfs_release_DST/ || return $?
  ipfs_release_HASH=`ipfs add -r . | tail -n 1 | cut -f 2 -d " "` || return $?
  echo $ipfs_release_HASH >> $ipfs_release_SRC/.IPFSreleases
  cd $ipfs_release_SRC || return $?
  rm -rf $ipfs_release_DST || return $?
  open "http://127.0.0.1:8080/ipfs/$ipfs_release_HASH"
}
