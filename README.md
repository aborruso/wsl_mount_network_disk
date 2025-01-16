# Network Drive Mounter Script for WSL
=====================================

**Important Note:** This script is designed for users of Windows Subsystem for Linux (WSL) in corporate network environments with shared network drives. It allows you to access network drives through WSL.

This script is used to mount and unmount network drives on a Linux system.

## Installation
---------------

To install the script and make it available system-wide:

1. Copy the script to a directory in your PATH, for example `/usr/local/bin`:

```bash
sudo cp mount_network_disk.sh /usr/local/bin/mount_network_disk
```

2. Make the script executable:

```bash
sudo chmod +x /usr/local/bin/mount_network_disk
```

3. Verify the installation by running:

```bash
which mount_network_disk
```

You should see `/usr/local/bin/mount_network_disk` as output.

## Usage
---------

To use this script, simply run it with the drive letter as an argument. For example:

```bash
mount_network_disk.sh T
```

This will mount the network drive with the letter T in the `/mnt/t` directory.

## Confirmation Prompts
----------------------

The script will ask for confirmation before mounting or unmounting a drive. If you choose to cancel the operation, the script will exit.

## Requirements
------------

* The `drvfs` file system must be installed and configured on your system.
* The `sudo` command must be configured to allow the script to run with elevated privileges.

## Troubleshooting
-----------------

If you encounter any issues with the script, check the following:

* Make sure the drive letter is correct and the drive is not already mounted.
* Check the system logs for any error messages related to the `drvfs` file system or the `sudo` command.
