#!/bin/sh

# https://gist.github.com/mtigas/952344

set -eu

mkdir -p tmp

# Requires on Windows GitBath
export MSYS_NO_PATHCONV=1

## Create Root CA Private key
openssl genrsa -out tmp/rootCA.key 2048

## Generate the root CA certificate
openssl req -new -x509 \
    -key tmp/rootCA.key \
    -out tmp/rootCA.crt \
    -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=mydomain.com"

# Generate a server key
openssl genrsa -out tmp/mydomain.com.key 2048

# Create a CSR for the server
openssl req \
    -new \
    -sha256 \
    -key tmp/mydomain.com.key \
    -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=mydomain.com" -out tmp/mydomain.com.csr

# Create the server certificate
openssl x509 -req \
    -in tmp/mydomain.com.csr \
    -CA tmp/rootCA.crt \
    -CAkey tmp/rootCA.key \
    -CAcreateserial \
    -out tmp/mydomain.com.crt \
    -days 500 \
    -sha256


# Generate the client private certificate
openssl genrsa -out tmp/client1.key 2048


# generate the CSR
openssl req -new \
    -key tmp/client1.key  \
    -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=client.mydomain.com" \
    -config ssl.conf \
    -out tmp/client1.csr

# issue this certificate, signed by the CA root we made in the previous section
openssl x509 -req -days 3650 -in tmp/client1.csr -CA tmp/rootCA.crt -CAkey tmp/rootCA.key -set_serial 01 -out tmp/client1.crt
