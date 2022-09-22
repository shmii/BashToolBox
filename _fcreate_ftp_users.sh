#
# Source pre-requist functions
#
. ./_fcreate_user.sh
. ./_fmake_directory.sh
. ./_fchmod_set.sh
. ./_fchown_set.sh
. ./_fset_user_pwd.sh

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function create pre-requist for a <USER> of the server FTP service
# Usage : create_ftp_users <USER> <PASSWORD> <FULL USER NAME>

function create_ftp_users()
{
  local _fname="create_ftp_users()"
  local _paramerters_number=$#
  local _expectedParam="3"

  local _user="$1"
  local _password="$2"
  local _full_name="$3"

  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  if [ "$_paramerters_number" -ne $_expectedParam ]; then
  {
    echo -e "$(date) - $_task - [ERROR] Number of parameters is invalide."
    echo -e "$(date) - $_task - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expectedParam is expected)"
    exit 1
  }
  fi

  make_directory "/sftp/$_user/home"
  create_user "$_user" "$_password" "$_full_name"
  set_user_pwd "$_user" "$_password"
  chmod_set "755" "/sftp/$_user"
  chmod_set "755" "/sftp/$_user/home"
  chown_set "root" "root" "/sftp/$_user/home"

  return 0
}
