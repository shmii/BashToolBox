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
_passphrase_file=''       #$1
_paramerters_number_expected="1"


#
#
# Script principal - MAIN()
_fname="main()"
cd "$SCRIPT_PATH"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - START in : $(pwd)"

#
# TASK : Load and Check Parameters - START
_task="Load and Check Parameters"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
_passphrase_file=$1
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
if [ "$SCRIPT_PARAMETERS_NUMBERS" -ne $_paramerters_number_expected ]; then
{
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalid." >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] There is \"$SCRIPT_PARAMETERS_NUMBERS\" ($_paramerters_number_expected is expected" >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] exit ($_retcode)" >&2)
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
## Générate passphrase
_task="Générate passphrase"
_cmd="openssl rand -out $_passphrase_file -base64 124"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Commande = \"$_cmd\""
_retval=$($_cmd 2>&1 )
_retcode=$?
if [ "$_retcode" -ne 0 ] ; then
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande faild !"  >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Commande = \"$_cmd\"" >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Value = $_retval" >&2)
  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] - Return Code ($_retcode)" >&2)
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End with errors ($_retcode)"
  exit "$_retcode"
else
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End"
fi
##
#


echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - End"
exit "$_retcode"
#  FIN du Script principal - MAIN()
#
#