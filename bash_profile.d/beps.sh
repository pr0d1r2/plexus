function beps() {
  if [ -f knapsack_rspec_report.json ]; then
    bundle exec rake knapsack:rspec
  else
    bundle exec parallel_rspec spec
  fi
}
