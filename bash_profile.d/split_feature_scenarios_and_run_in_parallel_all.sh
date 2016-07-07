function split_feature_scenarios_and_run_in_parallel_all() {
  DISABLE_SPRING=1 echorun bundle exec parallel_cucumber `split_feature_scenarios $@` || return $?
}
