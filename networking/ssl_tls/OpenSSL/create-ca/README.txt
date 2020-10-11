Description
-----------
Demo how to create test root and intermediate CA and how to sign a test server sertificate by CA.

Created artifacts:
- self signed root CA key and certificate
- intermadiate CA key and certificate signed by root CA
- server key and certificate signed by intermediate CA

Usage
-----
- init.sh
- create.sh

If you want to repeat creation call:
	- cleanup.sh
before.

INPORTANT:
	Check output of creations. All key-pair should be OK.

SEE ALSO:
	https://jamielinux.com/docs/openssl-certificate-authority/index.html
	
	