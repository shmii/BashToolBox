#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
LANG=C

#######################################
# Globals
#######################################
WAIT_TIMER=1

SCRIPT_PID=$$
SCRIPT_NAME="$(basename "$0")"
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_START_DATE="$(date +"%Y-%m-%d")"
SCRIPT_START_TIME="$(date +"%H:%M %Z")"
SCRIPT_DATE="$(date +"%Y%m%d_%H%M")"

SCRIPT_PARAMETERS_NUMBERS=$#
SCRIPT_PARAMETERS_NUMBERS_EXPECTED="0"

#######################################
# Logging & helpers
#######################################

# Fonction log universelle

COLOR_RESET="\e[0m"
COLOR_RED="\e[31m"
COLOR_YELLOW="\e[33m"
COLOR_GREEN="\e[32m"
COLOR_CYAN="\e[36m"

log() {
    local level="${1,,}"  # La valeur level doit etre agnostique de la casse usage de ,, pour tout mettre en minuscule
    shift
    local message="$*"
    local color=""

    # Choix de la couleur selon le niveau
    case "$level" in
        info)    color="$COLOR_CYAN" ;;
        warn)    color="$COLOR_YELLOW" ;;
        error)   color="$COLOR_RED" ;;
        success) color="$COLOR_GREEN" ;;
        debug)   color="$COLOR_RESET" ;; # Pas de couleur spéciale pour debug
        *)       color="$COLOR_RESET"; level="info" ;;  # défaut
    esac

    local level_upper="${level^^}"
    # Affichage à l'écran
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] ["$SCRIPT_NAME\($SCRIPT_PID\)"] [$level_upper] $message${COLOR_RESET}"

    # Si logger existe, on envoie dans journalctl
    if command -v logger >/dev/null 2>&1; then
        logger -t "$SCRIPT_NAME" "($SCRIPT_PID) [$(echo "$level_upper")] $message"
    fi
}


die() {
  log error "$*"
  exit 1
}

run() {

    local cmd
    printf -v cmd '%q ' "$@"

    log info "RUN: $cmd"

    set +e  # désactive temporairement -e
    local _retval
    _retval=$("$@" 2>&1)
    local _retcode=$?
    set -e  # réactive -e

    if [ $_retcode -ne 0 ]; then
        log error "Command : $cmd"
        log error "Command failed with exit code : $_retcode"
        log error "Command failed with exit message : $_retval"
    fi

    return 0 # return success regardless of command outcome to continue script on main flow deaspite pifalls configurations.
}

log info "#####################################################################"
log info "#  This script was created by Thomas CHALMEL - thomas@chalmel.org   #"
log info "#####################################################################"


#######################################
# Main
#######################################
log info "START : $SCRIPT_NAME ($SCRIPT_PID)"
log info "START in : ($SCRIPT_PATH)"
log info "START with ($SCRIPT_PARAMETERS_NUMBERS) parameters"
log info "START on ($SCRIPT_START_DATE) at ($SCRIPT_START_TIME)"



log info "#######################################"
log info "# Loading configuration file"
log info "#######################################"
CONFIG_FILE="$1"

if [[ ! -f "$CONFIG_FILE" ]]; then
    log error "Configuration file not found !"
    exit 1
fi
source $CONFIG_FILE
log info "Configuration file loaded !"



log info "#######################################"
log info "# Lock (prevent double execution)"
log info "#######################################"
exec 9>/var/lock/${app_name}_backup.lock
flock -n 9 || {
  log error "Backup already running"
  exit 1
}
log info ""

log info "#######################################"
log info "# Create dump directories"
log info "#######################################"
run mkdir -p "$dump_file_directory"
log info ""

log info "#######################################"
log info "# Dump MySQL database"
log info "#######################################"

run mysqldump \
    --defaults-file="$app_db_credential_file" \
    --routines \
    --triggers \
    --events \
    --master-data=2 \
    --no-tablespaces \
    --quick \
    --lock-all-tables \
    --databases "$app_db_name" \
    --result-file="$dump_directory/$db_dump_file_name" \
    --log-error="$dump_directory/$db_dump_file_name.errors"
log info ""


log info "#######################################"
log info "# Sync application files"
log info "#######################################"
for src in "${!app_dump_directories[@]}"; do
  dst="${app_dump_directories[$src]}"
  log info "---Syncing $src to $dst---"
  run mkdir -p "$dst"
  run rsync -a --delete-after "$src" "$dst"
done
log info ""

log info "#######################################"
log info "# Tar application files"
log info "#######################################"
run tar -czf \
  "$dump_directory/${app_db_name}-${SCRIPT_DATE}-FilesBackup.tar.gz" \
  -C "$dump_file_directory" \
  .
log info ""

log info "#######################################"
log info "# Generate passphrase for files backup"
log info "#######################################"
passfile="$dump_directory/${app_db_name}-${SCRIPT_DATE}-FilesBackup.tar.gz.password.key"
run openssl rand -base64 -out "$passfile" 124
log info ""

log info "###########################################################"
log info "# Encrypt files backup"
log info "###########################################################"
run openssl enc -pbkdf2 -salt -a \
  -in "$dump_directory/${app_db_name}-${SCRIPT_DATE}-FilesBackup.tar.gz" \
  -out "$dump_directory/${app_db_name}-${SCRIPT_DATE}-FilesBackup.tar.gz.crypt" \
  -pass file:"$passfile"
log info ""

log info "######################################################################"
log info "# Encrypt passphrase (modern OpenSSL) with public key for files backup"
log info "######################################################################"
run openssl pkeyutl -encrypt \
  -pubin \
  -inkey "$public_key" \
  -in "$passfile" \
  -out "$passfile.crypt"
log info ""

log info "#######################################"
log info "# Compress DB dump"
log info "#######################################"
run gzip "$dump_directory/$db_dump_file_name"
log info ""

log info "#######################################"
log info "# Generate passphrase"
log info "#######################################"
passfile="$dump_directory/$db_dump_file_name.password.key"
run openssl rand -base64 -out "$passfile" 124
log info ""

log info "###########################################################"
log info "# Encrypt DB dump (modern OpenSSL with PBKDF2)"
log info "###########################################################"
run openssl enc -pbkdf2 -salt -a \
  -in "$dump_directory/$db_dump_file_name.gz" \
  -out "$dump_directory/$db_dump_file_name.gz.crypt" \
  -pass file:"$passfile"
log info ""


log info "###########################################################"
log info "# Encrypt passphrase (modern OpenSSL) with public key"
log info "###########################################################"
run openssl pkeyutl -encrypt \
  -pubin \
  -inkey "$public_key" \
  -in "$passfile" \
  -out "$passfile.crypt"
log info ""


log info "#######################################"
log info "# Create final tarball"
log info "#######################################"
run tar -cvf "$dump_directory/$db_dump_file_name.tar" \
    -C "$dump_directory" \
    $(basename "$passfile.crypt") \
    $(basename "$db_dump_file_name.errors") \
    $(basename "$db_dump_file_name.gz.crypt")
log info ""

log info "#######################################"
log info "# Cleanup sensitive files"
log info "#######################################"
run rm -f \
  "$passfile" \
  "$dump_directory/$db_dump_file_name.gz" \
  "$dump_directory/$db_dump_file_name.gz.crypt" \
  "$dump_directory/$db_dump_file_name.errors" \
  "$passfile.crypt"
log info ""

log info "#######################################"
log info "# Remove yesterday dumps"
log info "#######################################"
yesterday="$(date --date='yesterday' +'%Y%m%d')"
run rm -f "$dump_directory/${app_db_name}-${yesterday}_*"

log info "#######################################"
log info "# Send to blob"
log info "#######################################"
# run "/home/backup/scripts/send_to_blob.sh \
#   $dump_directory/$db_dump_file_name.tar"

# run "/home/backup/scripts/send_to_blob.sh \
#   $dump_directory/${app_db_name}-${SCRIPT_DATE}-FilesBackup.tar.gz"

log info "#######################################"
log info "# END - exit (0)"
log info "#######################################"

exit 0
