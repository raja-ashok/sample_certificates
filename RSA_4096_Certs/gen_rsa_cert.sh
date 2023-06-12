#!/bin/bash

openssl req -new -newkey rsa:4096 -passout pass:123456 -sha512 -subj "/C=IN/ST=Kar/L=En/O=ORG/OU=g/CN=root/emailaddress=root@example.com" -keyout root_key_with_pass.pem -out rootreq.pem -config openssl.cnf
openssl x509 -req -in rootreq.pem -passin pass:123456 -sha512 -extfile openssl.cnf -days 14600 -extensions v3_ca -signkey root_key_with_pass.pem -out rootcert.pem

openssl req -new -newkey rsa:4096 -passout pass:123456 -sha512 -subj "/C=IN/ST=Kar/L=En/O=ORG/OU=VPP/CN=serv/emailaddress=servrsa@example.com" -keyout serv_key_with_pass.pem -out serv_req.pem -config openssl.cnf
openssl x509 -req -in serv_req.pem -passin pass:123456 -sha512 -extfile openssl.cnf -days 14600 -extensions usr_cert -CA rootcert.pem -CAkey root_key_with_pass.pem -CAcreateserial -out serv_cert.pem

openssl req -new -newkey rsa:4096 -passout pass:123456 -sha512 -subj "/C=IN/ST=Kar/L=En/O=ORG/OU=VPP/CN=clnt/emailaddress=clntrsa@example.com" -keyout clnt_key_with_pass.pem -out clnt_req.pem -config openssl.cnf
openssl x509 -req -in clnt_req.pem -passin pass:123456 -sha512 -extfile openssl.cnf -days 14600 -extensions usr_cert -CA rootcert.pem -CAkey root_key_with_pass.pem -CAcreateserial -out clnt_cert.pem

openssl x509 -inform PEM -in rootcert.pem -outform DER -out rootcert.der
openssl rsa -inform PEM -passin pass:123456 -in root_key_with_pass.pem -outform DER -out rootkey.der
openssl x509 -inform PEM -in serv_cert.pem -outform DER -out serv_cert.der
openssl rsa -inform PEM -passin pass:123456 -in serv_key_with_pass.pem -outform DER -out serv_key.der
openssl rsa -inform PEM -passin pass:123456 -in serv_key_with_pass.pem -outform PEM -out serv_key.pem
openssl x509 -inform PEM -in clnt_cert.pem -outform DER -out clnt_cert.der
openssl rsa -inform PEM -passin pass:123456 -in clnt_key_with_pass.pem -outform DER -out clnt_key.der
openssl rsa -inform PEM -passin pass:123456 -in clnt_key_with_pass.pem -outform PEM -out clnt_key.pem

rm *req.pem *.srl
