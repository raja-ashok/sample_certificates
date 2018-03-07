#!/bin/bash

openssl ecparam -genkey -name prime256v1 -conv_form uncompressed -outform PEM -out ec.pem
openssl req -newkey ec:ec.pem -passout pass:123456 -sha256 -subj "/C=IN/ST=Kar/L=En/O=HTIPL/OU=VPP/CN=root/emailaddress=root@abc.com" -keyout rootkey.pem -out rootreq.pem -config openssl.cnf
openssl x509 -req -in rootreq.pem -passin pass:123456 -sha256 -extfile openssl.cnf -days 14600 -extensions v3_ca -signkey rootkey.pem -out rootcert.pem 

openssl ecparam -genkey -name prime256v1 -conv_form uncompressed -outform PEM -out ec.pem
openssl req -newkey ec:ec.pem -passout pass:123456 -sha256 -subj "/C=IN/ST=Kar/L=En/O=HTIPL/OU=VPP/CN=mptun_serv_proxy/emailaddress=mptunsp@abc.com" -keyout serv_proxy_key.pem -out serv_proxy_req.pem -config openssl.cnf
openssl x509 -req -in serv_proxy_req.pem -passin pass:123456 -sha256 -extfile openssl.cnf -days 14600 -extensions usr_cert -CA rootcert.pem -CAkey rootkey.pem -CAcreateserial -out serv_proxy_cert.pem

openssl x509 -inform PEM -in rootcert.pem -outform DER -out rootcert.der
openssl ec -inform PEM -passin pass:123456 -in rootkey.pem -outform DER -out rootkey.der
openssl x509 -inform PEM -in serv_proxy_cert.pem -outform DER -out serv_proxy_cert.der
openssl ec -inform PEM -passin pass:123456 -in serv_proxy_key.pem -outform DER -out serv_proxy_key.der

rm ec.pem rootreq.pem serv_proxy_req.pem
