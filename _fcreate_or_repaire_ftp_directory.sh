#
# Source pre-requist functions
#


# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function create or check directory for a <USER> of the SERVER FTP service
# Usage : create_or_repaire_ftp_directory <USER>



create_or_repaire_ftp_directory() {
  local _fname="create_or_repaire_ftp_directory()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0
  local _expected_paramerters_number="1"

  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  local _paramerters_number=$#
  if [ "$_paramerters_number" -ne $_expected_paramerters_number ]; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expected_paramerters_number is expected)" >&2)
    exit 1
  }
fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading parameters ..."
  local ftp_account=$1
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Paramerters 1 : ftp_account = $ftp_account"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  # TASK : Load and Check Parameters - END

 _task="Create FTP directories"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  mkdir -p "/sftp/$ftp_account/home/.ssh"
  mkdir -p "/sftp/$ftp_account/home/IN"
  mkdir -p "/sftp/$ftp_account/home/OUT"
  touch "/sftp/$ftp_account/home/.ssh/authorized_keys"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  _task="Apply mode"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  chmod 755 "/sftp/$ftp_account"
  chmod 755 "/sftp/$ftp_account/home"
  chmod 700 "/sftp/$ftp_account/home/.ssh"
  chmod 600 "/sftp/$ftp_account/home/.ssh/authorized_keys"
  chmod 700 "/sftp/$ftp_account/home/IN"
  chmod 700 "/sftp/$ftp_account/home/OUT"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  _task="Remove existing SeLinux Context configuration"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  sudo semanage fcontext -d "/sftp/$ftp_account"
  sudo semanage fcontext -d "/sftp/$ftp_account/home"
  sudo semanage fcontext -d "/sftp/$ftp_account/home/.ssh"
  sudo semanage fcontext -d "/sftp/$ftp_account/home/.ssh(/.*)?"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  _task="Apply unconfined_u:object_r:default_t:s0 SeLinux Context"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  sudo chcon unconfined_u:object_r:default_t:s0 "/sftp/$ftp_account"
  sudo chcon unconfined_u:object_r:default_t:s0 "/sftp/$ftp_account/home"
  sudo chcon unconfined_u:object_r:default_t:s0 "/sftp/$ftp_account/home/.ssh"
  sudo chcon unconfined_u:object_r:default_t:s0 "/sftp/$ftp_account/home/.ssh(/.*)?"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  _task="Add \"ssh_home_t\" SeLinux Context configuration for ssh directory"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  sudo semanage fcontext -a -t ssh_home_t "/sftp/$ftp_account/home/.ssh(/.*)?"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  _task="Apply SeLinux Context on user directory"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  sudo restorecon -R -v "/sftp/$ftp_account/home"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"

  return 0
}
