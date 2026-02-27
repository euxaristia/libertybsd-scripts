#!/bin/sh

set -eu

usage() {
	echo "usage: $0 <base_dir> <packages_dir> <syspatch_dir> <public_keys_dir>" >&2
	echo "expects SHA256 and SHA256.sig in each directory" >&2
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
require_file "$BASE_DIR/SHA256.sig"
require_file "$PACKAGES_DIR/SHA256"
require_file "$PACKAGES_DIR/SHA256.sig"
require_file "$SYSPATCH_DIR/SHA256"
require_file "$SYSPATCH_DIR/SHA256.sig"
require_file "$KEY_DIR/libertybsd-${REL}-base.pub"
require_file "$KEY_DIR/libertybsd-${REL}-pkg.pub"
require_file "$KEY_DIR/libertybsd-${REL}-syspatch.pub"

run signify -V -p "$KEY_DIR/libertybsd-${REL}-base.pub" \
	-x "$BASE_DIR/SHA256.sig" -m "$BASE_DIR/SHA256"
run signify -V -p "$KEY_DIR/libertybsd-${REL}-pkg.pub" \
	-x "$PACKAGES_DIR/SHA256.sig" -m "$PACKAGES_DIR/SHA256"
run signify -V -p "$KEY_DIR/libertybsd-${REL}-syspatch.pub" \
	-x "$SYSPATCH_DIR/SHA256.sig" -m "$SYSPATCH_DIR/SHA256"

echo "all 7.8 signatures verify."
