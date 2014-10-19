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

# get sudo to make proces not interruptable
sudo -v

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
  10.8)
    case $OSX_VERSION in
      10.8.4 | 10.8.5)
      XCODE_FILE="xcode_5.1.1.dmg"
      XCODE_PATH="$HOME/Downloads/$XCODE_FILE"
      XCODE_PATH_SIZE="4464688"
      XCODE_PATH_SHASUM="e4bb45174324c3a4b7c66fa1db1083ccbbe2334e"
      XCODE_PATH_MD5="99b22d57e71bdc86b8fbe113dfb9f739"
      XCODE_MOUNTPOINT="/Volumes/Xcode"
      XCODE_CMD_LINE_TOOLS_FILE="command_line_tools_for_osx_mountain_lion_april_2014.dmg"
      XCODE_CMD_LINE_TOOLS_PATH="$HOME/Downloads/$XCODE_CMD_LINE_TOOLS_FILE"
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
    XCODE_PATH="$HOME/Downloads/$XCODE_FILE"
    XCODE_PATH_SIZE="5252160"
    XCODE_PATH_SHASUM="b2ed3dbdeb5367f97a90274a3043ca68ad47a56c"
    XCODE_PATH_MD5="22fbf9b605e049bc2aee280d24ac0737"
    XCODE_MOUNTPOINT="/Volumes/Xcode"
    XCODE_CMD_LINE_TOOLS_FILE="command_line_tools_for_osx_10.10_for_xcode_6.1.dmg"
    XCODE_CMD_LINE_TOOLS_PATH="$HOME/Downloads/$XCODE_CMD_LINE_TOOLS_FILE"
    XCODE_CMD_LINE_TOOLS_PATH_SIZE="348040"
    XCODE_CMD_LINE_TOOLS_PATH_SHASUM="6a4d74df2153e9a8cd76e4243f66cd4b1b407eb0"
    XCODE_CMD_LINE_TOOLS_PATH_MD5="75982d25549ad85e23dec13931454a61"
    XCODE_CMD_LINE_TOOLS_MOUNTPOINT="/Volumes/Command Line Developer Tools"
    XCODE_CMD_LINE_TOOLS_INSTALLER="$XCODE_CMD_LINE_TOOLS_MOUNTPOINT/Command Line Tools (OS X 10.10).pkg"
    ;;
esac

if [ ! -d ~/.plexus ]; then
  mkdir ~/.plexus
fi

if [ ! -f ~/.plexus/$XCODE_FILE.installed ]; then
  case $XCODE_PATH in
    "")
      ;;
    *)
      check_size $XCODE_PATH $XCODE_PATH_SIZE && \
      check_shasum $XCODE_PATH $XCODE_PATH_SHASUM && \
      check_md5 $XCODE_PATH $XCODE_PATH_MD5
      case $OSX_VERSION_MINOR in
        10.6)
          if [ $? -gt 0 ]; then
            download $XCODE_PATH_URL_BASE/$XCODE_FILE $XCODE_PATH
          fi
          mount_dmg $XCODE_PATH || exit $?
          echo "Running XCode installer ..."
          sudo installer -pkg "$XCODE_INSTALLER" -target / || exit $?
          ;;
        *)
          if [ $? -gt 0 ]; then
            echo "Invalid Xcode dmg (please download it again): $XCODE_PATH"
            exit 8472
          fi
          check_size $XCODE_CMD_LINE_TOOLS_PATH $XCODE_CMD_LINE_TOOLS_PATH_SIZE && \
          check_shasum $XCODE_CMD_LINE_TOOLS_PATH $XCODE_CMD_LINE_TOOLS_PATH_SHASUM && \
          check_md5 $XCODE_CMD_LINE_TOOLS_PATH $XCODE_CMD_LINE_TOOLS_PATH_MD5
          if [ $? -gt 0 ]; then
            echo "Invalid Xcode Command Line Tools dmg (please download it again): $XCODE_CMD_LINE_TOOLS_PATH_MD5"
            exit 8473
          fi
          mount_dmg $XCODE_PATH || exit $?
          rsync -a $XCODE_MOUNTPOINT/Xcode.app/ /Applications/Xcode.app/ || exit $?
          mount_dmg $XCODE_CMD_LINE_TOOLS_PATH
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
  if [ ! -f $D_R/xcode_accept_license.expect ]; then
    curl https://raw.githubusercontent.com/pr0d1r2/plexus/master/xcode_accept_license.expect \
      -o $D_R/xcode_accept_license.expect || exit $?
  fi
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

install_github_zip sstephenson rbenv ~/.rbenv/ || exit $?
install_github_zip sstephenson ruby-build ~/.rbenv/plugins/ruby-build/ || exit $?

export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

install_ruby $RUBY_VERSION || exit $?
rbenv global $RUBY_VERSION || exit $?

if [ ! -f ~/.plexus/homebrew.installed ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit $?
  plexus_touch homebrew.installed
fi

if [ ! -f ~/.plexus/brew_doctor.done ]; then
  brew doctor || exit $?
  plexus_touch brew_doctor.done
fi

if [ ! -f ~/.plexus/brew-cask.installed ]; then
  brew install caskroom/cask/brew-cask || exit $?
  plexus_touch brew-cask.installed
fi

if [ ! -f ~/.plexus/brew-cask.runned ]; then
  brew cask || exit $?
  plexus_touch brew-cask.runned
fi

if [ ! -f ~/.plexus/brew_permissions.set ]; then
  sudo chown `whoami` /opt/homebrew-cask/Caskroom || exit $?
  plexus_touch brew_permissions.set
fi

if [ ! -f ~/.plexus/homebrew_versions.tapped ]; then
  brew tap homebrew/versions || exit $?
  plexus_touch homebrew_versions.tapped
fi

if [ ! -f $D_R/Brewfile ]; then
  curl https://raw.githubusercontent.com/pr0d1r2/plexus/master/Brewfile \
    -o $D_R/Brewfile || exit $?
fi

function run_brew() {
  case $1 in
    "")
      return 0
      ;;
  esac
  brew $@ || return $?
}
cat $D_R/Brewfile | while read LINE; do run_brew $LINE; done

echo > $HOME/.bash_profile
for FILE in $D_R/bash_profile.d/*.sh
do
  cat $FILE > $HOME/.bash_profile
done
