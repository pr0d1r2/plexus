function bepc() {
  if [ -f knapsack_cucumber_report.json ]; then
    DISABLE_SPRING=1 bundle exec rake knapsack:cucumber
  else
    DISABLE_SPRING=1 bundle exec rake parallel:features
  fi
}
