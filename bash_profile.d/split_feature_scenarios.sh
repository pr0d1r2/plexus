function split_feature_scenarios() {
  local split_feature_scenarios_LINES
  local split_feature_scenarios_FEATURE
  local split_feature_scenarios_FIRST_SCENARIO_LINE
  local split_feature_scenarios_CONTENT_BEFORE_FIRST_SCENARIO
  local split_feature_scenarios_LINE
  local split_feature_scenarios_ENDING_LINE
  local split_feature_scenarios_DIRECTORY
  local split_feature_scenarios_SPLITTED_FILE
  for split_feature_scenarios_FEATURE in $@
  do
    split_feature_scenarios_LINES_REMAINING=`cucumber_scenarios_or_tags_at_lines $split_feature_scenarios_FEATURE`
    split_feature_scenarios_FIRST_SCENARIO_LINE=`echo $split_feature_scenarios_LINES_REMAINING | head -n 1`
    split_feature_scenarios_CONTENT_BEFORE_FIRST_SCENARIO=`cat $split_feature_scenarios_FEATURE | head -n \`expr $split_feature_scenarios_FIRST_SCENARIO_LINE - 1\``
    split_feature_scenarios_DIRECTORY="${split_feature_scenarios_FEATURE}_splitted"
    if [ ! -d $split_feature_scenarios_DIRECTORY ]; then
      mkdir $split_feature_scenarios_DIRECTORY
    fi
    for split_feature_scenarios_LINE in `cucumber_scenarios_or_tags_at_lines $split_feature_scenarios_FEATURE`
    do
      split_feature_scenarios_LINES_REMAINING=`echo $split_feature_scenarios_LINES_REMAINING | grep -v "^$split_feature_scenarios_LINE$"`
      if [ `echo $split_feature_scenarios_LINES_REMAINING | wc -l` -eq 1 ]; then
        split_feature_scenarios_ENDING_LINE=`echo $(cat $split_feature_scenarios_FEATURE | wc -l)`
      else
        split_feature_scenarios_ENDING_LINE=`expr \`echo $split_feature_scenarios_LINES_REMAINING | head -n 1\` - 1`
      fi
      split_feature_scenarios_SPLITTED_FILE="$split_feature_scenarios_DIRECTORY/$split_feature_scenarios_LINE.feature"
      echo $split_feature_scenarios_CONTENT_BEFORE_FIRST_SCENARIO > $split_feature_scenarios_SPLITTED_FILE
      sed -n $split_feature_scenarios_LINE,${split_feature_scenarios_ENDING_LINE}p $split_feature_scenarios_FEATURE >> $split_feature_scenarios_SPLITTED_FILE
    done
    echo $split_feature_scenarios_DIRECTORY
  done
}
