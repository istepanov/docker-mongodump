#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"

arr=("--quiet" "-h" "$MONGO_PORT_27017_TCP_ADDR" "-p" "$MONGO_PORT_27017_TCP_PORT")
if [ ! -z $MONGO_DB_NAME ]; then
	arr+=("-d")
	arr+=("$MONGO_DB_NAME")
fi
mongodump "${arr[@]}"
tar -zcvf $FILE dump/
rm -rf dump/
echo "Job finished: $(date)"
echo "Start autoclean"
FILES=/backup/*.tar.gz
currtime=`date +%s`
for f in $FILES
do
	if [ -f $f ];
	then
		filemtime=`stat -c %Y $f`
		diff=$(( (currtime - filemtime)/86400))
		if (($diff > $MONGO_BACKUP_EXPIRE_DAYS));
		then
			echo "deleting '$f' ..."
			rm $f
			echo "deleted."
		fi
	fi
done
echo "End autoclean"
