#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`

RUBY_VERSION=`head -n 1 $D_R/ruby-versions`

function until_success() {
  false
  while [ $? -gt 0 ]; do
    $@
  done
}

function check_size() {
  echo "Check size of: $1"
  case `du -s "$1" | cut -f 1` in
    $2)
      echo "OK"
      return 0
      ;;
    *)
      echo "BAD"
      return 1
      ;;
  esac
}

function check_shasum() {
  echo "Check shasum of: $1"
  if [ -f /tmp/`basename "$1"`.shasum_ok ]; then
    echo "OK (cached)"
    return 0
  else
    case `shasum "$1" | cut -b1-40` in
      $2)
        echo "OK"
        touch /tmp/`basename "$1"`.shasum_ok
        return 0
        ;;
      *)
        echo "BAD"
        return 1
        ;;
    esac
  fi
}

function check_md5() {
  echo "Check md5 of: $1"
  if [ -f /tmp/`basename "$1"`.md5_ok ]; then
    echo "OK (cached)"
    return 0
  else
    case `md5 "$1" | cut -f 2 -d = | cut -b 2-33` in
      $2)
        echo "OK"
        touch /tmp/`basename "$1"`.md5_ok
        return 0
        ;;
      *)
        echo "BAD"
        return 1
        ;;
    esac
  fi
}

function download() {
  until_success curl -L $1 -o $2
}

function mount_dmg() {
  if [ ! -f /tmp/`basename "$1"`.mounted ]; then
    echo "Mounting $1 ..."
    hdiutil attach "$1" && touch /tmp/`basename "$1"`.mounted
    if [ $? -gt 0 ]; then
      return 1
    fi
  fi
}

function plexus_touch() {
  touch ~/.plexus/$1
}

function install_ruby() {
  if [ ! -f ~/.plexus/ruby-$1.installed ]; then
    echo "Installing ruby $1 ..."
    rbenv install $1 || return $?
    plexus_touch ruby-$1.installed
  fi
}

function install_gem() {
  if [ ! -f ~/.plexus/gem-$1-$RUBY_VERSION.installed ]; then
    echo "Installing gem $1 ..."
    gem install $1 --no-ri --no-rdoc || return $?
    plexus_touch gem-$1-$RUBY_VERSION.installed
  fi
}

function run() {
  RUN_LOCK="/tmp/run-`echo $@ | tr ' ' '-'`"
  if [ ! -f $RUN_LOCK ]; then
    echo "Running $@ ..."
    $@
    touch $RUN_LOCK
  else
    echo "Already running $@ ..."
  fi
}

function params_from_second() {
  echo $@ | cut -f2- -d " "
}

function params_from_third() {
  echo $@ | cut -f3- -d " "
}

function run_once_a_day() {
  DATESTAMP=`date "+%Y-%m-%d"`
  if [ ! -f /tmp/$1-$DATESTAMP ]; then
    LAST_PARAMS=`params_from_second $@`
    echo "Running: $LAST_PARAMS"
    $LAST_PARAMS || exit $?
    touch /tmp/$1-$DATESTAMP
  fi
}

function run_once() {
  if [ ! -f ~/.plexus/$1 ]; then
    LAST_PARAMS=`params_from_second $@`
    echo "Running: $LAST_PARAMS"
    $LAST_PARAMS || exit $?
    plexus_touch $1
  fi
}

function run_once_with_killall() {
  if [ ! -f ~/.plexus/$1 ]; then
    LAST_PARAMS=`params_from_third $@`
    echo "Running: $LAST_PARAMS"
    $LAST_PARAMS || exit $?
    plexus_touch $1
    MARKED_FOR_KILLALL="$MARKED_FOR_KILLALL $2"
  fi
}

function ensure_project_file() {
  for FILE in $@
  do
    if [ ! -f $D_R/$FILE ]; then
      FILE_DIR=`dirname $D_R/$FILE`
      if [ ! -d $FILE_DIR ]; then
        mkdir -p $FILE_DIR
      fi
      curl https://raw.githubusercontent.com/pr0d1r2/plexus/master/$FILE \
        -o $D_R/$FILE || exit $?
    fi
  done
}

function ensure_ruby2() {
  export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  install_ruby $RUBY_VERSION || exit $?
  if [ ! -f ~/.plexus/ruby-$RUBY_VERSION.set_global ]; then
    rbenv global $RUBY_VERSION || exit $?
    plexus_touch ruby-$RUBY_VERSION.set_global
  fi
}

function run_brew() {
  case $1 in
    "")
      return 0
      ;;
    update)
      run_once_a_day brew.updated brew update
      ;;
    install)
      case $2 in
        caskroom/cask/brew-cask)
          case $OSX_VERSION_MINOR in
            10.4)
              echo "cask commands not supported on 10.4"
              ;;
            *)
              ensure_ruby2
              run_once brew-cask.installed brew $@
              ;;
          esac
          ;;
        *)
          run_once brew_${2}.installed brew $@
          ;;
      esac
      ;;
    cask)
      case $OSX_VERSION_MINOR in
        10.4)
          echo "cask commands not supported on 10.4"
          ;;
        *)
          case $2 in
            install)
              run_once brew_cask_${3}.installed brew $@
              ;;
            "")
              run_once brew-cask.runned brew cask
              run_once brew_permissions.set sudo chown `whoami` /opt/homebrew-cask/Caskroom
              ;;
          esac
          ;;
      esac
      ;;
    *)
      brew $@ || return $?
      ;;
  esac
}

function brew_bundle_install() {
  ensure_project_file Brewfile
  cat $D_R/Brewfile | while read LINE; do run_brew $LINE; done
}

function install_dotfile() {
  ensure_project_file dotfiles/$1
  cat $D_R/dotfiles/$1 > $HOME/.$1
}

function volumes_mount_points() {
  mount  | grep " on /Volumes" | sed -e 's/ on /(/g' | cut -f 2 -d \(
}

function detect_file_on_volumes() {
  volumes_mount_points | while read LINE; do
    if [ -f "$LINE/$1" ]; then
      echo "$LINE/$1"
      return 0
    fi
  done
}

function detect_file() {
  DETECTED_FILE="`detect_file_on_volumes $1`"
  case $DETECTED_FILE in
    "")
      case $OSX_VERSION_MINOR in
        10.4)
          DETECTED_FILE="$HOME/Desktop/$1"
          ;;
        *)
          DETECTED_FILE="$HOME/Downloads/$1"
          ;;
      esac
      ;;
  esac
  echo $DETECTED_FILE
}

function janus_update() {
  cd ~/.vim && rake
}

function dotjanus_update() {
  cd ~/.janus && git pull && git submodule update --init --recursive
}

if [ ! -d ~/.plexus ]; then
  mkdir ~/.plexus
fi

UNAME=`uname`
MARKED_FOR_KILLALL=""

function killall_marked() {
  for APP in `echo $MARKED_FOR_KILLALL | tr " " "\n" | sort | uniq`
  do
    killall $APP
  done
}

case $UNAME in
  Darwin)
    OSX_VERSION=`sw_vers -productVersion`
    OSX_VERSION_MINOR=`echo $OSX_VERSION | cut -f1-2 -d .`
    ;;
esac

case $OSX_VERSION_MINOR in
  10.4)
    XCODE_FILE="xcode25_8m2558_developerdvd.dmg"
    XCODE_PATH_SIZE="1849160"
    XCODE_PATH_SHASUM="not viable in default 10.4"
    XCODE_PATH_MD5="3bd6c24d8fbbdf9007e15861d173764d"
    XCODE_PATH_URL_BASE="https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_2.5_developer_tools/"
    XCODE_MOUNTPOINT="/Volumes/Xcode Tools"
    XCODE_INSTALLER="$XCODE_MOUNTPOINT/Packages/XcodeTools.mpkg"
    ;;
  10.6)
    XCODE_FILE="xcode_3.2.6_and_ios_sdk_4.3.dmg"
    XCODE_PATH_SIZE="8678032"
    XCODE_PATH_SHASUM="9eef71cd6687d19f42ce16e8b60fa3b549a58941"
    XCODE_PATH_MD5="7934f61ad86bc12ef6dd8fee2f2e9fb0"
    XCODE_PATH_URL_BASE="http://www.msg.ucsf.edu/local/programs/MacOSX"
    XCODE_MOUNTPOINT="/Volumes/Xcode and iOS SDK"
    XCODE_INSTALLER="$XCODE_MOUNTPOINT/Xcode and iOS SDK.mpkg"
    ;;
  10.8)
    case $OSX_VERSION in
      10.8.4 | 10.8.5)
      XCODE_FILE="xcode_5.1.1.dmg"
      XCODE_PATH_SIZE="4464688"
      XCODE_PATH_SHASUM="e4bb45174324c3a4b7c66fa1db1083ccbbe2334e"
      XCODE_PATH_MD5="99b22d57e71bdc86b8fbe113dfb9f739"
      XCODE_MOUNTPOINT="/Volumes/Xcode"
      XCODE_CMD_LINE_TOOLS_FILE="command_line_tools_for_osx_mountain_lion_april_2014.dmg"
      XCODE_CMD_LINE_TOOLS_PATH_SIZE="242384"
      XCODE_CMD_LINE_TOOLS_PATH_SHASUM="575614b07117b7ddaf69a2edfb09b11e544f48b9"
      XCODE_CMD_LINE_TOOLS_PATH_MD5="69ccc4ff9e5ecd0958ad13318a3a212a"
      XCODE_CMD_LINE_TOOLS_MOUNTPOINT="/Volumes/Command Line Tools (Mountain Lion)"
      XCODE_CMD_LINE_TOOLS_INSTALLER="$XCODE_CMD_LINE_TOOLS_MOUNTPOINT/Command Line Tools (Mountain Lion).mpkg"
      ;;
    esac
    ;;
  10.10)
    XCODE_FILE="xcode_6.1.dmg"
    XCODE_PATH_SIZE="5252160"
    XCODE_PATH_SHASUM="b2ed3dbdeb5367f97a90274a3043ca68ad47a56c"
    XCODE_PATH_MD5="22fbf9b605e049bc2aee280d24ac0737"
    XCODE_MOUNTPOINT="/Volumes/Xcode"
    XCODE_CMD_LINE_TOOLS_FILE="command_line_tools_for_osx_10.10_for_xcode_6.1.dmg"
    XCODE_CMD_LINE_TOOLS_PATH_SIZE="348040"
    XCODE_CMD_LINE_TOOLS_PATH_SHASUM="6a4d74df2153e9a8cd76e4243f66cd4b1b407eb0"
    XCODE_CMD_LINE_TOOLS_PATH_MD5="75982d25549ad85e23dec13931454a61"
    XCODE_CMD_LINE_TOOLS_MOUNTPOINT="/Volumes/Command Line Developer Tools"
    XCODE_CMD_LINE_TOOLS_INSTALLER="$XCODE_CMD_LINE_TOOLS_MOUNTPOINT/Command Line Tools (OS X 10.10).pkg"
    ;;
esac

XCODE_PATH="`detect_file $XCODE_FILE`"
case $XCODE_CMD_LINE_TOOLS_FILE in
  "")
    ;;
  *)
    XCODE_CMD_LINE_TOOLS_PATH="`detect_file $XCODE_CMD_LINE_TOOLS_FILE`"
    ;;
esac

if [ ! -f ~/.plexus/$XCODE_FILE.installed ]; then
  case $XCODE_PATH in
    "")
      ;;
    *)
      check_size "$XCODE_PATH" $XCODE_PATH_SIZE && \
      case $OSX_VERSION_MINOR in
        10.4)
          check_md5 "$XCODE_PATH" $XCODE_PATH_MD5
          ;;
        10.6)
          check_shasum "$XCODE_PATH" $XCODE_PATH_SHASUM && \
          check_md5 "$XCODE_PATH" $XCODE_PATH_MD5
          ;;
      esac
      case $OSX_VERSION_MINOR in
        10.4 | 10.6)
          if [ $? -gt 0 ]; then
            case $OSX_VERSION_MINOR in
              10.4)
                echo "Download $XCODE_PATH_URL_BASE/$XCODE_FILE manually and restart this script."
                echo "Browser will auto-open in 5 seconds ..."
                sleep 5
                open -a Safari "$XCODE_PATH_URL_BASE/$XCODE_FILE"
                exit 7777
                ;;
              *)
                download $XCODE_PATH_URL_BASE/$XCODE_FILE $XCODE_PATH
                ;;
            esac
          fi
          mount_dmg "$XCODE_PATH" || exit $?
          echo "Running XCode installer ..."
          sudo installer -pkg "$XCODE_INSTALLER" -target / || exit $?
          ;;
        *)
          if [ $? -gt 0 ]; then
            echo "Invalid Xcode dmg (please download it again): $XCODE_PATH"
            exit 8472
          fi
          check_size "$XCODE_CMD_LINE_TOOLS_PATH" $XCODE_CMD_LINE_TOOLS_PATH_SIZE && \
          check_shasum "$XCODE_CMD_LINE_TOOLS_PATH" $XCODE_CMD_LINE_TOOLS_PATH_SHASUM && \
          check_md5 "$XCODE_CMD_LINE_TOOLS_PATH" $XCODE_CMD_LINE_TOOLS_PATH_MD5
          if [ $? -gt 0 ]; then
            echo "Invalid Xcode Command Line Tools dmg (please download it again): $XCODE_CMD_LINE_TOOLS_PATH_MD5"
            exit 8473
          fi
          mount_dmg "$XCODE_PATH" || exit $?
          rsync -a "$XCODE_MOUNTPOINT/Xcode.app/" /Applications/Xcode.app/ || exit $?
          mount_dmg "$XCODE_CMD_LINE_TOOLS_PATH"
          sudo installer -pkg "$XCODE_CMD_LINE_TOOLS_INSTALLER" -target / || exit $?
          umount "$XCODE_CMD_LINE_TOOLS_MOUNTPOINT" || exit $?
          ;;
      esac
      umount "$XCODE_MOUNTPOINT" || exit $?
      plexus_touch $XCODE_FILE.installed
      ;;
  esac
fi

case $OSX_VERSION_MINOR in
  10.4)
    ;;
  *)
    if [ ! -f ~/.plexus/xcode_license.accepted ]; then
      ensure_project_file xcode_accept_license.expect
      case $OSX_VERSION_MINOR in
        10.10)
          sudo expect $D_R/xcode_accept_license.expect || exit $?
          ;;
        *)
          expect $D_R/xcode_accept_license.expect || exit $?
          ;;
      esac
      plexus_touch xcode_license.accepted
    fi
    ;;
esac

if [ ! -f ~/.plexus/homebrew.installed ]; then
  case $OSX_VERSION_MINOR in
    10.4)
      ruby -e "$(curl -fsSkL raw.github.com/mistydemeo/tigerbrew/go/install)" || exit $?
      plexus_touch homebrew.installed
      ;;
    *)
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit $?
      plexus_touch homebrew.installed
      ;;
  esac
fi

case $OSX_VERSION_MINOR in
  10.4)
    PATH="/usr/local/bin:$PATH"
    run_brew install apple-gcc42
    if [ ! -f /usr/sbin/pkgutil ]; then
      sudo touch /usr/sbin/pkgutil
      chmod 755 /usr/sbin/pkgutil
    fi
    run_brew install git
    ;;
esac

run_once brew_doctor.done brew doctor

brew_bundle_install

run_once homebrew_var_directory.create sudo mkdir /usr/local/var
run_once htop.chown sudo chown root:wheel /usr/local/Cellar/htop-osx/*/bin/htop
run_once htop.chmod sudo chmod u+s /usr/local/Cellar/htop-osx/*/bin/htop
run_once password_delay.set defaults write com.apple.screensaver askForPasswordDelay 5
run_once mongodb.linked ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
run_once mongodb.loaded launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
run_once pow--install-system.done sudo pow --install-system
run_once pow--install-local.done pow --install-local
run_once pow-firewall.loaded sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
run_once pow-powd.loaded launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
if [ ! -d "$HOME/Library/Application Support/Pow/Hosts" ]; then
  mkdir -p "$HOME/Library/Application Support/Pow/Hosts" || exit $?
fi
if [ ! -L ~/.pow ]; then
  ln -s ~/Library/Application\ Support/Pow/Hosts ~/.pow
fi
run_once memcached.linked ln -sfv /usr/local/opt/memcached/*.plist ~/Library/LaunchAgents
run_once memcached.loaded launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
run_once redis.linked ln -sfv ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
run_once redis.loaded launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
if [ ! -f ~/.plexus/tunnelss.installed ]; then
  cat $D_R/org.rubygems.tunnelss.plist | sed -e "s/pr0d1r2/$USER/g" > /tmp/org.rubygems.tunnelss.plist
  sudo mv /tmp/org.rubygems.tunnelss.plist /Library/LaunchDaemons/org.rubygems.tunnelss.plist
  sudo chown root:wheel /Library/LaunchDaemons/org.rubygems.tunnelss.plist
  sudo launchctl load /Library/LaunchDaemons/org.rubygems.tunnelss.plist
  plexus_touch tunnelss.installed
fi
source $D_R/bash_profile.d/GOPATH.sh
export GOPATH
run_once_a_day ipfs.got go get -u github.com/ipfs/go-ipfs/cmd/ipfs
run_once_a_day fuse-version.got go get github.com/jbenet/go-fuse-version/fuse-version
run_once ipfs-directories.created sudo mkdir /ipfs /ipns
run_once mysql.linked ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
run_once mysql.loaded launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

run_once_a_day xonotic.update sh $HOME/Applications/Xonotic/misc/tools/rsync-updater/update-to-release.sh

ensure_ruby2

ensure_project_file ruby-versions
cat $D_R/ruby-versions | while read LINE; do install_ruby $LINE; done

install_gem bundler || exit $?
bundle install || exit $?


install_dotfile gitconfig
install_dotfile vimrc.after
install_dotfile gemrc
install_dotfile spcrc

for NPM_PKG in `cat $D_R/NpmFile`
do
  run_once npm-install-$NPM_PKG npm install -g $NPM_PKG
done

if [ ! -f ~/.plexus/vim_janus.set ]; then
  curl -Lo- https://bit.ly/janus-bootstrap | bash
  plexus_touch vim_janus.set
else
  run_once_a_day janus_update
fi

if [ -d ~/.janus ]; then
  run_once_a_day dotjanus_update
else
  git clone git@github.com:pr0d1r2/dotjanus.git ~/.janus
  dotjanus_update
fi

if [ ! -f ~/.antigen.zsh ]; then
  curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh -o ~/.antigen.zsh
fi
install_dotfile zshrc
run_once zsh_as_shell.set chsh -s /usr/local/bin/zsh

# Automatically hide and show the Dock
run_once_with_killall dock_autohide.enable Dock defaults write com.apple.dock autohide -bool true

# Wipe all (default) app icons from the Dock
run_once_with_killall dock.cleanup Dock defaults write com.apple.dock persistent-apps -array ""

# Set computer name (as done via System Preferences → Sharing)
case $HOST_NAME in
  "")
    ;;
  *)
    run_once host_name.computer sudo scutil --set ComputerName "$HOST_NAME"
    run_once host_name.host sudo scutil --set HostName "$HOST_NAME"
    run_once host_name.localhost sudo scutil --set LocalHostName "$HOST_NAME"
    run_once host_name.netbiosname sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$HOST_NAME"
    ;;
esac

case $OSX_VERSION_MINOR in
  10.10)
    # Disable transparency in the menu bar and elsewhere on Yosemite
    run_once_with_killall ui_transparency.disable Dock defaults write com.apple.universalaccess reduceTransparency -bool true
    ;;
esac

if [ ! -f ~/.plexus/terminal_theme.set ]; then
  # Use a modified version of the Solarized Dark theme by default in Terminal.app
  TERM_PROFILE='Solarized Dark xterm-256color';
  CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
  if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "${D_R}/${TERM_PROFILE}.terminal";
    sleep 1; # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
    defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
  fi;
  plexus_touch terminal_theme.set
fi


killall_marked


rbenv init - > $HOME/.bash_profile
for FILE in `ls $D_R/bash_profile.d/*.sh`
do
  cat $FILE >> $HOME/.bash_profile
done
if [ -d ~/projects/local_shell_aliases ]; then
  for FILE in `ls ~/projects/local_shell_aliases/*.sh`
  do
    cat $FILE >> $HOME/.bash_profile
  done
fi
