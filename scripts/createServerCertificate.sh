#!/bin/bash

# Check args
if [ $# -lt 2 ]; then
  echo 'Creates a server certificate and signs with the current CA'
  echo 'Usage: createClientCertificate.sh <keyfile> <crtfile> [lifetime_days] [subj]'
  echo '  keyfile: file containing the private key'
  echo '  crtfile: file to create containing the signed certificate'
  echo '  lifetime_days: number of days to sign the certificate for (default 365 days)'
  echo '  subj: subject to use in the certificate'
  echo '  sans: list of Subject Alternate Names to add to the certificate'
  exit 1
fi

CADIR=CA
KEYFILE=$1
CRTFILE=$2
LIFE_DAYS=${3:-365} # Default to 1 year
SUBJ="$4"
SANS="$5"

mydir=$(dirname "$0")

$mydir/createSignedCertificate.sh $KEYFILE $CRTFILE v3_svr $LIFE_DAYS "$SUBJ" "$SANS"

