function dvd_to_x265() {
  local dvd_to_x265_DIR
  local dvd_to_x265_FILE
  for dvd_to_x265_DIR in $@
  do
    if [ -d $dvd_to_x265_DIR ]; then
      if [ -d $dvd_to_x265_DIR/VIDEO_TS ]; then
        local dvd_to_x265_INPUT="concat:"
        for dvd_to_x265_FILE in `find $dvd_to_x265_DIR/VIDEO_TS -iname "*.vob" -type f`
        do
          dvd_to_x265_INPUT="$dvd_to_x265_INPUT|$dvd_to_x265_FILE"
        done
        dvd_to_x265_INPUT=`echo $dvd_to_x265_INPUT | sed -e 's/concat:|/concat:/'`
        echorun ffmpeg -i "$dvd_to_x265_INPUT" -c:v libx265 -preset medium -crf 28 -c:a copy -threads 0 $dvd_to_x265_DIR.x265.mp4 || \
          echo "Note that you may want to reinstall ffmpeg with 'brew reinstall ffmpeg --with-x265'"
      else
        echo
        echo "$0: no DVD in: $dvd_to_x265_DIR"
      fi
    else
      echo
      echo "$0: no directory: $dvd_to_x265_DIR"
    fi
  done
}
