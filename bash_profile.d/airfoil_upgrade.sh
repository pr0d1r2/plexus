function airfoil_upgrade() {
  if [ -f /Library/Caches/Homebrew/airfoil-latest.zip ]; then
    rm /Library/Caches/Homebrew/airfoil-latest.zip
  fi
  brew cask install --force airfoil
}
