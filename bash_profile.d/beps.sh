function beps() {
  case $1 in
    '')
      if [ -f knapsack_rspec_report.json ]; then
        DISABLE_SPRING=1 bundle exec rake knapsack:rspec
      else
        DISABLE_SPRING=1 bundle exec parallel_rspec spec
      fi
      ;;
    *)
      DISABLE_SPRING=1 bundle exec parallel_rspec $@
      ;;
  esac
}
