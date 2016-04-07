function split_feature_scenarios_and_run_in_parallel() {
  local split_feature_scenarios_and_run_in_parallel_FILE
  for split_feature_scenarios_and_run_in_parallel_FILE in $@
  do
    echorun bundle exec `rake_executable` "parallel:features[,'`split_feature_scenarios $split_feature_scenarios_and_run_in_parallel_FILE`']" || return $?
  done
}
