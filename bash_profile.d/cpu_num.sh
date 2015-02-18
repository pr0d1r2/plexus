function cpu_num() {
  case $UNAME in
    Linux)
      cat /proc/cpuinfo | grep "^processor" | wc -l
      ;;
    *)
      /usr/sbin/sysctl -n hw.ncpu
      ;;
  esac
}
