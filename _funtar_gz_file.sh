#! /bin/bash

# This functin appy the MODE parameters to the FILE in parameters
# Usage : tar_gz_file <input_file_to_tar> <output_file-tared>
function untar_gz_file()
{
  local _fname="tar_gz_file()"
  local _paramerters_number=$#
  local _expectedParam="3"

  local _file=$1
  local _file_tar_gz=$2

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

  #Tar a file
  _task="Tar File"
  _cmd="tar cvzf $_file_tar_gz $_file $_tar_options"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
  _retval=$(tar cvzf "$_file_tar_gz" "$_file" "$_tar_options" 2>&1 )
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
