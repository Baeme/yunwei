#!/bin/bash

#@ baemawu@gmail.com
sleep 40
LOGDIR=/data/logs/nginx
Year=`date +%Y`
Month=`date +%m`
Day=`date +%d`
BACKUPDIR="${LOGDIR}/${Year}/${Month}/${Day}"
mkdir -p "${BACKUPDIR}"

if cd "${LOGDIR}";then

for file in `ls *.log`
    do
        prefix=`echo "$file" |cut -d. -f1`
        mv ${file} "${BACKUPDIR}/${prefix}_${Year}${Month}${Day}.log"
    done

fi

find /data/logs/nginx/* -type f -mtime +60 -exec rm -f  {} \;

/usr/local/nginx/sbin/nginx -t && /usr/local/nginx/sbin/nginx -s reload


cd "${BACKUPDIR}"
for file in `ls *.log`
    do
        gzip ${file}
    done
