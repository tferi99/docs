DIR_ROOT=root
DIR_INTERMEDIATE=intermediate

#----------------------------- root -----------------------
cat openssl-root.temp openssl-common.temp > openssl-root.conf

mkdir $DIR_ROOT

cd $DIR_ROOT
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

cd ..

#----------------------------- intermediate -----------------------
cat openssl-intermediate.temp openssl-common.temp > openssl-intermediate.conf

mkdir $DIR_INTERMEDIATE

cd $DIR_INTERMEDIATE
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber
