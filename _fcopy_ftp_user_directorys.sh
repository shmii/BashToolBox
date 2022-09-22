#
# Source pre-requist functions
#
. ./_fcopy_ftp_user_directory.sh
. ./_fchown_set.sh

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function copy via SSH (SCP) defined user directories
# "~/IN" and "~/OUT" to the the new FTP home
# Usage : copy_ftp_user_directory <USER> <PASSWORD>
function copy_ftp_user_directorys()
{
  local _fname="copy_ftp_user_directorys()"
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

  copy_ftp_user_directory "$_user" "$_password" "~/IN"
  copy_ftp_user_directory "$_user" "$_password" "~/OUT"
  chown_set "root" "root" "/sftp/$_user/home"
  chown_set "$_user" "sftpusers" "/sftp/$_user/home/*"

  return 0
}
