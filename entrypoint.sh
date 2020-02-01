#!/usr/bin/env sh

export BEET_CONFIG=${BEET_CONFIG:-/config/config.yaml}
export BEET_DIRECTORY=${BEET_DIRECTORY:-/music}
export BEET_LIBRARY=${BEET_LIBRARY:-/library/library.db}
export BEET_IMPORT_LOG=${BEET_IMPORT_LOG:-/library/import.log}
export UMASK_SET=${UMASK_SET:-022}

UMASK=$(which umask)
if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

BEET=$(which beet)
if [[ ! -x $BEET ]]; then
  echo "beet binary not found"
  exit 1
fi

CONFD=$(which confd)
if [[ ! -x $CONFD ]]; then
  echo "confd binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

echo mkdir -p "$(dirname -- $BEET_CONFIG)"
mkdir -p "$(dirname -- $BEET_CONFIG)" > /dev/null
echo mkdir -p "${BEET_DIRECTORY}"
mkdir -p "${BEET_DIRECTORY}" > /dev/null
echo mkdir -p "$(dirname -- $BEET_LIBRARY)"
mkdir -p "$(dirname -- $BEET_LIBRARY)" > /dev/null

echo $CONFD -onetime -backend env -log-level debug
$CONFD -onetime -backend env -log-level debug || exit 1

echo ${BEET} --library=${BEET_LIBRARY} --verbose --config=${BEET_CONFIG} --directory=${BEET_DIRECTORY} web --debug
exec ${*:-${BEET} --library=${BEET_LIBRARY} --verbose --config=${BEET_CONFIG} --directory=${BEET_DIRECTORY} web --debug}
