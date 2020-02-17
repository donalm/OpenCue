#!/bin/bash

export BASEDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BASEDIR}/bin/tooling/database_credentials.sh"

cd $BASEDIR
jarfile="${BASEDIR}/cuebot/build/libs/cuebot.jar"

exec java -jar $jarfile \
    --datasource.cueDataSource.url=jdbc:postgresql://$DB_HOST/$DB_NAME \
    --datasource.cueDataSource.username=$DB_USER \
    --datasource.cueDataSource.password=$DB_PASS
