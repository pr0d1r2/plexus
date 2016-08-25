function knapsack_update_spec() {
  KNAPSACK_GENERATE_REPORT=true bundle exec rspec spec || return $?
}
