#!/bin/bash
LANG=C


SCRIPT_PID=${$}
SCRIPT_NAME=$0
SCRIPT_PARAMETERS_NUMBERS=$#
SCRIPT_PATH=$(dirname $0)

SCRIPT_START_DATE=$(date +"%Y-%m-%d-%H:%M")
SCRIPT_START_TIME=$(date +"%H:%M")



USAGE="$0 <DATABASE_HOSTNAME> <DATABASE_NAME> <TEMP_WORKING_DIRECTORY> <DUMP_DIRECTORY>"

#
#
# Script principal - MAIN()
_fname="main()"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - START in ($SCRIPT_PATH)"
cd "$SCRIPT_PATH"

#
# TASK : Load and Check Parameters - START
_task="Load and Check Parameters"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
_paramerters_number_expected="4"
_db_host="$1"
_db_name="$2"
_script_tmp_directory="$3"
_db_dump_directory="$4"
_db_dump_date=$(date +"%Y-%m-%d")
_dump_tmp_directory="$_script_tmp_directory/$_db_name-backup-$_db_dump_date"
_dump_archive_name="$_db_name-backup-$_db_dump_date.tgz"

echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
if [ "$SCRIPT_PARAMETERS_NUMBERS" -ne $_paramerters_number_expected ]; then
{
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalid." >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] There is \"$SCRIPT_PARAMETERS_NUMBERS\" ($_paramerters_number_expected is expected" >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] exit ($_retcode)" >&2)
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - $USAGE"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
  exit "$_retcode"
}
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Load and Check Parameters - END
#




#
# TASK : Create dump tmp directory - START
_task="Create dump tmp directory"
_cmd="mkdir -p $_dump_tmp_directory"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task Commande = \"$_cmd\""
if [ -d $_dump_tmp_directory ]; then
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Directory \"$_dump_tmp_directory\" already exist !"
else
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    {
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Commande = \"$_cmd\"" >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Value = $_retval" >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Code = $(echo $_retcode)" >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - End" >&2)
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
      exit "$_retcode"
    }
  fi
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Create dump tmp directory - END
#


#
# TASK : Dump Mongo Database - START
_task="Dump Mongo Database"
_cmd="mongodump  --host=$_db_host --port=27017  --db=$_db_name --gzip --out=$_dump_tmp_directory"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task Commande = \"$_cmd\""
_retval=$($_cmd 2>&1)
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Commande = \"$_cmd\"" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Value = $_retval" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Code = $(echo $_retcode)" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - End" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
    exit "$_retcode"
  }
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Dump Mongo Database - END
#


#
# TASK : Tar Database Dump - START
_task="Tar Database Dump"
_cmd="tar -czf "$_db_dump_directory/$_dump_archive_name"  $_dump_tmp_directory/$_db_name"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task Commande = \"$_cmd\""
_retval=$($_cmd 2>&1)
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Commande = \"$_cmd\"" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Value = $_retval" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Code = $(echo $_retcode)" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - End" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
    exit "$_retcode"
  }
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Tar Database Dump - END
#

#
# TASK : Remove tmp working directory - START
_task="Remove tmp working directory"
_cmd="rm -rf $_dump_tmp_directory"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task Commande = \"$_cmd\""
_retval=$($_cmd 2>&1)
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Commande = \"$_cmd\"" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Value = $_retval" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - Return Code = $(echo $_retcode)" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task [ERROR] - End" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
    exit "$_retcode"
  }
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Remove tmp working directory - END
#


echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - END"
# Script principal - MAIN()
#
#
exit 0
