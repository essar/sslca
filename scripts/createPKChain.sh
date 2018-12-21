#!/bin/bash

# Check args
if [ $# -lt 4 ]; then
  echo 'Usage: createPKChain.sh <keyfile> <crtfile> <name>'
  echo '  keyfile: Private key'
  echo '  crtfile: Certificate'
  echo '  pkfile: PKCS#12 file'
  echo '  name: Friendly name'
  exit 1
fi

CADIR=CA
KEYFILE=$1
CRTFILE=$2
PKFILE=$3
NAME="$4"

if [ ! -f $CADIR/intermediate.key ] || [ ! -f $CADIR/intermediate.crt ]; then
  echo CA not found, are you in the CA directory?
  exit 1
fi

if [ ! -f $KEYFILE ]; then
  echo Key not found.
  exit 1
fi

if [ ! -f $CRTFILE ]; then
  echo Certificate not found.
  exit 1
fi

if [ -f $PKFILE ]; then
  echo Certificate chain already exists.
  exit 1
fi


# Pipe the key and certificates to create the chain
cat $KEYFILE $CRTFILE $CADIR/intermediate.crt | openssl pkcs12 -export -out $PKFILE -name "$NAME"

