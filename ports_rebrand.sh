#!/bin/sh
########################################
# name: ports_rebrand.sh
# main: jadedctrl
# lisc: isc
# desc: editing obsd ports tree for use
#       with lbsd.
########################################

. ./libdeblob.sh

if test -z "$1"; then
	echo "usage: ports_rebrand.sh ports_dir"
else	
	SRC_DIR="$1"
fi

PATCH_DIR=/tmp/ports_rebrand/
mkdir "$PATCH_DIR" 2> /dev/null


# --------------------------------------

portdirs="archivers astro audio biology books cad chinese comms converters"
portdirs="$portdirs databases devel editors education emulators fonts games geo" 
portdirs="$portdirs graphics inputmethods japanese java korean lang mail math"
portdirs="$portdirs meta misc multimedia net news plan9 print productivity"
portdirs="$portdirs security shells sysutils telephony textproc www x11"

# --------------------------------------

rep	"ftp.openbsd.org/pub/OpenBSD/snapshots/i386/cd52.iso" \
	"ftp.libertybsd.net/pub/LibertyBSD/snapshots/i386/cd78.iso" \
	emulators/qemu/pkg/README 
rep	"ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/cd52.iso" \
	"ftp.libertybsd.net/pub/LibertyBSD/snapshots/amd64/cd78.iso" \
	emulators/qemu/pkg/README
linedel "\$ ftp ftp://ftp.openbsd.org/pub/OpenBSD/snapshots/sparc/cd52.iso" \
	emulators/qemu/pkg/README
rep "install52.fs" "install78.fs" emulators/qemu/pkg/README
rep "install52.iso" "install78.iso" emulators/qemu/pkg/README
rep "OpenBSD" "LibertyBSD" emulators/qemu/pkg/README

rep "ftp.openbsd.org" "ftp.libertybsd.net" \
sysutils/ruby-puppet/4/patches/patch-lib_puppet_provider_package-openbsd_rb

rep "on OpenBSD" "on LibertyBSD" sysutils/sysmon/pkg/README
rep "openbsd.org" "libertybsd.net" sysutils/sysmon/pkg/README

rep "=\"OpenBSD " "=\"LibertyBSD " multimedia/gstreamer-0.10/Makefile.inc
rep "openbsd.org" "libertybsd.net" multimedia/gstreamer-0.10/Makefile.inc

rep "www.openbsd.org" "libertybsd.net" www/lynx/patches/patch-lynx_cfg

apply
