function subtitles_recalculate_fps() {
  local subtitles_recalculate_fps_FILE
  local subtitles_recalculate_fps_FILE_TMP
  local subtitles_recalculate_fps_LINE
  local subtitles_recalculate_fps_FPS_BEFORE=$1
  local subtitles_recalculate_fps_FPS_AFTER=$2
  local subtitles_recalculate_fps_FILE=$3
  local subtitles_recalculate_fps_LINE_START
  local subtitles_recalculate_fps_LINE_END
  local subtitles_recalculate_fps_TIME_START_BEFORE
  local subtitles_recalculate_fps_TIME_END_BEFORE
  local subtitles_recalculate_fps_FPS_START_AFTER
  local subtitles_recalculate_fps_FPS_END_AFTER
  local subtitles_recalculate_fps_LINE_CONTENT
  local subtitles_recalculate_fps_FILE_TMP="$subtitles_recalculate_fps_FILE.recalculating.txt"
  local subtitles_recalculate_fps_FILE_OLD="$subtitles_recalculate_fps_FILE.before_recalculate.txt"
  local subtitles_recalculate_fps_SEPARATOR_START
  local subtitles_recalculate_fps_SEPARATOR_END

  cat $subtitles_recalculate_fps_FILE | grep "^{.*}{.*}*" | grep -v -q "{y:u}"
  if [ $? -gt 0 ]; then
    cat $subtitles_recalculate_fps_FILE | grep -q "^\[.*\]\[.*\]*"
    if [ $? -gt 0 ]; then
      echo
      echo "File is not FPS based ($subtitles_recalculate_fps_FILE)"
      return 3259
    else
      subtitles_recalculate_fps_SEPARATOR_START="["
      subtitles_recalculate_fps_SEPARATOR_END="]"
    fi
  else
    subtitles_recalculate_fps_SEPARATOR_START="{"
    subtitles_recalculate_fps_SEPARATOR_END="}"
  fi

  if [ -f $subtitles_recalculate_fps_FILE_OLD ]; then
    echo
    echo "File already recalculated ($subtitles_recalculate_fps_FILE_OLD exist)"
    return 8472
  fi

  cat $subtitles_recalculate_fps_FILE | while read subtitles_recalculate_fps_LINE
  do
    subtitles_recalculate_fps_LINE_START=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_recalculate_fps_LINE | \
        cut -f 2 -d "$subtitles_recalculate_fps_SEPARATOR_START" | \
        cut -f 1 -d "$subtitles_recalculate_fps_SEPARATOR_END"
    )
    subtitles_recalculate_fps_LINE_END=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_recalculate_fps_LINE | \
        cut -f 3 -d "$subtitles_recalculate_fps_SEPARATOR_START" | \
        cut -f 1 -d "$subtitles_recalculate_fps_SEPARATOR_END"
    )

    subtitles_recalculate_fps_TIME_START_BEFORE=$(
      echo "scale=10; $subtitles_recalculate_fps_LINE_START/$subtitles_recalculate_fps_FPS_BEFORE"
    )
    subtitles_recalculate_fps_TIME_END_BEFORE=$(
      echo "scale=10; $subtitles_recalculate_fps_LINE_END/$subtitles_recalculate_fps_FPS_BEFORE"
    )

    subtitles_recalculate_fps_FPS_START_AFTER=$(
      echo "scale=10; $subtitles_recalculate_fps_TIME_START_BEFORE * $subtitles_recalculate_fps_FPS_AFTER" | \
        bc | cut -f 1 -d .
    )
    subtitles_recalculate_fps_FPS_END_AFTER=$(
      echo "scale=10; $subtitles_recalculate_fps_TIME_END_BEFORE * $subtitles_recalculate_fps_FPS_AFTER" | \
        bc | cut -f 1 -d .
    )

    subtitles_recalculate_fps_LINE_CONTENT=$(
      export LC_ALL=C
      export LANG=C
      echo $subtitles_recalculate_fps_LINE | \
        cut -f 3 -d "$subtitles_recalculate_fps_SEPARATOR_END"
    )

    echo "$subtitles_recalculate_fps_SEPARATOR_START$subtitles_recalculate_fps_FPS_START_AFTER$subtitles_recalculate_fps_SEPARATOR_END$subtitles_recalculate_fps_SEPARATOR_START$subtitles_recalculate_fps_FPS_END_AFTER$subtitles_recalculate_fps_SEPARATOR_END$subtitles_recalculate_fps_LINE_CONTENT" \
      >> $subtitles_recalculate_fps_FILE_TMP
  done

  mv $subtitles_recalculate_fps_FILE $subtitles_recalculate_fps_FILE_OLD || return $?
  mv $subtitles_recalculate_fps_FILE_TMP $subtitles_recalculate_fps_FILE || return $?
}
