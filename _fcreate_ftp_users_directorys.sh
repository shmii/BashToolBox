#
# Source pre-requist functions
#
. ./_fchown_set.sh

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function create Skells directorys for the FTP service for a <USER>
# Usage : copy_ftp_users_directory <USER> <PASSWORD>
function create_ftp_users_directorys()
{
  local _fname="create_ftp_users_directorys()"
  local _paramerters_number=$#
  local _expectedParam="2"

  local _user=$1
  local _password=$2

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

  mkdir -p "/sftp/$_user/home/IN"
  mkdir -p "/sftp/$_user/home/OUT"
  chown_set "root" "root" "/sftp/$_user/home"
  chown_set "$_user" "sftpusers" "/sftp/$_user/home/*"
  return 0
}
