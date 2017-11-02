#!/bin/bash

# $DIR, $TARGET and $IMAGE are exported by parent script.
echo "Unpacking '$IMAGE' to '$TARGET'."

# Do not overwrite existing directories.
if [[ -d "$TARGET" ]]; then
    echo "Error: target directory already exists. Aborting."
    exit 1
fi

# Create required directories.
TEMP=`mktemp -d`

mkdir "$TEMP/cd"
mkdir "$TEMP/fs"
mkdir -p "$TARGET/cd"
mkdir -p "$TARGET/fs"

# Mount CD and filesystem.
sudo modprobe squashfs

sudo mount -o loop "$IMAGE" "$TEMP/cd"
sudo mount -t squashfs -o loop "$TEMP/cd/casper/filesystem.squashfs" "$TEMP/fs"

# Copy files.
sudo rsync -a "$TEMP/cd/" "$TARGET/cd/"
sudo rsync -a "$TEMP/fs/" "$TARGET/fs/"

# Unmount CD and filesystem.
sudo umount "$TEMP/fs"
sudo umount "$TEMP/cd"

# Cleanup
rm -rf "$TEMP/"
