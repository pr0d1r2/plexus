function beps() {
  case $1 in
    '')
      if [ -f knapsack_rspec_report.json ]; then
        DISABLE_SPRING=1 bundle exec rake "knapsack:rspec[--fail-fast]"
      else
        DISABLE_SPRING=1 bundle exec parallel_rspec -- --fail-fast -- spec
      fi
      ;;
    *)
      DISABLE_SPRING=1 bundle exec parallel_rspec -- --fail-fast -- $@
      ;;
  esac
}
