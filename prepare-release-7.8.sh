#!/bin/sh

set -eu

usage() {
	echo "usage: $0 <src_dir> <sys_dir> <xenocara_dir> <ports_dir>" >&2
	exit 2
}

if [ "$#" -ne 4 ]; then
	usage
fi

SRC_DIR=$1
SYS_DIR=$2
XENOCARA_DIR=$3
PORTS_DIR=$4

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

require_dir() {
	if [ ! -d "$1" ]; then
		echo "missing directory: $1" >&2
		exit 1
	fi
}

require_key() {
	if [ ! -f "$1" ]; then
		echo "missing key file: $1" >&2
		exit 1
	fi
}

run() {
	echo "==> $*"
	"$@"
}

require_dir "$SRC_DIR"
require_dir "$SYS_DIR"
require_dir "$XENOCARA_DIR"
require_dir "$PORTS_DIR"

for rel in 77 78 79; do
	for kind in base pkg syspatch; do
		require_key "files/keys/libertybsd-${rel}-${kind}.pub"
	done
done

run sh ./src_deblob.sh "$SRC_DIR"
run sh ./man_deblob.sh "$SRC_DIR"
run sh ./sys_deblob.sh "$SYS_DIR"
run sh ./src_rebrand.sh "$SRC_DIR"
run sh ./sys_rebrand.sh "$SYS_DIR"
run sh ./man_rebrand.sh "$SRC_DIR"
run sh ./xenocara_rebrand.sh "$XENOCARA_DIR"
run sh ./ports_deblob.sh "$PORTS_DIR"
run sh ./ports_rebrand.sh "$PORTS_DIR"

echo "7.8 source preparation complete."
echo "next: build release artifacts and sign with libertybsd-78-{base,pkg,syspatch}.sec"
