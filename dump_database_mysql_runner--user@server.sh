#!/bin/bash

LANG=C
WAIT_TIMER=1
SCRIPT_PID=${$}
SCRIPT_PATH=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`

SCRIPT_PARAMETERS_NUMBERS=$#

SCRIPT_START_DATE=$(date +"%Y-%m-%d-%H:%M")
SCRIPT_START_TIME=$(date +"%H:%M")

LOG_PATH="/var/log/scripts"
DATE=$(date +"%Y%m%d-%H%M")

cd $SCRIPT_PATH


: '
/*
**  Liste des options de mysqldump
*/

_dump_options=""
_dump_options="$_dump_options --ignore-table=mydb.Facturation_PASSIF"           #Do not dump given table
_dump_options="$_dump_options --routines"                                       #Dump stored routines (procedures and functions) from dumped databases
_dump_options="$_dump_options --events"
_dump_options="$_dump_options --skip-lock-tables"
_dump_options="$_dump_options --single-transaction"
_dump_options="$_dump_options --master-data=2"
'
_dump_options=""
_dump_options="$_dump_options --routines"
_dump_options="$_dump_options --events"

# _dump_options="$_dump_options --opt"                                            #Identique à --quick --add-drop-table --add-locks --extended-insert --lock-tables
# _dump_options="$_dump_options --lock-tables"
# _dump_options="$_dump_options --add-locks"
_dump_options="$_dump_options --quick"
_dump_options="$_dump_options --ignore-table=tm.logxxx"
# _dump_options="$_dump_options --extended-insert"

#_dump_options="$_dump_options --single-transaction"                            #--single-transaction a été ajoutée en version 4.0.2.
                                                                                # Cette option est mutuellement exclusive avec l'option --lock-tables
                                                                                # car LOCK TABLES va valider une transaction interne précédente.

#_dump_options="$_dump_options --master-data=2"                                 # Causes the binary log position and filename to be appended to the output,
                                                                                # useful for dumping a master replication server to produce a dump file that
                                                                                # can be used to set up another server as a slave of the master.développer
                                                                                # If the option is :
                                                                                #     set to 1 (the default)
                                                                                #     set to 2, that command will be prefixed with a comment symbol.
                                                                                #        This --master-data option will turn --lock-all-tables on,
                                                                                #        unless --single-transaction is specified too.
                                                                                #        Before MariaDB 5.3 this would take a global read lock for a
                                                                                # In all cases, any action on logs will happen at the exact moment of the dump.
                                                                                # This option automatically turns --lock-tables off.
                                                                                #

DATABASE_TYPE="<DATABASE_TYPE>"        #mysql, pgsql, mongodb
DATABASE_NAME="<DATABASE_NAME>"
CREDENTIAL_FILE="~/.credentials/user@hostname.cred"
TMP_WORKING_DIRECTORY="<TMP_WORKING_DIRECTORY>"
BACKUP_DIRECTORY="<BACKUP_DIRECTORY>"
DUMP_FILE_NAME="$DATABASE_NAME-$DATE.dump"

$(./dump_database.sh \
          "$DATABASE_TYPE"\
          "$DATABASE_NAME"\
          "$CREDENTIAL_FILE"\
          "$TMP_WORKING_DIRECTORY"\
          "$DUMP_FILE_NAME"\
          "$_dump_options"\
          >> "$LOG_PATH/$SCRIPT_NAME.log" \
          2>&1)
echo $? > "$LOG_PATH/$SCRIPT_NAME.end"

DATE=$(date +"%s")
echo $DATE > "$LOG_PATH/$SCRIPT_NAME.run"
exit 0
