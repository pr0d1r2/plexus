function bepc() {
  if [ -f knapsack_cucumber_report.json ]; then
    bundle exec `rake_executable` knapsack:cucumber
  else
    bundle exec `rake_executable` parallel:features
  fi
}
