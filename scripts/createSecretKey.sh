#!/bin/bash

# Check args
if [ $# -lt 1 ]; then
  echo 'Usage: createSecretKey.sh <keyfile> [bits]'
  exit 1
fi

KEYFILE=$1
BITS=${2:-2048}

if [ -f $KEYFILE ]; then
  echo Key already exists.
  exit 1
fi

echo ================================
echo   Create key
echo ================================

# Create the key
openssl genrsa -out $KEYFILE -aes256 $BITS && chmod 400 $KEYFILE

