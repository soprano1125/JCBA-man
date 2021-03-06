#/bin/sh


if [ $# -eq 1 ]; then
	channel=$1

else
	echo "usage : $0 channel_name"
	exit 1
fi

HOME_PATH=/home/ubuntu/JCBA-man
PROG_PATH=$HOME_PATH
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

AUTHOR="JCBA"
STATION_NAME=`$COMMON_PATH/getRadioStation $channel`

#
# rtmpdump
#
$PROG_PATH/jcba_download.sh $channel live live-$REC_DATE | vlc --meta-title " " --meta-author "$AUTHOR" --meta-artist "$STATION_NAME" --meta-date $REC_DATE --play-and-exit --no-one-instance --no-sout-display-video - 2> /dev/null 
exit 0

