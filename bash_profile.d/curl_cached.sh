function curl_cached() {
  local curl_cached_DIR="/tmp/.curl_cached"
  if [ ! -d $curl_cached_DIR/$1 ]; then
    mkdir -p $curl_cached_DIR/$1
  fi
  local curl_cached_CONTENT_FILE="$curl_cached_DIR/$1/curl_output"
  if [ ! -f $curl_cached_CONTENT_FILE ]; then
    curl $1 -o $curl_cached_CONTENT_FILE || rm -rf $curl_cached_DIR/$1
  fi
  cat $curl_cached_CONTENT_FILE
}
