function any2ico() {
  case $1 in
    "")
      echo "Please give source file as first parameter"
      return 1
      ;;
  esac
  case $2 in
    "")
      echo "Please give destination file as second parameter"
      return 2
      ;;
  esac
  which convert 1>/dev/null 2>/dev/null
  if [ $? -gt 0 ]; then
    port install imagemagick
  fi
  which png2ico 1>/dev/null 2>/dev/null
  if [ $? -gt 0 ]; then
    port install png2ico
  fi
  convert $1 -colors 256 /tmp/any2ico.png && png2ico $2 /tmp/any2ico.png
  rm -f /tmp/any2ico.png
}
