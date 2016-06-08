function renice_usb() {
  sudo renice -18 `ps -ax | grep "/usr/libexec/usbd" | grep -v grep | cut -b 1-5`
  sudo renice -18 `ps -ax | grep "usbmuxd -launchd" | grep -v grep | cut -b 1-5`
}
