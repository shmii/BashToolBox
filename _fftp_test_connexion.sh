#
# Source pre-requist functions
#    - _fftp_exec()

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function test the connexion on a FTP
# Usage : chmod_set <MODE> <FILE>


ftp_test_connect()
{
  local _fname="ftp_test_connect()"
  local _task=""
  local _retval=""
  local _retcode=0

  #
  # TASK : Loading dependencies - START
  _task="Load dependencies"
  local required_dependencies=('_fftp_exec.sh')
  for _include in ${required_dependencies[*]}
  do
    . $_include 2>/dev/null
    _retcode=$?
    if [ "$_retcode" -ne 0 ] ; then
      $(echo "Loading : \"$_include\" faild !"  >&2)
      return "$_retcode"
    fi
  done

  # TASK : Loading dependencies - END
  #

  #
  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"

  local _paramerters_number=$#
  local _expected_paramerters_number="6"

  local _Ftp_Url=$1
  local _Ftp_Port=$2
  local _Ftp_User=$3
  local _Ftp_Password=$4
  local _Ftp_Directory=$5
  local _Ftp_Order_File=$6

  if [ "$_paramerters_number" -ne $_expected_paramerters_number ]; then
  {
    $(echo "$_fname - $_task -  [ERROR] Number of parameters is invalide." >&2)
    $(echo "$_fname - $_task -  [ERROR] There is \"$_paramerters_number\" parameter(s) ($_expected_paramerters_number is expected)" >&2)
    return 1
  }
  fi
  # TASK : Load and Check Parameters - END
  #



  echo "cd $_Ftp_Directory" > $_Ftp_Order_File
  echo "ls -l" >> $_Ftp_Order_File
  echo "bye" >> $_Ftp_Order_File


  #
  # TASK : Check connexion - START
  local _task="Check connexion"

  _cmd="ftp_exec  $_Ftp_Url $_Ftp_Port $_Ftp_User $_Ftp_Password $_Ftp_Directory $_Ftp_Order_File"
  _retval=$($_cmd 2>&1)
  _retcode=$?

  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$_retval"  >&2)
    return "$_retcode"
  fi

  return 0
}
