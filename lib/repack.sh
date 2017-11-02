#!/bin/bash

# $DIR, $TARGET and $OUTPUT are exported by parent script.
echo "Repacking '$TARGET' to '$OUTPUT'."

# Check for target.
if [[ ! -d "$TARGET" ]]; then
    echo "Error: target directory does not exist. Aborting."
    exit 1
fi

# Create filesystem files.
sudo rm -f "$TARGET/cd/casper/filesystem.manifest"
sudo rm -f "$TARGET/cd/casper/filesystem.manifest-desktop"
sudo rm -f "$TARGET/cd/casper/filesystem.squashfs"

sudo chroot "$TARGET/fs" dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee "$TARGET/cd/casper/filesystem.manifest" > /dev/null
sudo cp "$TARGET/cd/casper/filesystem.manifest" "$TARGET/cd/casper/filesystem.manifest-desktop"
sudo mksquashfs "$TARGET/fs" "$TARGET/cd/casper/filesystem.squashfs"

# Update MD5 sums.
(
    cd "$TARGET/cd"
    sudo rm -f "md5sum.txt"
    sudo find . -type f -print0 | xargs -0 md5sum | grep -v md5sum.txt | sudo tee -a "md5sum.txt" > /dev/null
)

# Create new ISO image.
(
    cd "$TARGET/cd"
    sudo mkisofs -D -r -V "Ubuntu-Live" -b isolinux/isolinux.bin -c isolinux/boot.cat -cache-inodes -J -l -no-emul-boot -boot-load-size 4 -boot-info-table -o "$OUTPUT" .
)
