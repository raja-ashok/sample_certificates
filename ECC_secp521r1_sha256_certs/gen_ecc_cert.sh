#!/bin/bash

set -x
set -e

openssl ecparam -genkey -name secp521r1 -conv_form uncompressed -outform PEM -out ec.pem
openssl req -newkey ec:ec.pem -passout pass:123456 -sha256 \
    -subj "/C=IN/ST=Kar/L=En/O=ORG/OU=ORGU/CN=root/emailaddress=root@example.com" \
    -keyout rootkey_with_pass.pem -out rootreq.pem -config openssl.cnf
openssl x509 -req -in rootreq.pem -passin pass:123456 -sha256 \
    -extfile openssl.cnf -days 14600 -extensions v3_ca \
    -signkey rootkey_with_pass.pem -out rootcert.pem

openssl ecparam -genkey -name secp521r1 -conv_form uncompressed -outform PEM -out ec.pem
openssl req -newkey ec:ec.pem -passout pass:123456 -sha256 \
    -subj "/C=IN/ST=Kar/L=En/O=ORG/OU=ORGU/CN=serv/emailaddress=serv@example.com" \
    -keyout servkey_with_pass.pem -out serv_proxy_req.pem -config openssl.cnf
openssl x509 -req -in serv_proxy_req.pem -passin pass:123456 -sha256 \
    -extfile openssl.cnf -days 14600 -extensions usr_cert \
    -CA rootcert.pem -CAkey rootkey_with_pass.pem \
    -CAcreateserial -out servcert.pem

openssl ec -inform PEM -passin pass:123456 -in rootkey_with_pass.pem \
    -outform PEM -out rootkey.pem
openssl ec -inform PEM -passin pass:123456 -in servkey_with_pass.pem \
    -outform PEM -out servkey.pem

rm ec.pem rootreq.pem serv_proxy_req.pem *.srl *with_pass.pem

