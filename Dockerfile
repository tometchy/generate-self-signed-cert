FROM alpine:3.11.3
RUN apk add --no-cache openssl

COPY generate-self-signed-cert.sh .

ENTRYPOINT ["/bin/sh", "generate-self-signed-cert.sh"]