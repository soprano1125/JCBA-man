#/bin/sh


if [ $# -eq 2 ]; then
	channel=$1
	time=$2
	output=$1

elif [ $# -eq 3 ]; then
	channel=$1
	time=$2
	output=$3

else
	echo "usage : $0 channel_name rec_time [outputfile]"
	exit 1
fi

HOME_PATH=/home/ubuntu/JCBA-man
PROG_PATH=$HOME_PATH
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

OUT_DIR="$HOME_PATH/share/$channel"
OUT_FILE="$OUT_DIR/$FILENAME.mp3"
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $OUT_DIR $TEMP_PATH $PROG_PATH/log/
$PROG_PATH/jcba_download.sh $channel $time $TEMP_PATH/$FILENAME.mp3
if [ $? -ne 0 ]; then
	exit 1;
fi

sudo mv $TEMP_PATH/$FILENAME.mp3 $OUT_FILE
sudo chown -R $FILE_OWNER $OUT_DIR

exit 0

