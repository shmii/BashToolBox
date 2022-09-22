#
# Source pre-requist functions
#

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function execute une commande
# Usage : chmod_set <MODE> <FILE>


ftp_exec() {
  local _fname="ftp_exec()"
  local _task=""
  local _retval=""
  local _retcode=0
  local _ftp_output=""

  #
  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"

  local _paramerters_number=$#
  local _expected_paramerters_number="6"


  local _Ftp_Url="$1"
  local _Ftp_Port="$2"
  local _Ftp_User="$3"
  local _Ftp_Password="$4"
  local _Ftp_Directory=$5
  local _source_csv_list_commands="$6"

  if [ "$_paramerters_number" -ne $_expected_paramerters_number ]; then
  {
    $(echo "$_fname - $_task - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$_fname - $_task - [ERROR] There is \"$_paramerters_number\" parameter(s) ($_expected_paramerters_number is expected)" >&2)
    return 1
  }
  fi
  # TASK : Load and Check Parameters - END
  #


  #
  # TASK : execute ftp cmd - START
  _task="Execute ftp commandes"

  _retval=$(cat $_source_csv_list_commands |  lftp "${_Ftp_User}:${_Ftp_Password}@${_Ftp_Url}" >$_source_csv_list_commands"_out" 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    local _err_msg=$(cat $_source_csv_list_commands"_out" | head -n 1)
    $(echo "lftp : $_err_msg" >&2)
    return "$_retcode"
  fi
  # TASK : execute ftp cmd - START
  #

  #
  # TASK : check_ftp_error- START
  _task="Check_ftp_error"
  _retval=$(cat $_source_csv_list_commands"_out" | grep 'Access failed:' | wc -l)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] || [ "$_retval" -ne 0 ] ; then
    local _res=$(($_retcode+$_retval))
    local _err_msg=$(cat $_source_csv_list_commands"_out" | head -n 1)
    $(echo "lftp : $_err_msg" >&2)
    return "$_res"
  fi
  # TASK : check_ftp_error- END
  #
  
  return $_retcode
}
