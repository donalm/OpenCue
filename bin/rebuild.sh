#!/bin/bash

export BASEDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BASEDIR}/bin/tooling/database_credentials.sh"
source "${BASEDIR}/bin/tooling/update_environment.sh"

sed -e "s|<BASEDIR>|${BASEDIR}|" "${BASEDIR}/bin/tooling/etc/outline.cfg.tmpl" > "${BASEDIR}/bin/tooling/etc/outline.cfg"

if [[ ! -e "${CUE_FS_ROOT}" ]]; then
    sudo mkdir -p "${CUE_FS_ROOT}"
fi

#/bin/sleep 4 &
"${BASEDIR}/bin/tooling/build_cuebot.sh" &
FIRST_PID=$!

"${BASEDIR}/bin/tooling/build_venv.sh" "2"
"${BASEDIR}/bin/tooling/build_venv.sh" "3"

wait $FIRST_PID
