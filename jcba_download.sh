#!/bin/bash

if [ $# -eq 3 ]; then
	channel=$1
	time=$2
	DUMP_FILE=$3

else
	echo "usage : $0 channel_name time outputfile"
	exit 1
fi

HOME_PATH=/home/ubuntu/JCBA-man
PROG_PATH=$HOME_PATH/
COMMON_PATH=$HOME_PATH/common
TEMP_PATH=$HOME_PATH/share/temp

. $COMMON_PATH/base.sh

FILE_NAME=`echo $DUMP_FILE | sed -e "s|$TEMP_PATH\/||g"`

isLive=`echo FILE_NAME | perl -ne 'print $1 if(/^(\w+)-(\d+)/i)'`
if [ "$time" = "live" ]; then
	time_param=""
	isLive="live"
	DUMP_FILE="-"
	DISP_MODE="/dev/null"
else
	time_param="-B $time"
	isLive="rec"
fi

STATION_NAME=`$COMMON_PATH/getRadioStation $channel local`
if [ $? -ne 0 ]; then
	MESSAGE="$FILENAME:$channel channel is not found."
	echo $MESSAGE
#	$HOME_PATH/twitter/post.sh "$FILENAME:$channel2 channel is not found."
	exit 1;
fi

SERVER="rtmp://musicbird.fc.llnwd.net/musicbird/$channel"

#
# rtmpdump
#
MESSAGE="$FILE_NAME:$channel $isLive do"
echo $MESSAGE 1>&2
#$HOMEPATH/twitter/post.sh "$FILE_NAME:$channel rec do"
rtmpdump -v -r "$SERVER" $time_param --timeout 5 --live --flv $DUMP_FILE 2> $DISP_MODE
RTMPDUMP_STATUS=$?

if [ "$isLive" = "live" ]; then
	RTMPDUMP_STATUS=$((RTMPDUMP_STATUS - 1))
fi

if [ $RTMPDUMP_STATUS -ne 0 ]; then
	MESSAGE="$FILE_NAME:$channel $isLive miss"
else
	MESSAGE="$FILE_NAME:$channel $isLive done"
fi

#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
echo $MESSAGE 1>&2
exit $RTMPDUMP_STATUS

