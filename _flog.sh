function log()
{
  local _fname="log()"
  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0


  local _paramerters_number=$#
  local _paramerters_number_expected="4"

  # TASK : Load and Check Parameters - START
  _task="Load and Check Parameters"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Start"
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Loading ..."
  local _log_level=$1
  local _log_msg=$2
  local _log_type=$3
  local _log_file=$4
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Checking ..."
  if [ "$_paramerters_number" -ne $_paramerters_number_expected ]; then
  {
    $_retcode=1
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_paramerters_number_expected is expected)" >&2)
    echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - End (1)"
    return 1
  }
  fi
  echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - $_task - Done"
  # TASK : Load and Check Parameters - END

  case $_line in
    journald)
      journal_log($_log_level, $_log_msg)
      ;;
    stdout)
      stdout_log($_log_level, $_log_msg)
      ;;
    file)
      file_log($_log_level, $_log_msg, $_log_file)
      ;;
  esac
  return $_retcode
}
