#! /bin/bash
LANG=C
WAIT_TIMER=1
SCRIPT_PID=${$}
SCRIPT_PATH=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`
SCRIPT_PARAMETERS_NUMBERS=$#
SCRIPT_START_DATE=$(date +"%Y-%m-%d-%H:%M")
SCRIPT_START_TIME=$(date +"%H:%M")
DATE=$(date +"%Y%m%d-%H%M")

USAGE="\$ $SCRIPT_NAME  <DATABASE_TYPE> <DATABASE_NAME> <CREDENTIAL_FILE> <OUTPUT_PATH> <OUTPUT_FILE> <OPTIONS>"
: '
/*
** USAGE : \$ $SCRIPT_NAME  <DATABASE_TYPE> <DATABASE_NAME> <CREDENTIAL_FILE> <OUTPUT_PATH> <OUTPUT_FILE> <OPTIONS>
*/'

: '
/*
**  <DATABASE_TYPE> Set the Suported type of databases it s must be one of this :
**                 - postgresql
**                 - mysql
*/
'

: '
/*
**  The <CREDENTIAL_FILE> file must existe
**  The <CREDENTIAL_FILE> file must containe credential informations
**  The <CREDENTIAL_FILE> file must have chmod 400 right
*/

/*
**  <CREDENTIAL_FILE> example For MySQL databases
*/

[mysqldump]
host = your_MySQL_server_name_or_IP
port = your_MySQL_server_port
user = database_user_name
password = database_password
'

_retcode=0
_db_type=''                     #$1
_db_name=''                     #$2
_db_dump_credential_file=''     #$3
_db_dump_output_path=''         #$4
_db_dump_output_file=''         #$5
_db_dump_options=''             #$6
_paramerters_number_expected="6"

cd "$SCRIPT_PATH"


#
#
# Script principal - MAIN()
_fname="main()"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - START in ($SCRIPT_PATH)"


#
# TASK : Loading dependencies - START
_task="Loading dependencies"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
for _include in './_fdatabase_dump.sh' './_ftar_gz_file.sh'
do
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading : \"$_include\""
  . $_include 2>/dev/null
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Loading : \"$_include\" faild !"  >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - exit ($_retcode)" >&2)
    exit "$_retcode"
  fi
done
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
# TASK : Loading dependencies - END
#


#
# TASK : Load and Check Parameters - START
_task="Load and Check Parameters"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
_db_type=$1
_db_name=$2
_db_dump_credential_file=$3
_db_dump_output_path=$4
_db_dump_output_file=$5
_db_dump_options=$6
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
# TASK : _fdump_database() - START
_task="_fdatabase_dump()"
_cmd="database_dump \"$_db_type\" \"$_db_name\" \"$_db_dump_output_path$_db_dump_output_file\" \"$_db_dump_credential_file\" \"$_dump_options\""
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
database_dump "$_db_type" "$_db_name" "$_db_dump_output_path$_db_dump_output_file" "$_db_dump_credential_file" "$_dump_options"
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code = $(echo $_retcode)"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
  exit "$_retcode"
else
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
fi
# TASK : _fdump_database() - END
#


#
# TASK : _tar_gz_file() - START
_task="_tar_gz_file()"
_cmd="tar_gz_file \"$_db_dump_output_path\" \"$_db_dump_output_file\" \"--remove-files\""
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
tar_gz_file "$_db_dump_output_path" "$_db_dump_output_file" "--remove-files"
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code = $(echo $_retcode)"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
  exit "$_retcode"
else
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
# TASK : _tar_gz_file() - END
#


exit 0
#  FIN du Script principal - MAIN()
#
#
