#!/bin/bash

export BINDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BINDIR}/tooling/database_credentials.sh"

export BASEDIR="$(dirname $BINDIR)"

$BINDIR/tooling/create_database.sh

cd "${BASEDIR}/cuebot"
./gradlew build
