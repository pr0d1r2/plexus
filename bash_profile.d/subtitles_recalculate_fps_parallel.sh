function subtitles_recalculate_fps_parallel() {
  local subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM
  local subtitles_recalculate_fps_parallel_FPS_BEFORE=$1
  local subtitles_recalculate_fps_parallel_FPS_AFTER=$2
  local subtitles_recalculate_fps_parallel_FILE=$3
  local subtitles_recalculate_fps_parallel_LINES
  local subtitles_recalculate_fps_parallel_CUT
  local subtitles_recalculate_fps_parallel_CUT_LINE
  local subtitles_recalculate_fps_parallel_LINE_START
  local subtitles_recalculate_fps_parallel_LINE_END
  local subtitles_recalculate_fps_parallel_FILE_SPLITTED
  local subtitles_recalculate_fps_parallel_FILE_OLD
  case `uname` in
    Darwin)
      subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM=`sysctl -n hw.ncpu`
      ;;
    Linux)
      subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM=`nproc`
      ;;
  esac
  subtitles_recalculate_fps_parallel_LINES=`echo $(
    cat $subtitles_recalculate_fps_parallel_FILE | wc -l
  )`
  subtitles_recalculate_fps_parallel_CUT_LINE=$(
    expr $subtitles_recalculate_fps_parallel_LINES / $subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM
  )
  subtitles_recalculate_fps_parallel_LINE_START=1
  for subtitles_recalculate_fps_parallel_CUT in $(seq 1 $subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM)
  do
    subtitles_recalculate_fps_parallel_FILE_SPLITTED=$subtitles_recalculate_fps_parallel_FILE.$subtitles_recalculate_fps_parallel_CUT.txt
    if [ $subtitles_recalculate_fps_parallel_CUT -eq $subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM ]; then
      subtitles_recalculate_fps_parallel_LINE_END=$subtitles_recalculate_fps_parallel_LINES
    else
      subtitles_recalculate_fps_parallel_LINE_END=$(
        expr $subtitles_recalculate_fps_parallel_CUT \* $subtitles_recalculate_fps_parallel_CUT_LINE
      )
    fi
    sed -n $subtitles_recalculate_fps_parallel_LINE_START,${subtitles_recalculate_fps_parallel_LINE_END}p \
      $subtitles_recalculate_fps_parallel_FILE > $subtitles_recalculate_fps_parallel_FILE_SPLITTED
    subtitles_recalculate_fps_parallel_LINE_START=$(
      expr $subtitles_recalculate_fps_parallel_LINE_END + 1
    )
    subtitles_recalculate_fps $1 $2 $subtitles_recalculate_fps_parallel_FILE_SPLITTED &
  done

  wait

  subtitles_recalculate_fps_parallel_FILE_OLD=$subtitles_recalculate_fps_parallel_FILE.before_recalculate.txt
  mv $subtitles_recalculate_fps_parallel_FILE $subtitles_recalculate_fps_parallel_FILE_OLD || return $?

  for subtitles_recalculate_fps_parallel_CUT in $(seq 1 $subtitles_recalculate_fps_parallel_LOGICAL_CORES_NUM)
  do
    subtitles_recalculate_fps_parallel_FILE_SPLITTED=$subtitles_recalculate_fps_parallel_FILE.$subtitles_recalculate_fps_parallel_CUT.txt
    cat $subtitles_recalculate_fps_parallel_FILE_SPLITTED >> $subtitles_recalculate_fps_parallel_FILE
    rm $subtitles_recalculate_fps_parallel_FILE_SPLITTED $subtitles_recalculate_fps_parallel_FILE_SPLITTED.before_recalculate.txt
  done
}
