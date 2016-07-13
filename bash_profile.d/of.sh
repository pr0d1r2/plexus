function of() {
  local of_FILE_FOUND
  for of_FILE_FOUND in `ff $@`
  do
    echorun open $of_FILE_FOUND
  done
}
