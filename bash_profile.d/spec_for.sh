function spec_for() {
  local spec_for_SPEC_FILE
  for spec_for_FILE in $@
  do
    spec_for_SPEC_FILE=`echo $spec_for_FILE | sed -e "s/app\//spec\//" | sed -s 's/.rb$/_spec.rb/' | sed -e 's/.slim$/.slim_spec.rb/'`
    if [ -f $spec_for_SPEC_FILE ]; then
      echo $spec_for_SPEC_FILE
    fi
  done
}
