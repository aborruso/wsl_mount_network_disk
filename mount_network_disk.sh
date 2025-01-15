#!/bin/bash

# Check if a drive letter was passed as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <drive_letter>"
    echo "Example: $0 T"
    exit 1
fi

# Check if the network drive exists
if ! ls /mnt/ 2>/dev/null | grep -q "^$(echo "$1" | tr '[:upper:]' '[:lower:]')$"; then
    echo "Il disco di rete $1 non esiste."
    exit 1
fi

# Drive letter (converted to uppercase for mounting)
DRIVE_LETTER=$(echo "$1" | tr '[:lower:]' '[:upper:]')

# Mount directory (always lowercase)
MOUNT_DIR="/mnt/$(echo "$DRIVE_LETTER" | tr '[:upper:]' '[:lower:]')"

# Unmount function
unmount_disk() {
    if mountpoint -q $MOUNT_DIR; then
        read -p "Are you sure you want to unmount $MOUNT_DIR? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo "Unmount cancelled."
            return 1
        fi
        echo "Unmounting $MOUNT_DIR..."
        sudo umount $MOUNT_DIR
        if [ $? -eq 0 ]; then
            echo "Unmount successful."
        else
            echo "Unmount failed."
            exit 1
        fi
    else
        echo "$MOUNT_DIR is not mounted."
    fi
}

# Mount function
mount_disk() {
    # Ask for confirmation
    read -p "Are you sure you want to mount drive $DRIVE_LETTER in $MOUNT_DIR? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Mount cancelled."
        exit 1
    fi

    # Check if the drive is already mounted
    if mountpoint -q $MOUNT_DIR; then
        echo "$MOUNT_DIR is already mounted."
        exit 1
    fi

    # Create mount directory if it doesn't exist
    sudo mkdir -p $MOUNT_DIR

    # Mount the drive
    echo "Mounting $DRIVE_LETTER: to $MOUNT_DIR..."
    sudo mount -t drvfs "$DRIVE_LETTER:" $MOUNT_DIR
    if [ $? -eq 0 ]; then
        echo "Mount successful."
    else
        echo "Mount failed."
        exit 1
    fi
}

# Unmount drive if already mounted
unmount_disk

# Mount the drive
mount_disk

# Function to ask if navigating to the directory
navigate_to_mount() {
    read -p "Do you want to navigate to $MOUNT_DIR? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd $MOUNT_DIR
        echo "Changed directory to $MOUNT_DIR"
        exec $SHELL  # Riavvia la shell per mantenere il nuovo percorso
    else
        echo "Staying in current directory."
    fi
}

# Ask if navigating to the mounted directory
navigate_to_mount
