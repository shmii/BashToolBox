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

# This function compress file with a specific algorythme
# Usage : compress_file <INPUT_FILE> <OUTPUT_FILE> <COMPRESSION_METHODE> <COMPRESSION_LEVEL>


function compress_file()
{
  local _fname="_fcompress_file()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  local _input_file_name=''       #$1
  local _output_file_name=''      #$2
  local _compression_methode=''   #$3   (7z, bzip2, gzip, zipx xz, tar)
  declare -rA _compression_methodes=(['zip']='zip'\
                                     ['gzip']='gz'\
                                     ['bzip2']='bz2'\
                                     ['7z']='7z'\
                                     ['xz']='xz'\
                                     )

  local _compression_level=''     #$4   Sets level of compression. (1,3,5,7,9)
                                        #x=0 means Copy mode (no compression).
                                        #from x=1 Fastest to x=9 Ultra                         
  local _paramerters_number_expected="4"
  local _paramerters_number=$#
  declare -a _dependencies_binaries=('7z'\
                                    )
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
    _input_file_name=$1
    _output_file_name=$2
    _compression_methode=$3
    _compression_level=$4
    _compression_extention=${_compression_methodes[$_compression_methode]}
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  ## TASK : Load and Check Parameters - END
  #


  #
  ## TASK : Checking _dependencies_binaries - START
  _task="Checking _dependencies_binaries"
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
  ## TASK : compress_file <INPUT_FILE> <OUTPUT_FILE> - START
  _task="Compressing file"
  _cmd="7z a $_output_file_name.$_compression_extention $_input_file_name -t$_compression_methode -mx$_compression_level -mmt16"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() _output_file : $_output_file_name"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() _compression_methode : $_compression_methode"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() _compression_extention : $_compression_extention"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task() Commande = \"$_cmd\""
  _retval=$($_cmd 2>&1)
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Compressing file faild !" >&2)
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
