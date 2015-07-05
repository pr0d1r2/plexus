function screen_with_env_detached() {
  echo "#!/bin/bash
    source $HOME/.bash_profile
    $@
    echo
    echo "Press ENTER to leave from shell."
    read X
  " > /tmp/.screen_with_env_detached-$$.sh
  chmod 700 /tmp/.screen_with_env_detached-$$.sh
  screen -d -m /tmp/.screen_with_env_detached-$$.sh
}
