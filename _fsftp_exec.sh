#
# Source pre-requist functions
#

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This function execute une commande
# Usage : chmod_set <MODE> <FILE>


sftp_exec() {
  local server=$1
  local user=$2
  local password=$3
  local port=$4
  local command_File=$5
  local output_File=$6

  export SSHPASS=$password
  sshpass -e sftp -oBatchMode=no -b $command_File -P $port "${user}@${server}" 2>&1
  return $?
}
