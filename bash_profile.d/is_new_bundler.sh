function is_new_bundler() {
  case `bundle --version | grep "Bundler version 1.4"` in
    "")
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}
