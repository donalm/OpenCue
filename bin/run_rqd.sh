#!/bin/bash

export BASEDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
source "${BASEDIR}/bin/tooling/update_environment.sh"
cd $BASEDIR

check_prefix=$(echo "${BASEDIR}" | cut -c1-6)
if [[ "${check_prefix}" == "/home/" ]]; then
    echo "WARNING: This executable will drop privileges and run as the 'daemon' user."
    echo "         If your development environment cannot be accessed by the 'daemon'"
    echo "         user, you may get unexpected ImportErrors"
fi

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
if [[ "${v}" == "3" ]]; then
    outdir="${BASEDIR}/rqd/rqd"
    cd "${BASEDIR}"
    rm -rf "${BASEDIR}/_temp_proto"
    mkdir -p "${BASEDIR}/_temp_proto/compiled_proto"
    cp -a "${BASEDIR}/proto"  "${BASEDIR}/_temp_proto/proto"
    cd "${BASEDIR}/_temp_proto"
    python -m grpc_tools.protoc -I./proto --python_out=./compiled_proto --grpc_python_out=./compiled_proto ./proto/*.proto
    cd "${BASEDIR}/_temp_proto/compiled_proto"
    sed -i -E 's/^import.*_pb2/from . \0/' *.py
    cp -a "${BASEDIR}/_temp_proto/compiled_proto" "${BASEDIR}/rqd/rqd/"
else
    # regenerate the compiled protobuffs protocols for this python version
    outdir="${BASEDIR}/rqd/rqd/compiled_proto"
    cd "${BASEDIR}"
    python -m grpc_tools.protoc -I=./proto --python_out="${outdir}" --grpc_python_out="${outdir}" ./proto/*.proto
    cd "${outdir}"
    sed -i -E 's/^import.*_pb2/from . \0/' *.py
    cd $BASEDIR
fi


exec "${BASEDIR}/venv_py${v}/bin/python"  "${BASEDIR}/bin/tooling/run_rqd.py"
