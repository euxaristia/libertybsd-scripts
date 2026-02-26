#!/bin/sh

set -eu

usage() {
	echo "usage: $0 <base_dir> <packages_dir> <syspatch_dir> <private_keys_dir>" >&2
	echo "expects SHA256 files in each directory and 78 private keys in private_keys_dir" >&2
	exit 2
}

if [ "$#" -ne 4 ]; then
	usage
fi

BASE_DIR=$1
PACKAGES_DIR=$2
SYSPATCH_DIR=$3
KEY_DIR=$4
REL=78

require_file() {
	if [ ! -f "$1" ]; then
		echo "missing file: $1" >&2
		exit 1
	fi
}

run() {
	echo "==> $*"
	"$@"
}

require_file "$BASE_DIR/SHA256"
require_file "$PACKAGES_DIR/SHA256"
require_file "$SYSPATCH_DIR/SHA256"
require_file "$KEY_DIR/libertybsd-${REL}-base.sec"
require_file "$KEY_DIR/libertybsd-${REL}-pkg.sec"
require_file "$KEY_DIR/libertybsd-${REL}-syspatch.sec"

run signify -S -s "$KEY_DIR/libertybsd-${REL}-base.sec" \
	-m "$BASE_DIR/SHA256" -x "$BASE_DIR/SHA256.sig"
run signify -S -s "$KEY_DIR/libertybsd-${REL}-pkg.sec" \
	-m "$PACKAGES_DIR/SHA256" -x "$PACKAGES_DIR/SHA256.sig"
run signify -S -s "$KEY_DIR/libertybsd-${REL}-syspatch.sec" \
	-m "$SYSPATCH_DIR/SHA256" -x "$SYSPATCH_DIR/SHA256.sig"

echo "7.8 signatures generated."
