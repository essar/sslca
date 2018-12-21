
== Generate a master CA key and certificate
This is only done once.

./createSecretKey.sh root.key
./createRootCertificate.sh root.key root.crt

Creates a 4096bit key protected with AES256 and a 5-year self-signed CA certificate.

== Create intermediate CA
./createSecretKey.sh intermediate.key
./createCACertificate.sh intermediate.key intermediate.crt intermediate

Creates a CA key and certificate and establishes a local CA database.
Certificate valid for 2 years by default.

== Remove the password from a key
./unlockKey.sh server.key server-open.key

Creates a copy of the key without encryption. Needed for webservers or SSH logins etc. where you don't want to prompt for key passwords.

== Get a public key for a private key
./generatePublicKey.sh server.key server-public.key

Creates a public key associated with a private key, useful for SSH login.
Key created without encryption.



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
