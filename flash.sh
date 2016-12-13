#!/bin/sh
# Example Usage: create-bootable /dev/sdb "VMvisor"

set -e

DRIVE=$1
LABEL=$2

if [ ! -b "${DRIVE}" ]; then
	echo ${DRIVE} is not a block device
	exit 1
fi

for mounted in $(findmnt -o source | grep "^${DRIVE}") ; do
    umount "${mounted}"
done

echo "****************** Formatting drive ******************" 
wipefs --all ${DRIVE}

{
echo ,,0x0C,*
} | sfdisk ${DRIVE}

mkfs.vfat -F 32 -n "${LABEL}" ${DRIVE}1
