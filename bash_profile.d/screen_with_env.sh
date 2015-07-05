function screen_with_env() {
  echo "#!/bin/bash
    source $HOME/.bash_profile
    $@
    echo
    echo "Press ENTER to leave from shell."
    read X
  " > /tmp/.screen_with_env-$$.sh
  chmod 700 /tmp/.screen_with_env-$$.sh
  screen /tmp/.screen_with_env-$$.sh
}
