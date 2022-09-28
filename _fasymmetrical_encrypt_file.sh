#
# Pre-requist functions : 
#     NO PRE-REQUIST BINARIES FOR THIS FUNCTION
#

# Pre-requist Binaries : 
#     NO PRE-REQUIST BINARIES FOR THIS FUNCTION
#

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function symmetrical encrypt file with pass on <KEY_FILE>
# Usage : symmetrical_encrypt_file <KEY_FILE> <INPUT_FILE>


function asymmetrical_encrypt_file()
{
  local _fname="_fsymmetrical_encrypt_file()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  local _publicKey=''           #$1
  local _input_file_name=''     #$2
           
  local _paramerters_number_expected="2"
  local _paramerters_number=$#
  declare -a _dependencies_binaries=('openssl'\
                                    )

  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - Start"

  #
  ## TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  if [ "$_paramerters_number" -ne $_paramerters_number_expected ]; then
  {
    _retcode=1
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] There is \"$_paramerters_number\" ($_paramerters_number_expected is expected)" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] exit ($_retcode)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End ($_retcode)"
    return $_retcode
  }
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
    _publicKey=$1
    _input_file_name=$2
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  ## TASK : Load and Check Parameters - END
  #


  #
  ## TASK : Checking _dependencies_binaries - START
  _task="Checking dependencies binaries"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"

  for _dependencie in ${!_dependencies_binaries[@]}
  do
    _binary=${_dependencies_binaries[_dependencie]}
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking : \"$_binary\""
    _retval=$(command -v $_binary 2>/dev/null)
    _retcode=$?
    if [ "$_retcode" -ne 0 ] ; then
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Checking : \"$_binary\" faild !"  >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Install or Re-install : \"$_binary\""  >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Value = $_retval" >&2)
      $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code ($_retcode)" >&2)
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End ($_retcode)"
      return $_retcode
    else
      echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking : \"$_binary\"...OK"  
    fi
  done
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  ## TASK : Checking _dependencies_binaries - END
  #


  #
  ## TASK : Symmetrically encrypts - START
  _task="Symmetrically encrypts File"
  _cmd="openssl pkeyutl -encrypt -pubin -inkey $_publicKey -in $_input_file_name -out $_input_file_name.crypt"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Encrypts file faild !" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Value = $_retval" >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code ($_retcode)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End ($_retcode)"
    return $_retcode
  else
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  fi
  ## TASK : compress_file <INPUT_FILE> <OUTPUT_FILE> - END
  #


  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - End"
  return 0
}
