#!/bin/sh

#############################################
#                                           #
#   SCRIPT EXTRACTING TRACKS USING FFmpeg   #
#                                           #
#############################################

#-------
# USAGE 
#-------
#   $ ./exttrack.sh source.ext [-a|v|t track] xxx
#  here "sss" and "xxx" are as above.
#  Default value: sss = 0:1
#

NAME=$1
CORE=${NAME%.*}

# Manipulate arguments
shift
while getopts avt: OPT
do
  case $OPT in
    "a") echo "Audio Extracting..."
         OPTION="-acodec copy"
         STREAM=`ffmpeg -i $NAME 2>&1 1>/dev/null | grep -G "Stream.*Audio:"`
         STR=`echo $STREAM | awk 'match($0, /Stream #[0-9]:[0-9]/) {print substr($0, RSTART, RLENGTH)}' `
         TRACK=${STR#*\#}
         ;;
    "v") echo "Video Extracting..."
         OPTION="-vcodec copy"
         STREAM=`ffmpeg -i $NAME 2>&1 1>/dev/null | grep -G "Stream.*Video:"`
         STR=`echo $STREAM | awk 'match($0, /Stream #[0-9]:[0-9]/) {print substr($0, RSTART, RLENGTH)}' `
         TRACK=${STR#*\#}
         ;;
    "t") echo "Extracting Track $2"
         OPTION=
         STREAM=`ffmpeg -i $NAME 2>&1 1>/dev/null | grep "Stream #$2"`
         TRACK=$2
         shift
         ;;
      *) echo "Usage: $CMDNAME [-a|v|t track] ext"
         exit 1
         ;;
  esac
done

EXT=$2

echo Input : $NAME
echo Track : $TRACK
echo Output : $CORE.$EXT
echo
echo FFmpeg information :
echo $STREAM
echo
echo Execute command :
echo "ffmpeg -i $NAME $OPTION -map $TRACK $CORE.$EXT"
#ffmpeg -i $NAME -acodec copy -map $TRACK $CORE.$EXT
ffmpeg -loglevel warning -i $NAME $OPTION -map $TRACK $CORE.$EXT
