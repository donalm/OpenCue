##############################################
#
# This file should not be executed directly.
# It must be called from the rebuild script.
#
##############################################

export BINDIR=$(cd -P -- "$(dirname -- "$(/usr/bin/realpath -- "$(dirname -- "$BASH_SOURCE")")")" && printf '%s\n' "$(pwd -P)")
export BASEDIR="$(dirname $BINDIR)"

majver=$1
executable="python${majver}"
interpreter=$(which $executable 2>/dev/null)
if [[ "$?" != "0" ]]; then
    echo "ERROR: no $executable in \$PATH"
    exit
fi

target="${BASEDIR}/venv_py${majver}"
if [[ ! -e $target ]]; then
    virtualenv -p $interpreter $target
fi

source "${target}/bin/activate"
pip install --upgrade -r "${BASEDIR}/requirements.txt"

cd $BASEDIR/proto
python -m grpc_tools.protoc -I=. \
    --python_out=../pycue/opencue/compiled_proto \
    --grpc_python_out=../pycue/opencue/compiled_proto \
    ./*.proto

cd $BASEDIR/pycue
python setup.py install

cd $BASEDIR/pyoutline
python setup.py install

cd $BASEDIR/rqd
python setup.py install

cd $BASEDIR/cuesubmit
python setup.py install

cd $BASEDIR/cuegui
python setup.py install

cd $BASEDIR/cueadmin
python setup.py install
