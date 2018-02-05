#!/bin/bash
mkdir /certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /certs/domain.key -x509 -days 365 -out /certs/domain.crt
cp /certs/domain.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust
systemctl restart docker
docker run -d --name=registry -v /certs:/certs -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key -p 5001:5000 registry:2

