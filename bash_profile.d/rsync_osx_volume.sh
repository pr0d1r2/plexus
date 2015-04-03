function rsync_osx_volume() {
  rsync $@ \
    --exclude .Spotlight-V100 \
    --exclude .DocumentRevisions-V100 \
    --exclude .Trashes \
    --exclude private/var/db/dslocal/nodes/Default \
    --exclude .file \
    --exclude private/var/run \
    --exclude usr/sbin \
    --exclude .fseventsd \
    --exclude .PKInstallSandboxManager
}
