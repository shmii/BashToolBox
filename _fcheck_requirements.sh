#
# Source pre-requist functions
#
# There is no pre-requist functions

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function Check if requist binaries are installed
# Usage : check_requirements <BINARY1> <BINARY2> <...> <BINARYn>

check_requirements() {
  local _fname="check_requirements()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  local _paramerters_number=$#
  local __paramerters_number_expected="-1"


  local _binary_file

  #
  # TASK : Check binaries - START
  local _task="Check required binaries"
  for arg
  do
    _binary_file=$arg
    command -v $_binary_file >/dev/null 2>&1
    _retcode=$?
    if [ "$_retcode" -ne 0 ] ; then
      $(echo "$_fname - $_task - This script need \"$_binary_file\" !"  >&2)
      $(echo "$_fname - $_task - Install \"$_binary_file\" and restart the script!"  >&2)
      return "$_retcode"
    fi
  done
  # TASK : Check binaries - END
  #
  return 0
}
