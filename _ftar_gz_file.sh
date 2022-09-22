#! /bin/bash

# This functin appy the MODE parameters to the FILE in parameters
# Usage : tar_gz_file <output_path> <file-to_tar>
function tar_gz_file()
{
  local _fname="tar_gz_file()"
  local _paramerters_number=$#
  local _expectedParam="3"



  local _output_path=$1
  local _file=$2
  local _tar_option=$3

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
  _cmd="cd $_output_path ; tar cvzf $_file.tar.gz $_file $_tar_option"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""

  _retval=$(cd $_output_path ; tar cvzf "$_file.tar.gz" "$_file" "$_tar_option" 2>&1 )
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande = \"$_cmd\""
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - return ($_retcode)"
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"  >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - $(echo -e $_retval)" >&2)
    return "$_retcode"
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  fi

  return 0
}
