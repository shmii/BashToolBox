#! /bin/bash

function send_mail()
{
  local _fname="send_mail()"
  local _paramerters_number=$#
  local _expectedParam="3"
  local _mail_subject=$1
  local _mail_contente=$2
  local _file=$3

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


  #Sending file
  _task="Sending file"
  _cmd="echo \"$_mail_contente\" | mailx -s \"$_mail_subject\" -a $_file thomas@chalmel.org"
  echo "$(date) - $_task - Start"
  echo "$(date) - $_task - Commande = \"$_cmd\""
  _retval=$(echo "$_mail_contente" | mailx -s "$_mail_subject" -a $_file thomas@chalmel.org 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - $_task - Commande = \"$_cmd\""
    echo "$(date) - $_task - Return Value = $_retval"
    echo "$(date) - $_task - Return Code = $(echo $_retcode)"
    echo "$(date) - $_task - End"
    exit "$_retcode"
  else
    echo "$(date) - $_task - Done !"
  fi

  return 0
}
