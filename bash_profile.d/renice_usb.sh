function renice_usb() {
  renice_named /usr/libexec/usbd
  renice_named "usbmuxd -launchd"
}
