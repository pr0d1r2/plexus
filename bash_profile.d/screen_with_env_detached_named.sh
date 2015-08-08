function screen_with_env_detached_named() {
  echo "#!/bin/bash
    source $HOME/.bash_profile
    ${@:2}
    echo
    echo "Press ENTER to leave from shell."
    read X
  " > /tmp/.screen_with_env_detached_named-$$.sh
  chmod 700 /tmp/.screen_with_env_detached_named-$$.sh
  screen -S $1 -d -m /tmp/.screen_with_env_detached_named-$$.sh
}
