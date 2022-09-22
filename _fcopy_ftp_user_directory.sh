#
# Source pre-requist functions
#
# There is no pre-requist functions

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function copy via SSH (SCP) a directory from a home of a user
# to the the new FTP home
# Usage : copy_ftp_user_directory <USER> <PASSWORD>
function copy_ftp_user_directory()
{
  local _fname="copy_ftp_user_directory()"
  local _paramerters_number=$#
  local _expectedParam="3"

  local _user=$1
  local _password=$2
  local _directory=$3

  local _server="172.16.129.130"
  local _ftp_directory="/sftp"

  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  if [ "$_paramerters_number" -ne $_expectedParam ]; then
  {
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide."
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expectedParam is expected)"
    exit 1
  }
  fi

  #Copy User directory
  _task="Copy User directory:$_directory for User:$_user"
  _cmd="sshpass -p "$_password" scp -Cpr $_user@$_server:$_directory /sftp/$_user/home/"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Commande = \"$_cmd\""
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Return Value = $_retval"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Return Code = $(echo $_retcode)"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - End"
    #exit "$_retcode"
    return $_retcode
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Done !"
    return $_retcode
  fi
  return 0
}
