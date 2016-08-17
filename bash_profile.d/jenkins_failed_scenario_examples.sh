function jenkins_failed_scenario_examples() {
  local jenkins_failed_scenario_examples_SCENARIO
  local jenkins_failed_scenario_examples_EXAMPLE

  for jenkins_failed_scenario_examples_SCENARIO in `cat ~/Downloads/Test\ \[Jenkins\].htm | sed -e 's/<td class="pane"/|TD/g' | tr '|' "\n" | grep "^TD" | grep "testReport/(root)" | cut -f 3 -d '>' | cut -f 1 -d '<' | sed -e 's/&nbsp;//g' | cut -f 1 -d '(' | uniq | cut -f 2 -d . | tr ' ' '.'`
  do
    for jenkins_failed_scenario_examples_EXAMPLE in `ag "\`echo "Scenario: $jenkins_failed_scenario_examples_SCENARIO" | tr '.' ' '\`$" features`
    do
      case $jenkins_failed_scenario_examples_EXAMPLE in
        features/*)
          echo $jenkins_failed_scenario_examples_EXAMPLE | sed -e "s/:$//g"
          ;;
      esac
    done
  done
}
