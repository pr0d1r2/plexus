function gz_to_pxz() {
  local gz_to_pxz_GZ
  local gz_to_pxz_XZ
  for gz_to_pxz_GZ in $@
  do
    case `echo $gz_to_pxz_GZ | tr '[A-Z]' '[a-z]'` in
      *.gz)
        gz_to_pxz_XZ=`dirname $gz_to_pxz_GZ`/`dirname \`basename $gz_to_pxz_GZ | tr '.' '/'\` | tr '/' '.'`.xz
        echo "gzip -cd $gz_to_pxz_GZ | pxz -c9 > $gz_to_pxz_XZ"
        gzip -cd $gz_to_pxz_GZ | pxz -c9 > $gz_to_pxz_XZ
        ;;
    esac
  done
}
