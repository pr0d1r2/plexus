function bepc() {
  if [ -f knapsack_cucumber_report.json ]; then
    bundle exec rake knapsack:cucumber
  else
    bundle exec rake parallel:features
  fi
}
