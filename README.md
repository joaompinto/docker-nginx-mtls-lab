# docker-nginx-mtls-lab

This repository provides a laboratory setup that demonstrates how to extract the SSL client certificate using nginx.

## Requirements
 - Docker (Linux/Windows)
 - Bash or GitBash

# Generate SSL Keys

The gen_ssl_keys.sh script will generate both the server keys and a sample ssl client key using SAN.

In the docker host:
```sh
sh ./gen-ssl-keys.sh
```
Create the docker network for the lab setup
```
docker network create nginx-lab --subnet=172.19.0.0/16
```

Build & run the nginx container
```sh
docker build -t nginx -f Dockerfile.nginx .
docker run \
    --network  nginx-lab \
    --ip 172.19.0.2 \
    --name nginx \
    --publish 8443:8443 \
    nginx
```

Build & run the quickweb container
```sh
docker build -t quickweb -f Dockerfile.quickweb .
docker run \
    --network nginx-lab \
    --ip 172.19.0.3 \
    --name quickweb \
    --publish 8080:8080 \
    quickweb
```

In a new window:
```sh
curl -k --cert tmp/client1.crt --key tmp/client1.key -D- https://localhost:8443 -o /dev/null
```

You should see the certificate in the headers:
```
Server: nginx/1.12.1
Date: Mon, 14 Dec 2020 18:30:42 GMT
Content-Type: text/html
Content-Length: 4100
Last-Modified: Fri, 30 Aug 2019 10:45:47 GMT
Connection: keep-alive
ETag: "5d68fe5b-1004"
X-SSL-CLIENT-CERT: MIIDCTCCAfECAQEwDQYJKoZIhvcNAQELBQAwRzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRQwEgYDVQQKDAtNeU9yZywgSW5jLjEVMBMGA1UEAwwMbXlkb21haW4uY29tMB4XDTIwMTIxNDE4MTQxNFoXDTMwMTIxMjE4MTQxNFowTjELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRQwEgYDVQQKDAtNeU9yZywgSW5jLjEcMBoGA1UEAwwTY2xpZW50Lm15ZG9tYWluLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN66z3vnAHp8G7gYyI5fE6L98T1WI00nQn1C4V9HAY2WSeiM0MAf63AANpnKeUMoR4A6D897xGLONPVaFfpMnlhAWvVBox9QGt42CIX8oDOhqiHj3LfpqhXjl05Yy+WXzmfb5+QTFTiAEhlHUFiEnUDBzM1SctJK53L4SoWOPF6aSaG9whguFEcRc4SdwZFk08pdQQzYXNd/R9dooXBjzFSX35FUZFb8ATC35zMMxvG8dvNIv35ttdgfpTR/nCZsqujRnh60pH6aIPGXzkBhSdmTdM+fPhgbAxghX8xK+PfCHkbNkYm00FHula5umdNR9GfiKrRU9r2gQLv07+1gfkcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAVvCKyXyqp8VvX4bGUsQ5mcHo/1sAJ/HwG9WHR47tRZo3YS7bDJ5Jn+okPtUsmCGywJFJBOj8KAtLRnoKESYRTvDnYMHy9QHiryoUYcy5Xsq0hew3dGRYnrTK7ES0Ms74/QGcWw9m316E6YtbMKlsfNSZ9ggp3WUcFBaN507ibPTZBvXneQ0DBa4g61lupoZzB/isBdtc29NT0wE8DiKA7QajQDn5xyBq6he9KfvFG0BxskIomXRJWHFkBhUFC9kUQkrWzZSZX6iYzIqR5deUV2vNjXeVyGYNmXYZ2WusOjDf6DW/vE+KYPgBnMF/fnHLvxnX+H//+IaFB1NPjjuKMQ==
...
```
