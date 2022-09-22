#
# Source pre-requist functions
#
# There is no pre-requist functions

# This GLOBAL variable must be defined :
#    - $SCRIPT_NAME" with the name of the root script
#    - $SCRIPT_PID"  with the PID of the root script

# This functin dump a postgresql database
# Usage : dump_database_postgresql <db_name> <backup_output_file> <credential_file>
function dump_database_postgresql()
{
  local _fname="dump_database_postgresql()"
  local _paramerters_number=$#
  local _expectedParam="4"

  local _db_name=$1
  local _db_backup_output_file=$2
  local _db_dump_credential_file=$3
  local _db_dump_options=$4

  : '
  /*
  **  To use this method create ".pgpass" file inside your home directory
  **  and restrict its permissions so it would not be ignored by utilities.
  **        $ touch ~/.pgpass
  **        $ chmod 0600 ~/.pgpass
  **
  **  Each line defines user credentials using the following structure.
  **        server:port:database:username:password
  **
  **  Please note that every field other than password can be replaced with an
  **  asterisk to match anything, everything else is self explanatory so I will
  **  jump directly to the example.
  **        localhost:5432:bookmarks:milosz:JOAvaDtW8SRZ2w7S
  **        10.0.0.15:5432:wikidb:mediawiki:631j7ZtLvSF4fyIR
  **        10.0.0.113:*:*:development:iGsxFMziuwLdEEqw
  **
  **  Now, as user with defined PostgreSQL password file, you can use PostgreSQL
  **  utilities without password prompt to perform desired tasks.
  **  You are not forced to use only ~/.pgpass file as you can define PGPASSFILE
  **  variable to use entirely different password file.
  **        $ PGPASSFILE=<db_dump_credential_file> pg_dump -c -w -U <user> --file=<db_backup_output_file> <database>
  */
  '

  local _task=""
  local _cmd=""
  local _retval=0
  local _retcode=0

  if [ "$_paramerters_number" -ne $_expectedParam ]; then
  {
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide." >&2)
    $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - [ERROR] Number of parameters is invalide - There is \"$_paramerters_number\" ($_expected_paramerters_number is expected)" >&2)
    return 1
  }
  fi

  #PGPASSFILE=<port> pg_dump -h <host> -p <port> -U <user> -w -v -Fd -c -C -o <dbname>

  $(echo "$(date) - [$SCRIPT_NAME ($SCRIPT_PID)] - $_fname - postgresql dump NOT YET IMPLEMENTED !!!" >&2)
  return 1
}
