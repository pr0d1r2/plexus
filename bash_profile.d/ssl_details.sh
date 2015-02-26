function ssl_details() {
  for ssl_details_HOST in $@
  do
    case $ssl_details_HOST in
      https://*)
        ssl_details_HOST=`echo $ssl_details_HOST | sed -e 's|https://||g'`
        ;;
    esac
    ssl_details_HOST=`echo $ssl_details_HOST | cut -f 1 -d /`
    case $ssl_details_HOST in
      *:[1-9]*)
        ;;
      *)
        ssl_details_HOST="$ssl_details_HOST:443"
        ;;
    esac
    openssl s_client -showcerts -connect $ssl_details_HOST <<<OK
  done
  unset ssl_details_HOST
}
