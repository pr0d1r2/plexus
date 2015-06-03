function youtube_rss_feed() {
  for youtube_rss_feed_PARAM in $@
  do
    youtube_rss_feed_CHANNEL=`basename $1`
    youtube_rss_feed_URL="http://gdata.youtube.com/feeds/api/users/$youtube_rss_feed_CHANNEL/uploads"
    echo $youtube_rss_feed_URL
    open -a Safari $youtube_rss_feed_URL
  done
}
