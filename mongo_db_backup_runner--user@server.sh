#!/bin/bash
LANG=C
WAIT_TIMER=1
SCRIPT_PID=${$}
SCRIPT_PATH=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`

SCRIPT_PARAMETERS_NUMBERS=$#

SCRIPT_START_DATE=$(date +"%Y-%m-%d-%H:%M")
SCRIPT_START_TIME=$(date +"%H:%M")

DATE=$(date +"%Y%m%d-%H%M")

cd $SCRIPT_PATH


DATABASE_HOST_NAME="<DATABASE_HOST_NAME>"
DATABASE_NAME="<DATABASE_NAME>"

TMP_WORKING_DIRECTORY="<TMP_WORKING_DIRECTORY>"
BACKUP_DIRECTORY="<BACKUP_DIRECTORY>"


$(./mongo_db_backup.sh \
        $DATABASE_HOST_NAME \
        $DATABASE_NAME \
        $TMP_WORKING_DIRECTORY \
        $BACKUP_DIRECTORY \
        >> "/var/log/scripts/$SCRIPT_NAME.log" \
        2>&1)

echo $? > /var/log/scripts/$SCRIPT_NAME.end


DATE=$(date +"%s")
echo $DATE > /var/log/scripts/$SCRIPT_NAME.run
exit 0
