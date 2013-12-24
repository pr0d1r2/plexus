#!/bin/sh

RUBY_VERSION="2.0.0-p353"

function until_success() {
  false
  while [ $? -gt 0 ]; do
    $@
  done
}

function check_size() {
  echo "Check size of: $1"
  case `du -s $1 | cut -f 1` in
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
  if [ -f $1.shasum_ok ]; then
    echo "OK (cached)"
    return 0
  else
    case `shasum $1 | cut -b1-40` in
      $2)
        echo "OK"
        touch $1.shasum_ok
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
  if [ -f $1.md5_ok ]; then
    echo "OK (cached)"
    return 0
  else
    case `md5 $1 | cut -f 2 -d = | cut -b 2-33` in
      $2)
        echo "OK"
        touch $1.md5_ok
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
  if [ ! -f $1.mounted ]; then
    echo "Mounting $1 ..."
    hdiutil attach $1 && touch $1.mounted
    if [ $? -gt 0 ]; then
      return 1
    fi
  fi
}

function plexus_touch() {
  touch ~/.plexus/$1
}

function install_github_zip() {
  if [ ! -f ~/.plexus/github_zip-$1-$2.installed ]; then
    echo "Installing https://github.com/$1/$2 into $3 ..."
    if [ ! -f /tmp/$2.zip ]; then
      download https://github.com/$1/$2/archive/master.zip /tmp/$2.zip
    fi
    unzip -o -d /tmp /tmp/$2.zip || return $?
    if [ ! -d `dirname $3` ]; then
      mkdir -p `dirname $3` || return $?
    fi
    rsync -a /tmp/$2-master/ $3/ || return $?
    plexus_touch github_zip-$1-$2.installed
  fi
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
    XCODE_PATH="/tmp/$XCODE_FILE"
    XCODE_PATH_SIZE="8678032"
    XCODE_PATH_SHASUM="9eef71cd6687d19f42ce16e8b60fa3b549a58941"
    XCODE_PATH_MD5="7934f61ad86bc12ef6dd8fee2f2e9fb0"
    XCODE_PATH_URL_BASE="http://www.msg.ucsf.edu/local/programs/MacOSX"
    XCODE_MOUNTPOINT="/Volumes/Xcode and iOS SDK"
    XCODE_INSTALLER="$XCODE_MOUNTPOINT/Xcode and iOS SDK.mpkg"
    ;;
esac

if [ ! -d ~/.plexus ]; then
  mkdir ~/.plexus
fi

if [ ! -f ~/.plexus/$XCODE_FILE.installed ]; then
  check_size $XCODE_PATH $XCODE_PATH_SIZE && \
  check_shasum $XCODE_PATH $XCODE_PATH_SHASUM && \
  check_md5 $XCODE_PATH $XCODE_PATH_MD5
  if [ $? -gt 0 ]; then
    download $XCODE_PATH_URL_BASE/$XCODE_FILE $XCODE_PATH
  fi

  mount_dmg $XCODE_PATH || exit $?

  echo "Running XCode installer ..."
  sudo installer -pkg "$XCODE_INSTALLER" -target / || exit $?

  umount "$XCODE_MOUNTPOINT" || exit $?

  plexus_touch $XCODE_FILE.installed
fi

install_github_zip sstephenson rbenv ~/.rbenv/ || exit $?
install_github_zip sstephenson ruby-build ~/.rbenv/plugins/ruby-build/ || exit $?

export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

install_ruby $RUBY_VERSION || exit $?
rbenv global $RUBY_VERSION || exit $?
