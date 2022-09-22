#! /bin/bash


function upload_file_on_azure_blob()
{
  local _fname="upload_file_on_azure_blob()"
  local _paramerters_number=$#
  local _expectedParam="5"



  if [ "$_paramerters_number" -ne $_expectedParam ]; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expectedParam is expected)" >&2)
    exit 1
  }
  fi

  local _sourceFile=$1
  local _azAccountName=$2
  local _azAccountKey=$3
  local _azContainerName=$4
  local _azContainerFileName=$5
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  #
  # TASK : Upload file on Azure blob
  _task="Upload file on Azure blob"
  _cmd="az storage blob upload \
           --file $_sourceFile \
           --account-name $_azAccountName \
           --account-key $_azAccountKey \
           --container-name $_azContainerName \
           --name $_azContainerFileName"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code = $(echo $_retcode)" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Value = $(echo $_retval)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - exit($_retcode)"
    exit "$_retcode"
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  fi
  # TASK : Upload file on Azure blob - END
  #

  exit 0
}
