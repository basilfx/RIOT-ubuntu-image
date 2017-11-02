#!/bin/bash

# $DIR and $TARGET are exported by parent script.
echo "Customizing '$TARGET'."

# Check for target.
if [[ ! -d "$TARGET" ]]; then
    echo "Error: target directory does not exist. Aborting."
    exit 1
fi

# Prepare chroot
sudo chroot "$TARGET/fs" mount -t proc none /proc
sudo chroot "$TARGET/fs" mount -t sysfs none /sys

sudo mv "$TARGET/fs/etc/resolv.conf" "$TARGET/fs/etc/resolv.conf.old"
sudo mv "$TARGET/fs/etc/hosts" "$TARGET/fs/etc/hosts.old"

sudo cp "/etc/resolv.conf" "$TARGET/fs/etc/resolv.conf"
sudo cp "/etc/hosts" "$TARGET/fs/etc/hosts"

# Run filesystem jobs, which end with *.chroot
for FILE in `ls "$DIR/jobs/"*.chroot | sort -V`; do
    DEBIAN_FRONTEND="noninteractive" LC_ALL="C" sudo chroot "$TARGET/fs" /bin/bash -x < "$FILE"
done

# Run other jobs, which end with *.cd
for FILE in `ls "$DIR/jobs/"*.sh | sort -V`; do
    source "$FILE"
done

# Cleanup chroot
sudo mv "$TARGET/fs/etc/resolv.conf.old" "$TARGET/fs/etc/resolv.conf"
sudo mv "$TARGET/fs/etc/hosts.old" "$TARGET/fs/etc/hosts"

sudo chroot "$TARGET/fs" umount /proc
sudo chroot "$TARGET/fs" umount /sys
