#!/bin/bash

# Check args
if [ $# -lt 1 ]; then
  echo 'Creates a self-signed root certificate'
  echo 'Usage: createRootCertificate.sh <keyfile> <crtfile> [days]'
  exit 1
fi

CADIR=./.rootca

KEYFILE=$1
CRTFILE=$2
LIFE_DAYS=${3:-7300} # Default to 20 years

if [ ! -d $CADIR ]; then
  echo CA folder not initialised.
  exit 1
fi

if [ -f $CADIR/root.key ] || [ -f $CADIR/root.crt ]; then
  echo CA key or certificate already exist in CA.
  exit 1
fi

if [ ! -f $KEYFILE ]; then
  echo Key not found.
  exit 1
fi

if [ -f $CRTFILE ]; then
  echo Certificate already exists.
  exit 1
fi

echo ================================
echo   Create certificate
echo ================================

# Create the certificate
openssl req -new -x509 -config openssl.cnf -out $CRTFILE -key $KEYFILE -days $LIFE_DAYS -extensions v3_root && chmod 444 $CRTFILE || exit 1

if [ $? == 0 ]; then
  # Install the key & certificate into the CA
  mv $KEYFILE $CADIR/root.key
  mv $CRTFILE $CADIR/root.crt
fi

