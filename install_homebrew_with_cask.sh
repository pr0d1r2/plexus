#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`

echo "Get sudo before any action ..."
sudo echo

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit $?

expect $D_R/xcode_accept_license.expect || exit $?

brew doctor || exit $?

brew install caskroom/cask/brew-cask || exit $?

brew cask || exit $?
sudo chown `whoami` /opt/homebrew-cask/Caskroom $HOME/Applications || exit $?

brew tap homebrew/versions || exit $?
