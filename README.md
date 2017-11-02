# Image Customizer
This utility can customize an Ubuntu Image. It unpacks, customizes and repacks it.

## Installation
Requirements:

* A Ubuntu machine.
* `sudo apt-get install squashfs-tools`
* `sudo apt-get install git`

## Usage
First, download a Ubuntu-base image. For instance, the default Ubuntu x64 desktop image.

* To unpack: `customizer.sh unpack -i <image file> -t <target directory>`
* To customize: `customizer.sh customize -t <target directory>`
* To repack: `customizer.sh repack -t <target directory> -o <output file>`

This script may ask for credentials (for `sudo` commands). There is no error handling, so enter it right otherwise the script will fail.

Ensure you run this script with the shell locale set to `en_US.UTF-8`, because this is the default live CD locale. If not, run this before any other commands:

```
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

To start from scratch, clear the target directory.

The resulting ISO can be burned on DVD, or on a USB stick (don't use cheap ones!).

## Development
Jobs are stored in the `jobs/` folder. They are executed alphabetically.

The jobs ending with `*.chroot` are executed within the chroot. After that, the jobs ending with `*.sh` are executed globally.

## Testing
To ensure the image is complete and working, try the following things:

* Boot the image.
* Check if Eclipse is working. Under Help -> Installation Details, verify if the ARM plugins are available.
* Check if the ARM GCC Embedded tools are available.
