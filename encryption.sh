#!/bin/bash

set -euo pipefail


# $# is the number of arguments
# -ne is not equal
# $0 is the name of the script which is the first argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <encrypted-file>"
    exit 1
fi

# Check if input file exists
# -f is a file
if [ ! -f "$1" ]; then
    echo "Input file '$1' not found!"
    exit 1
fi

TMPFILE=""

# delete temporary files on any typeexit
function cleanup() {
    echo "cleaning up temporary files..."
    if [ -f "$TMPFILE" ]; then
        shred -u -n 3 "$TMPFILE"
    fi
    if [ -f "secret" ]; then
        shred -u -n 3 "secret"
    fi
    echo "Done 🧹"
}
trap cleanup EXIT

# create a backup of the original file
mkdir -p "$HOME/.scbp"

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$HOME/.scbp/${TIMESTAMP}_$(basename "$1")"

cp "$1" "$BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"


# create a temporary file eg. /tmp/tmp.1234567890
TMPFILE=$(mktemp)

gpg -d "$1" > "$TMPFILE" || {
    echo "Decryption failed!"
    echo "Exit status: $?"
    exit 1
}

nano "$TMPFILE"

cp "$TMPFILE" "secret" || {
    echo "Failed to save unencrypted copy!"
    exit 1
}

# delete the original encrypted file eg. secret.gpg
# coz we are creating a new one with the same name
shred -u -n 3 "$1"

# encrypt the unencrypted file
# 2>/dev/null is to hide the error message of gpg
gpg -c "secret" 2>/dev/null || {
    echo "Encryption failed!"
    echo "Restoring from backup..."
    cp "$BACKUP_FILE" "$1"
    exit 1
}