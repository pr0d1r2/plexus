#!/bin/sh

RUBY_VERSION="2.1.3"

D_R=`cd \`dirname $0\` ; pwd -P`

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
  if [ ! -f ~/.plexus/gem-$1.installed ]; then
    echo "Installing gem $1 ..."
    gem install $1 --no-ri --no-rdoc || return $?
    plexus_touch gem-$1.installed
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

function run_once() {
  if [ ! -f ~/.plexus/$1 ]; then
    LAST_PARAMS=`params_from_second $@`
    echo "Running: $LAST_PARAMS"
    $LAST_PARAMS || exit $?
    plexus_touch $1
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

function run_brew() {
  case $1 in
    "")
      return 0
      ;;
    install)
      run_once brew_${2}.installed brew $@
      ;;
    cask)
      case $2 in
        install)
          run_once brew_cask_${3}.installed brew $@
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
  ensure_project_file $1
  cat $D_R/$1 > $HOME/.$1
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
      DETECTED_FILE="$HOME/Downloads/$1"
      ;;
  esac
  echo $DETECTED_FILE
}

if [ ! -d ~/.plexus ]; then
  mkdir ~/.plexus
fi

UNAME=`uname`

case $UNAME in
  Darwin)
    OSX_VERSION=`sw_vers -productVersion`
    OSX_VERSION_MINOR=`echo $OSX_VERSION | cut -f1-2 -d .`
    ;;
esac

case $OSX_VERSION_MINOR in
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
      check_shasum "$XCODE_PATH" $XCODE_PATH_SHASUM && \
      check_md5 "$XCODE_PATH" $XCODE_PATH_MD5
      case $OSX_VERSION_MINOR in
        10.6)
          if [ $? -gt 0 ]; then
            download $XCODE_PATH_URL_BASE/$XCODE_FILE $XCODE_PATH
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

 
if [ ! -f ~/.plexus/homebrew.installed ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit $?
  plexus_touch homebrew.installed
fi

run_once brew_doctor.done brew doctor
run_once brew-cask.installed brew install caskroom/cask/brew-cask
run_once brew-cask.runned brew cask
run_once brew_permissions.set sudo chown `whoami` /opt/homebrew-cask/Caskroom
run_once homebrew_versions.tapped brew tap homebrew/versions

brew_bundle_install

run_once homebrew_var_directory.create sudo mkdir /usr/local/var
run_once postgres_database_directory.create sudo mkdir /usr/local/var/postgres
run_once postgres_database_directory.ownership sudo chown $USER /usr/local/var/postgres
run_once postgres_database.create initdb /usr/local/var/postgres -E utf8
run_once postgresql92.linked ln -sfv /usr/local/opt/postgresql92/*.plist ~/Library/LaunchAgents
run_once postgresql92.loaded launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql92.plist


export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

install_ruby $RUBY_VERSION || exit $?
rbenv global $RUBY_VERSION || exit $?

ensure_project_file ruby-versions
cat $D_R/ruby-versions | while read LINE; do install_ruby $LINE; done

install_gem bundler || exit $?


install_dotfile gitconfig


rbenv init - > $HOME/.bash_profile
for FILE in $D_R/bash_profile.d/*.sh
do
  cat $FILE > $HOME/.bash_profile
done
