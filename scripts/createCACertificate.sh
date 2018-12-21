#!/bin/bash

# Check args
if [ $# -lt 2 ]; then
  echo 'Creates an intermediate CA certificate'
  echo 'Usage: createCACertificate.sh <keyfile> <crtfile> [lifetime_days]'
  echo '  keyfile: file containing the private key'
  echo '  crtfile: file to create containing the signed certificate'
  echo '  lifetime_days: number of days to sign the certificate for'
  exit 1
fi

ROOTCA=../.rootca
KEYFILE=$1
CRTFILE=$2
CADIR=./CA
LIFE_DAYS=${4:-3650} # Default to 10 years

if [ ! -d $CADIR ]; then
  echo CA not found, are you in the CA directory?
  exit 1
fi

if [ ! -f $ROOTCA/root.crt ]; then
  echo Root CA not available.
  exit 1
fi

if [ -f $CADIR/intermediate.key ] || [ -f $CADIR/intermediate.crt ]; then
  echo Key or certificate already exists in CA.
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
echo  Creating certificate
echo ================================

# Create the certificate
openssl req -new -x509 -config ../openssl.cnf -out $CRTFILE.1 -key $KEYFILE -days $LIFE_DAYS -extensions v3_int || exit 1


echo ================================
echo  Signing certificate
echo ================================

# Sign the certificate using the root CA
(openssl ca -config ../openssl.cnf -name root_CA -ss_cert $CRTFILE.1 -out $CRTFILE -notext -days $LIFE_DAYS -extensions v3_int && chmod 444 $CRTFILE) || exit 1

# Move key to CA
mv $KEYFILE $CADIR/intermediate.key
cp -p $CRTFILE $CADIR/intermediate.crt
rm $CRTFILE.1

