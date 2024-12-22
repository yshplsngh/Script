#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: ./edit-encrypted.sh secret.gpg"
	exit 1
fi

TMPFILE=$(mktemp)
gpg -d "$1" > "$TMPFILE"
nano "$TMPFILE"

cp "$TMPFILE" "secret"
shred -u -n 3 "$1"
gpg -c "secret"

shred -u -n 3 "$TMPFILE"
shred -u -n 3 "secret"

echo "Done"