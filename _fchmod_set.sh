#
# Source pre-requist functions
#
# There is no pre-requist functions

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function appy the <MODE> to the <FILE>
# Usage : chmod_set <MODE> <FILE>

function chmod_set() {
  local _fname="chmod_set()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0


  local _paramerters_number=$#
  local _paramerters_number_expected=2

  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
  local _mode=$1
  local _file=$2
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  if [ "$_paramerters_number" -ne $_paramerters_number_expected ]; then
  {
    _retcode=1
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_paramerters_number_expected is expected)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End ($_retcode)"
    return "$_retcode"
  }
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  # TASK : Load and Check Parameters - END



  #run the "chmod" commande to apply <MODE> to the <FILE>
  _task="chmod _mode:$_mode _file:$_file"
  _cmd="chmod $_mode $_file"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Commande = \"$_cmd\""
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Return Value = $_retval"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - Return Code = $(echo $_retcode)"
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() [ERROR] - End"
    return "$_retcode"
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Done !"
  fi

  return 0
}
