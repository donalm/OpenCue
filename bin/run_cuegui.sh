#!/bin/bash

export BASEDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BASEDIR}/bin/tooling/update_environment.sh"
cd $BASEDIR

# run this like 'run_rqd.sh 3' to start it up with python3
majver=$1
default_majver=2
if [[ "${majver}" == "2" ]]; then
    v=2
elif [[ "${majver}" == "3" ]]; then
    v=3
else
    v=$default_majver
fi

# source the virtualenv-created file to get the right python interpreter and modules
activate="${BASEDIR}/venv_py${v}/bin/activate"
source "${activate}"

# regenerate the compiled protobuffs protocols for this python version
outdir="${BASEDIR}/bin/tooling/pythonpath/opencue/compiled_proto"
cd ${BASEDIR}/proto
python -m grpc_tools.protoc -I=. --python_out="${outdir}" --grpc_python_out="${outdir}" ./*.proto
cd $BASEDIR

exec "${BASEDIR}/venv_py${v}/bin/python" "${BASEDIR}/bin/tooling/pythonpath/cuegui/__main__.py"
