#!/bin/sh

#
# Convert all images in the current directly to certain sizes and formats before zipping.
# The size will be changed only when the image is larger.
#
# Usage:
#   $ compress-imgs.sh [-n name] [-s size] [-d density] [-q quality] [-f format]

# Current directly
CURDIR=`pwd`
IMGS=`ls -1 $CURDIR | grep -G "\.\(jpg\|jpeg\|JPG\|JPEG\|png\|PNG\|bmp\|BMP\)$"`

# Default values
NAME=${CURDIR##*/} # current folder name
SIZE="x1200"
DENSITY=300x300
UNITS="PixelsPerInch"
QUALITY=85
FORMAT="jpg"
OTHEROPT="-unsharp 2x1.4+0.5+0"

# Manipulate options
while getopts "n:s:d:q:f:u" OPT
do
  case $OPT in
	"n") NAME=$OPTARG ;;
    "s") SIZE=$OPTARG ;;
	"d") DENSITY=$OPTARG ;;
	"q") QUALITY=$OPTARG ;;
    "f") FORMAT=$OPTARG ;;
    "u") echo Usage:
         echo "$0 [-n name] [-s size] [-d density] [-q quality] [-f format]"
         ;;
      *) echo "Invalid options"
         exit 1
         ;;
  esac
done

# Making folder
if [ -d $NAME ]; then
  echo "Folder $NAME already exists"
  echo "Overwrite ? [y/N]"
  read ANS
  case `echo $ANS | tr n N` in
    ""|N+ ) exit 1 ;;
  esac
else
  echo "Making a folder $NAME"
  mkdir "$NAME"
fi

echo "Start convertion"
echo "scale: $SIZE"
echo "density: $DENSITY"
echo "quality: $QUALITY"
echo "format: $FORMAT"
echo "target: $NAME"
echo "-----"

# Compress image files
for FILE in $IMGS
do
  TARGET="${FILE%.*}.$FORMAT"
  echo "Converting $FILE => $NAME/$TARGET"
  convert $FILE -scale $SIZE\> -density $DENSITY -units $UNITS -quality $QUALITY $OTHEROPT -verbose "$NAME/$TARGET"
done

# Zipping
zip -r "$NAME.zip" "$NAME"
