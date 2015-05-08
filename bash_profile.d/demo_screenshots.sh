function demo_screenshots() {
  case $1 in
    "")
      SCREENSHOT=true bers spec/features
      ;;
    *)
      SCREENSHOT=true bers $@
      ;;
  esac
  open demo
}
