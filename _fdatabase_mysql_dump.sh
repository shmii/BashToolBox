#
# Source pre-requist functions
#
# There is no pre-requist functions

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This functin dump a mysql database
# Usage : database_mysql_dump <db_name> <mysqldump_result_file> <credential_file> <mysqldump_options>
function database_mysql_dump()
{
  local _fname="database_mysql_dump()"
  local _paramerters_number=$#
  local _expectedParam="4"

  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0


  #
  # TASK : START - Load and Check Parameters
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
  local _db_name="$1"
  local _mysqldump_result_file="$2"
  local _credential_file="$3"
  local _mysqldump_options="$4"

  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  if [ "$_expectedParam" -ne $_paramerters_number ]; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expected_paramerters_number is expected)" >&2)
    exit 1
  }
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  # TASK : END - Load and Check Parameters
  #


  #Dump MySql Database
  _task="Dump MySql Database"
  _cmd="mysqldump --defaults-extra-file=$_credential_file $_mysqldump_options --databases $_db_name --result-file=$_db_backup_output_file --log-error=$_db_backup_output_file.errors"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1 )
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande = \"$_cmd\""
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - return ($_retcode)"
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"  >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - $_retval" >&2)
    return "$_retcode"
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  fi

  return 0
}
