function bersc() {
  if [ ! -d .git ]; then
    echo "$0: not a git repo!"
    return 1
  fi
  bersc_SPECS=()
  for bersc_FILE_CHANGED in `git st | grep _spec.rb | grep -v "^D  " | cut -b4- | sed -e 's/ -> /|/g' | cut -f 2 -d '|'`
  do
    bersc_SPECS+=$bersc_FILE_CHANGED
  done
  for bersc_FILE_CHANGED in `git st | grep -v "^##" | cut -b4- | grep -v "^D  " | sed -e 's/ -> /|/g' | cut -f 2 -d '|'`
  do
    bersc_SPEC_FROM_FILE_CHANGED=`echo $bersc_FILE_CHANGED | sed -e 's/^app/spec/' | sed -e 's/^lib/spec\/lib/' | sed -e 's/.rb$/_spec.rb/' | grep '_spec.rb' | grep -v '_spec_spec.rb'`
    if [ -f $bersc_SPEC_FROM_FILE_CHANGED ]; then
      bersc_SPECS+=$bersc_SPEC_FROM_FILE_CHANGED
    else
      echo "WARNING: missing spec: $bersc_SPEC_FROM_FILE_CHANGED"
    fi
  done
  case $bersc_SPECS in
    "")
      return 0
      ;;
    *)
      echo
      echorun bers $bersc_SPECS || return $?
      ;;
  esac
  unset bersc_SPECS
  unset bersc_FILE_CHANGED
  unset bersc_SPEC_FROM_FILE_CHANGED
}
