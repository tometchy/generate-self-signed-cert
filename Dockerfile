FROM alpine:3.11.3

RUN apk add --no-cache openssl

WORKDIR /generator

COPY generate-self-signed-cert.sh .
COPY custom-openssl.cnf /var/www/example.com/cert/custom-openssl.cnf

ENTRYPOINT ["/bin/sh", "generate-self-signed-cert.sh"]