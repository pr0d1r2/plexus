#!/bin/sh

function xonotic_install() {
  if [ ! -d ~/Library/Frameworks/SDL2.framework ]; then
    if [ ! -f ~/Downloads/SDL2-2.0.3.dmg ]; then
      curl https://www.libsdl.org/release/SDL2-2.0.3.dmg -o ~/Downloads/SDL2-2.0.3.dmg || return $?
    fi
    hdiutil attach ~/Downloads/SDL2-2.0.3.dmg || return $?
    if [ ! -d ~/Library/Frameworks ]; then
      mkdir ~/Library/Frameworks || return $?
    fi
    rsync -a /Volumes/SDL2/SDL2.framework/ ~/Library/Frameworks/SDL2.framework/
    if [ $? -gt 0 ]; then
      umount /Volumes/SDL2
      return 8472
    else
      umount /Volumes/SDL2
    fi
  fi
  if [ ! -d /Applications/Xonotic ]; then
    if [ ! -f ~/Downloads/xonotic-0.8.0.zip ]; then
      curl -L http://dl.xonotic.org/xonotic-0.8.0.zip -o ~/Downloads/xonotic-0.8.0.zip || return $?
    fi
    unzip -d /Applications/ ~/Downloads/xonotic-0.8.0.zip || return $?
  fi
  sh /Applications/Xonotic/misc/tools/rsync-updater/update-to-release.sh || return $?
}
