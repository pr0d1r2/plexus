function time_tracker_copy_data_from_other_machine() {
  scp "$1:~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.slooz.timetracker.sfl" \
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.slooz.timetracker.sfl" \
    || return $?

  scp -r "$1:~/Library/Application Support/TimeTracker" \
    "~/Library/Application Support/TimeTracker" \
    || return $?

  scp "$1:~/Library/Preferences/com.slooz.timetracker.plist" \
    "~/Library/Preferences/com.slooz.timetracker.plist"
}
