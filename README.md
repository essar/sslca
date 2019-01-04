
# Configuration

Use the provided openssl.cnf.example script to create your own, specifying the default DN information if required.

Create a root CA, then initialise any intermediate CAs using the `initCA.sh` script.

It is recommended to keep the root CA files away from any connected system!

# Examples

## Generate a master CA key and certificate

_This is only done once._

```
./createSecretKey.sh root.key
./createRootCertificate.sh root.key root.crt
```

Creates a 4096bit key protected with AES256 and a 5-year self-signed CA certificate.

## Create intermediate CA

```
./createSecretKey.sh intermediate.key
./createCACertificate.sh intermediate.key intermediate.crt intermediate
```

Creates a CA key and certificate and establishes a local CA database.
Certificate valid for 2 years by default.

## Remove the password from a key

```
./unlockKey.sh server.key server-open.key
```

Creates a copy of the key without encryption. Needed for webservers or SSH logins etc. where you don't want to prompt for key passwords.

## Get a public key for a private key

```
./generatePublicKey.sh server.key server-public.key
```

Creates a public key associated with a private key, useful for SSH login.
Key created without encryption.

## Create server certificate

```
cd <cadir>
../scripts/createSecretKey.sh private.key
../scripts/createServerCertificate.sh private.key server.crt
```

Creates a server certificate and key, valid for 1 year and signs with the CA.

# Create server certifiate with specified DN and SANs

```
cd <cadir>
../scripts/createSecretKey.sh private.key
../scripts/createServerCertificate.sh private.key server.crt 365 "/C=UK/O=My Org/CN=myserver.org" "DNS:alternateserver.org"
```

Creates a server certificate and key having the specified DN and optional SANs, valid for 1 year and signs with the CA.


Directory structure:

Root CA - only needs to be available when creating intermediates
- root_ca.cfg
- index.txt
- serial
- /certs
- ca.key
- ca.crt
But leave a copy of the CA.crt somewhere local

Int CA - should always be available, except the key
- int_ca.cfg
- index.txt
- serial
- /certs
- ca.key
- ca.crt
