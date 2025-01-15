#!/bin/bash

# Controlla se è stata passata una lettera del disco come argomento
if [ -z "$1" ]; then
    echo "Usage: $0 <drive_letter>"
    echo "Example: $0 T"
    exit 1
fi

# Lettera del disco (convertita in maiuscolo per il montaggio)
DRIVE_LETTER=$(echo "$1" | tr '[:lower:]' '[:upper:]')

# Directory di montaggio (sempre in minuscolo)
MOUNT_DIR="/mnt/$(echo "$DRIVE_LETTER" | tr '[:upper:]' '[:lower:]')"

# Funzione per unmount
unmount_disk() {
    if mountpoint -q $MOUNT_DIR; then
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

# Funzione per montare il disco
mount_disk() {
    # Crea la directory di montaggio se non esiste
    sudo mkdir -p $MOUNT_DIR

    # Monta il disco
    echo "Mounting $DRIVE_LETTER: to $MOUNT_DIR..."
    sudo mount -t drvfs "$DRIVE_LETTER:" $MOUNT_DIR
    if [ $? -eq 0 ]; then
        echo "Mount successful."
    else
        echo "Mount failed."
        exit 1
    fi
}

# Unmount del disco se già montato
unmount_disk

# Monta il disco
mount_disk