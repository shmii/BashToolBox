#! /bin/bash
LANG=C
WAIT_TIMER=1
SCRIPT_PID=${$}
SCRIPT_PATH=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`
SCRIPT_PARAMETERS_NUMBERS=$#
SCRIPT_START_DATE=$(date +"%Y-%m-%d-%H:%M")
SCRIPT_START_TIME=$(date +"%H:%M")
DATE=$(date +"%Y%m%d-%H%M")

_retcode=0
_key_file=''              #$1
_input_file_name=''       #$2
_paramerters_number_expected="2"


declare -a DEPENDENCIES=('./_fsymmetrical_encrypt_file.sh'\
                        )

#
#
# Script principal - MAIN()
_fname="main()"
cd "$SCRIPT_PATH"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - Start in : $(pwd)"


#
# TASK : Loading dependencies - START
_task="Loading dependencies"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
for DEPENDENCIE in ${!DEPENDENCIES[@]}
do
  _dependencie="${DEPENDENCIES[$DEPENDENCIE]}"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading : $_dependencie "
  . $_dependencie 2>/dev/null
  _retcode=$?
  if [ "$_retcode" -ne 0 ] ; then
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Loading : \"$_dependencie\" faild !"  >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] exit ($_retcode)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
    exit "$_retcode"
  fi
done
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
# TASK : Loading dependencies - END
#

#
# TASK : Load and Check Parameters - START
_task="Load and Check Parameters"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
_key_file=$1
_input_file_name=$2
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
if [ "$SCRIPT_PARAMETERS_NUMBERS" -ne $_paramerters_number_expected ]; then
{
  _retcode=1
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalid." >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] There is \"$SCRIPT_PARAMETERS_NUMBERS\" ($_paramerters_number_expected is expected" >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] return ($_retcode)" >&2)
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - $USAGE"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Failed !"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - END"
  exit "$_retcode"
}
fi
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
# TASK : Load and Check Parameters - END
#

#
# TASK : _fsymmetrical_encrypt_file.sh - START
_task="Symmetrically encrypts File: $_input_file_name"
_cmd="symmetrical_encrypt_file $_key_file $_input_file_name"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
$_cmd 2>&1
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code = $(echo $_retcode)"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task"
  exit "$_retcode"
else
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
fi
# TASK : _fdump_database() - END
#

echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - End"
exit 0
#  FIN du Script principal - MAIN()
#
#
