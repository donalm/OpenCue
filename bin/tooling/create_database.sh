#!/bin/bash

export BINDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
export BASEDIR="$(dirname $BINDIR)"

source "${BINDIR}/bin/database_credentials.sh"

cd /tmp
sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}'"
sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME} WITH OWNER ${DB_USER}"
if [[ "$?" != "0" ]]; then
    echo "Exiting because it looks like the database already exists"
    exit
fi

sudo -u postgres psql $DB_NAME  -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""
if [[ "$?" != "0" ]]; then
    echo "Exiting because it looks like postgresql contrib (e.g. postgresql11-contrib) is not installed"
    exit
fi

sql_filepath="${BASEDIR}/cuebot/src/main/resources/conf/ddl/postgres/migrations/V1__Initial_schema.sql"
psql $DB_URI < $sql_filepath
