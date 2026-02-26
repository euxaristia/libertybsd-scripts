#!/bin/sh
########################################
# name: src_rebrand.sh
# main: jadedctrl
# lisc: isc
# desc: rebranding obsd base sources for
#	use in lbsd.
########################################

. ./libdeblob.sh

if test -z "$1"; then
	echo "usage: src_rebrand.sh source_dir"
	exit 2
else
	SRC_DIR="$1"
fi

PATCH_DIR=/tmp/src_rebrand
mkdir "$PATCH_DIR" 2> /dev/null


# --------------------------------------

arch_list="amd64 i386"

rep "export OBSD=\"OpenBSD/\$ARCH \$VNAME\""    \
    "export OBSD=\"LibertyBSD/\$ARCH \$VNAME\"" \
    distrib/miniroot/dot.profile

# --------------------------------------

#iso_list="alpha amd64 hppa i386 sgi sparc sparc64 vax"
iso_list="amd64 i386"

for arch in $iso_list; do
	rep "OpenBSD \${OSREV} ${arch} Install CD" \
	    "LibertyBSD \${OSREV} ${arch} Install" \
	    distrib/$arch/iso/Makefile
	rep "Copyright (c) `date +%Y` Theo de Raadt, The OpenBSD project" \
	    "Copyright (c) `date +%Y` -OpenBSD- and LibertyBSD projects"  \
	    distrib/$arch/iso/Makefile

	rep "Theo de Raadt <deraadt@openbsd.org>" \
	    "Jaidyn Ann <jadedctrl@teknik.io>"    \
	    distrib/$arch/iso/Makefile
	rep "OpenBSD/\${MACHINE}   \${OSREV} Install CD" \
	    "LibertyBSD/\${MACHINE} \${OSREV} Install"   \
	    distrib/$arch/iso/Makefile
done

# --------------------------------------

#cdfs_list="alpha amd64 i386 loongson sgi sparc sparc64 vax"
cdfs_list="amd64 i386"
for arch in $(echo $cdfs_list);	do
	rep "OpenBSD \${OSREV} ${arch} bootonly CD" \
	    "LibertyBSD \${OSREV} ${arch} bootonly" \
	    distrib/$arch/ramdisk_cd/Makefile
	rep "Copyright (c) `date +%Y` Theo de Raadt, The OpenBSD project" \
	    "Copyright (c) `date +%Y` -OpenBSD- and LibertyBSD projects"  \
	    distrib/$arch/ramdisk_cd/Makefile
	rep "Theo de Raadt <deraadt@openbsd.org>" \
	    "Jaidyn Ann <jadedctrl@teknik.io>"    \
	    distrib/$arch/ramdisk_cd/Makefile
	rep "OpenBSD/${arch}   \${OSREV} boot-only CD" \
	    "LibertyBSD/${arch} \${OSREV} boot-only"   \
	    distrib/$arch/ramdisk_cd/Makefile
done

# --------------------------------------

for arch in $(echo $arch_list); do
	rep "You will not be able to boot OpenBSD from \${1}." \
	    "You will not be able to boot LibertyBSD from \${1}." \
	    distrib/$arch/common/install.md
done


rep "#define DMESG_START \"OpenBSD \"" \
    "#define DMESG_START \"LibertyBSD \"" \
    usr.bin/sendbug/sendbug.c
rep "bugs@openbsd.org" "jadedctrl@teknik.io" usr.bin/sendbug/sendbug.c

rep	"sysctl -n kern.version | sed 1q >" \
	"sysctl -n kern.version | sed 1q | sed 's/OpenBSD/LibertyBSD/' >" \
	etc/rc

rep "kerninfo.sysname" "\"LibertyBSD\"" libexec/getty/main.c

# Adding LBSD keys
local_key="files/keys/libertybsd-"
lbsd_key="etc/signify/libertybsd-"

# Use the newest three key generations (previous/current/next release window).
versions="$(ls ${local_key}*-base.pub 2>/dev/null \
	| sed 's|.*/libertybsd-||; s|-base\.pub$||' \
	| sort -nu \
	| tail -3)"

if test -z "$versions"; then
	echo "No LibertyBSD base keys found under files/keys/"
	exit 1
fi

for ver in $versions; do
	for key in base pkg syspatch; do
		if test ! -f "${local_key}${ver}-${key}.pub"; then
			echo "Missing key file: ${local_key}${ver}-${key}.pub"
			exit 1
		fi
		filecp "${local_key}${ver}-${key}.pub" \
			"${lbsd_key}${ver}-${key}.pub"
	done
	filedel etc/signify/openbsd-${ver}-fw.pub
done

lbsd_key="./etc/signify/libertybsd-"
m_path="distrib/sets/lists/base/mi"
for ver in $versions; do
	lineadd "openbsd-${ver}-base.pub" "${lbsd_key}${ver}-base.pub" $m_path
	lineadd "openbsd-${ver}-pkg.pub" "${lbsd_key}${ver}-pkg.pub" $m_path
	lineadd "openbsd-${ver}-syspatch.pub" \
		"${lbsd_key}${ver}-syspatch.pub" $m_path
	linedel "openbsd-${ver}-fw.pub" $m_path
done

# --------------------------------------

filecp files/motd etc/motd
filecp files/root.mail etc/root/root.mail 
filecp files/install.sub distrib/miniroot/install.sub

rep "openbsd-" "libertybsd-" usr.sbin/syspatch/syspatch.sh
rep "OpenBSD" "LibertyBSD" usr.sbin/syspatch/syspatch.sh

# --------------------------------------

echo "Applying..."
apply
