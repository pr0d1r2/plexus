function subtitles_adjust_fps() {
  local subtitles_adjust_fps_FILE
  local subtitles_adjust_fps_FILE_TMP
  local subtitles_adjust_fps_LINE
  local subtitles_adjust_fps_FPS_ADJUSTMENT=$1
  local subtitles_adjust_fps_FILE=$2
  local subtitles_adjust_fps_LINE_START
  local subtitles_adjust_fps_LINE_END
  local subtitles_adjust_fps_TIME_START_BEFORE
  local subtitles_adjust_fps_TIME_END_BEFORE
  local subtitles_adjust_fps_FPS_START_AFTER
  local subtitles_adjust_fps_FPS_END_AFTER
  local subtitles_adjust_fps_LINE_CONTENT
  local subtitles_adjust_fps_FILE_TMP="$subtitles_adjust_fps_FILE.adjusting.txt"
  local subtitles_adjust_fps_FILE_OLD="$subtitles_adjust_fps_FILE.before_adjustment.txt"
  local subtitles_adjust_fps_SEPARATOR_START
  local subtitles_adjust_fps_SEPARATOR_END

  cat $subtitles_adjust_fps_FILE | grep "^{.*}{.*}*" | grep -v -q "{y:u}"
  if [ $? -gt 0 ]; then
    cat $subtitles_adjust_fps_FILE | grep -q "^\[.*\]\[.*\]*"
    if [ $? -gt 0 ]; then
      echo
      echo "File is not FPS based ($subtitles_adjust_fps_FILE)"
      return 3259
    else
      subtitles_adjust_fps_SEPARATOR_START="["
      subtitles_adjust_fps_SEPARATOR_END="]"
    fi
  else
    subtitles_adjust_fps_SEPARATOR_START="{"
    subtitles_adjust_fps_SEPARATOR_END="}"
  fi

  if [ -f $subtitles_adjust_fps_FILE_OLD ]; then
    echo
    echo "File already adjusted ($subtitles_adjust_fps_FILE_OLD exist)"
    return 8472
  fi

  cat $subtitles_adjust_fps_FILE | while read subtitles_adjust_fps_LINE
  do
    subtitles_adjust_fps_LINE_START=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_adjust_fps_LINE | \
        cut -f 2 -d "$subtitles_adjust_fps_SEPARATOR_START" | \
        cut -f 1 -d "$subtitles_adjust_fps_SEPARATOR_END"
    )
    subtitles_adjust_fps_LINE_END=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_adjust_fps_LINE | \
        cut -f 3 -d "$subtitles_adjust_fps_SEPARATOR_START" | \
        cut -f 1 -d "$subtitles_adjust_fps_SEPARATOR_END"
    )

    subtitles_adjust_fps_FPS_START_AFTER=$(
      expr $subtitles_adjust_fps_LINE_START + $subtitles_adjust_fps_FPS_ADJUSTMENT
    )
    subtitles_adjust_fps_FPS_END_AFTER=$(
      expr $subtitles_adjust_fps_LINE_END + $subtitles_adjust_fps_FPS_ADJUSTMENT
    )

    subtitles_adjust_fps_LINE_CONTENT=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_adjust_fps_LINE | \
        cut -f 3 -d "$subtitles_adjust_fps_SEPARATOR_END"
    )

    echo "$subtitles_adjust_fps_SEPARATOR_START$subtitles_adjust_fps_FPS_START_AFTER$subtitles_adjust_fps_SEPARATOR_END$subtitles_adjust_fps_SEPARATOR_START$subtitles_adjust_fps_FPS_END_AFTER$subtitles_adjust_fps_SEPARATOR_END$subtitles_adjust_fps_LINE_CONTENT" \
      >> $subtitles_adjust_fps_FILE_TMP
  done

  mv $subtitles_adjust_fps_FILE $subtitles_adjust_fps_FILE_OLD || return $?
  mv $subtitles_adjust_fps_FILE_TMP $subtitles_adjust_fps_FILE || return $?
}
