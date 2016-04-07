function binstubbed_excecutable() {
  if [ -x bin/$1 ]; then
    echo "bin/$1"
  else
    echo "$1"
  fi
}
