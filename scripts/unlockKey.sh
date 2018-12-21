#!/bin/bash

# Check args
if [ $# -lt 2 ]; then
  echo 'Remove the password from a secret key.'
  echo 'Usage: unlockKey.sh <keyin> <keyout>'
  exit 1
fi

INKEY=$1
OUTKEY=$2

check=X
checkCount=3
while [[ $checkCount -gt 0 ]] && [[ "$check" != "n" ]]; do
  ((checkCount-=1))

  echo "** Warning, this will output the key in an unencrypted format. Continue [y/N]?"
  read check
  check=$(echo $check | tr '[:upper:]' '[:lower:]')

  if [ "$check" = "y" ]; then
    # Open the key, and output without protection
    openssl rsa -in $INKEY -out $OUTKEY && chmod 400 $OUTKEY
    exit
  fi
done

echo "Aborted."

exit 2
