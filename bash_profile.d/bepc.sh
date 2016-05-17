function bepc() {
  case $1 in
    '')
      if [ -f knapsack_cucumber_report.json ]; then
        DISABLE_SPRING=1 bundle exec rake knapsack:cucumber
      else
        DISABLE_SPRING=1 bundle exec parallel_cucumber features
      fi
      ;;
    *)
      DISABLE_SPRING=1 bundle exec parallel_cucumber $@
      ;;
  esac
}
