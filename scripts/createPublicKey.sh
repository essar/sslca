#!/bin/bash

# Check args
if [ $# -lt 2 ]; then
  echo 'Usage: generatePublicKey.sh <keyin> <keyout>'
  echo '  keyin: Input key'
  echo '  keyout: Output destination'
  exit 1
fi

INKEY=$1
OUTKEY=$2

if [ ! -f $INKEY ]; then
  echo Keyin not found or not a file.
  exit 1
fi

# Open the key, and generate the public key
openssl rsa -in $INKEY -out $OUTKEY -pubout && chmod 444 $OUTKEY

