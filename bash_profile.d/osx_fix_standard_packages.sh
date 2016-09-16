function bash_profile.d/osx_fix_standard_packages() {
  sudo /usr/libexec/repair_packages --repair --standard-pkgs --volume / || return $?
}
