#!/bin/bash

# Initialises a new CA directory

if [ $# -lt 1 ]; then
  echo "Usage: initCA.sh <caname>"
  exit 1
fi

CADIR=$1/CA

if [ -d $CADIR ]; then
  echo Directory already exists.
  exit 1
fi

mkdir -p $CADIR
mkdir $CADIR/certs
touch $CADIR/index.txt
echo 01 > $CADIR/serial
chmod 700 $CADIR $CADIR/certs

echo Initialised CA in $CADIR
