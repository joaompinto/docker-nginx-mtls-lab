# docker-nginx-client-ssl-lab

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

Build & run the container
```sh
docker build -t nginx .
docker run -p8443:8443 nginx
```

In a new window:
```sh
curl -k --cert tmp/client1.crt --key tmp/client1.key -D- https://localhost:8443 -o /dev/null
```

You should see the certificate in the headers:
```
Server: nginx/1.12.1
Date: Mon, 14 Dec 2020 18:15:44 GMT
Content-Type: text/html
Content-Length: 4100
Last-Modified: Fri, 30 Aug 2019 10:45:47 GMT
Connection: keep-alive
ETag: "5d68fe5b-1004"
X-SSL-CLIENT-CERT: -----BEGIN CERTIFICATE-----
...
```
