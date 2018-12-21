#!/bin/bash

# Check args
if [ $# -lt 3 ]; then
  echo 'Creates a certificate and signs with the current CA'
  echo 'Usage: createSignedCertificate.sh <keyfile> <crtfile> <exts> [lifetime_days] [subj]'
  echo '  keyfile: file containing the private key'
  echo '  crtfile: file to create containing the signed certificate'
  echo '  exts: the extensions to apply to the certificate'
  echo '  lifetime_days: number of days to sign the certificate for (default 365 days)'
  echo '  subj: subject to use in the certificate'
  exit 1
fi

CADIR=CA
KEYFILE=$1
CRTFILE=$2
EXTS=$3
LIFE_DAYS=${4:-365} # Default to 1 year
SUBJ="$5"

if [ ! -f $CADIR/intermediate.key ] || [ ! -f $CADIR/intermediate.crt ]; then
  echo CA not found, are you in the CA directory?
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

# Create the CSR
if [ ! -z "$SUBJ" ]; then
  openssl req -new -config ../openssl.cnf -out $CRTFILE.csr -key $KEYFILE -subj "$SUBJ" || exit 1
else
  openssl req -new -config ../openssl.cnf -out $CRTFILE.csr -key $KEYFILE || exit 1
fi


echo ================================
echo  Signing certificate
echo ================================

# Sign the certificate using the intermediate CA
(openssl ca -config ../openssl.cnf -name int_CA -in $CRTFILE.csr -out $CRTFILE -cert $CADIR/intermediate.crt -keyfile $CADIR/intermediate.key -notext -days $LIFE_DAYS -extensions $EXTS && chmod 444 $CRTFILE) && chmod 444 $CRTFILE || exit 1

# Remove the CSR
rm $CRTFILE.csr

