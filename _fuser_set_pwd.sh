#! /bin/bash

# set_user_pwd  "PASSWORD" "USER"
function set_user_pwd()
{
  local _fname="set_user_pwd"
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

  #Set user password
  _task="Create users"
  _cmd="echo \"$_password\" | passwd --stdin $_user"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
  _retval=$(echo "$_password" | passwd --stdin $_user 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande = \"$_cmd\""
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Value = $_retval"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code = $(echo $_retcode)"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - End"
    return "$_retcode"
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done !"
  fi

  return 0
}
