#
# Source pre-requist functions
#
# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This functin dump a database
# Usage : database_dump <db_type> <db_name> <backup_output_file> <credential_file>
function database_dump()
{
  local _fname="database_dump()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  # TASK : Loading dependencies - START
  _task="Loading dependencies"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  for _include in '_fdatabase_mysql_dump.sh' '_fdatabase_postgresql_dump.sh'
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


  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
  local _paramerters_number=$#
  local _expected_paramerters_number="5"
  local _db_server_type=$1
  local _db_name=$2
  local _db_backup_output_file=$3
  local _db_dump_credential_file=$4
  local _db_dump_options=$5
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  if [ "$_paramerters_number" -ne $_expected_paramerters_number ]; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expected_paramerters_number is expected)" >&2)
    return 1
  }
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  # TASK : Load and Check Parameters - END

  #TASK : Dump MySql Database - START
  _task="Dump MySql Database"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  case $_db_server_type in
  	postgresql)
      _cmd="database_postgresql_dump \"$_db_name\" \"$_db_backup_output_file\" \"$_db_dump_credential_file\" \"$_db_dump_options\""
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
      database_postgresql_dump "$_db_name" "$_db_backup_output_file" "$_db_dump_credential_file" "$_db_dump_options"
      _retcode=$?
  		;;
  	mysql)
      _cmd="database_mysql_dump \"$_db_name\" \"$_db_backup_output_file\" \"$_db_dump_credential_file\" \"$_db_dump_options\""
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
      database_mysql_dump "$_db_name" "$_db_backup_output_file" "$_db_dump_credential_file" "$_db_dump_options"
      _retcode=$?
  		;;
  	*)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Wrong database type !" >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] The database type : $_db_type is not managed by this script" >&2)
      return 1
  		;;
  esac
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - return ($_retcode)" >&2)
    return "$_retcode"
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  #TASK : Dump MySql Database - START
  return 0
}
