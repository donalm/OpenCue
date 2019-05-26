#!/bin/bash

export BINDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BINDIR}/database_credentials.sh"

export BASEDIR="$(dirname $BINDIR)"

$BINDIR/create_database.sh

cd "${BASEDIR}/cuebot"
./gradlew shadowJar
