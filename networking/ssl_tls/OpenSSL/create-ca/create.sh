DIR_ROOT=root
CFG_ROOT=openssl-root.conf
HOST_ROOT=test.root.lab.eu
SUBJECT_ROOT="/C=HU/ST=Veszprem/L=Balatonfured/O=Andtek/OU=Test Certificate Authority/CN=${HOST_ROOT}"
KEY_ROOT=$DIR_ROOT/private/ca.key.pem
CERT_ROOT=$DIR_ROOT/certs/ca.cert.pem
KEY_SIZE_ROOT=4096

DIR_INTERMEDIATE=intermediate
CFG_INTERMEDIATE=openssl-intermediate.conf
HOST_INTERMEDIATE=test.ca.lab.eu
SUBJECT_INTERMEDIATE="/C=HU/ST=Veszprem/L=Balatonfured/O=Andtek/OU=Test Certificate Authority/CN=${HOST_INTERMEDIATE}"
KEY_INTERMEDIATE=$DIR_INTERMEDIATE/private/intermediate.key.pem
CSR_INTERMEDIATE=$DIR_INTERMEDIATE/csr/intermediate.csr.pem
CERT_INTERMEDIATE=$DIR_INTERMEDIATE/certs/intermediate.cert.pem
KEY_SIZE_INTERMEDIATE=4096

HOST_SERVER=andtek.lab.hu
SUBJECT_SERVER="/C=HU/ST=Veszprem/L=Balatonfured/O=Andtek/OU=Development/CN=${HOST_SERVER}"
KEY_SIZE_SERVER=2048
KEY_SERVER=$DIR_INTERMEDIATE/private/server.key.pem
CSR_SERVER=$DIR_INTERMEDIATE/csr/server.csr.pem
CERT_SERVER=$DIR_INTERMEDIATE/certs/server.cert.pem

validateKeyPair() {
	if [ $# -ne 2 ]
	then
		echo "printModulus <private key> <public key>"
		exit
	fi
	PRIV=$1
	PUB=$2
	
	echo "Validating:"
	echo "    Private:   $PRIV"
	echo "    Public:    $PUB"
	
	if [ ! -f $PRIV ]
	then
		echo "$PRIV : private key not found"
		exit
	fi
	
	if [ ! -f $PUB ]
	then
		echo "$PUB : public key not found"
		exit
	fi
	
	echo "Getting modulus from private key: $PRIV"
	PRIV_MOD=`openssl rsa -noout -modulus -in $PRIV | openssl md5`
	
	echo "Getting modulus from public key: $PUB"
	PUB_MOD=`openssl x509 -noout -modulus -in $PUB | openssl md5`
	if [ "$PRIV_MOD" == "$PUB_MOD" ]
	then
		echo "Keypair OK"
	else
		echo "!!!!!!!!!!!!!! ERROR !!!!!!!!!!!!!!"
	fi
}

createRoot() {
	echo "###################################################################################"
	echo "ROOT"
	echo "###################################################################################"
	echo "Creating root key..."
	openssl genrsa -out $KEY_ROOT $KEY_SIZE_ROOT

	echo "Creating root certificate..."
	openssl req -config $CFG_ROOT -key $KEY_ROOT -new -x509 -days 7300 -sha256 -extensions v3_ca -out $CERT_ROOT -subj "$SUBJECT_ROOT"
	
	echo "Validating root artifacts..."
	validateKeyPair $KEY_ROOT $CERT_ROOT
}


createIntermediate() {
	echo "###################################################################################"
	echo "INTERMEDIATE"
	echo "###################################################################################"

	echo "Creating intermediate CA key..."
	openssl genrsa -out $KEY_INTERMEDIATE $KEY_SIZE_INTERMEDIATE

	echo "Creating intermediate CA certificate request..."
	openssl req -config $CFG_INTERMEDIATE -new -key $KEY_INTERMEDIATE -out $CSR_INTERMEDIATE -subj "$SUBJECT_INTERMEDIATE"

	echo "Signing intermediate certificate..."
	openssl ca -config $CFG_ROOT -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in $CSR_INTERMEDIATE -out $CERT_INTERMEDIATE -subj "$SUBJECT_INTERMEDIATE"

	echo "Validating intermediate artifacts..."
	validateKeyPair $KEY_INTERMEDIATE $CERT_INTERMEDIATE
}



createServer() {
	echo "###################################################################################"
	echo "SERVER"
	echo "###################################################################################"
	
	echo "Creating server key..."
	openssl genrsa -out $KEY_SERVER $KEY_SIZE_SERVER

	echo "Creating server certificate request..."
	openssl req -config $CFG_INTERMEDIATE -new -key $KEY_SERVER -out $CSR_SERVER -subj "$SUBJECT_SERVER"
	
	
	echo "Signing server certificate..."
	openssl ca -config $CFG_INTERMEDIATE -extensions server_cert -days 3650 -notext -md sha256 -in $CSR_SERVER -out $CERT_SERVER -subj "$SUBJECT_SERVER"
			
	echo "Validating server artifacts..."
	validateKeyPair $KEY_SERVER $CERT_SERVER
}


if [ ! -f $CFG_ROOT -o ! -f $CFG_INTERMEDIATE ]
then
	echo "Missing configuration file(s). Call init.sh before."
	exit
fi

createRoot
createIntermediate
createServer

