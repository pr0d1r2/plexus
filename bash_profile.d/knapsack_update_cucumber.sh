function knapsack_update_cucumber() {
  KNAPSACK_GENERATE_REPORT=true bundle exec cucumber features || return $?
}
