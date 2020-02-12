#!/bin/sh

mkdir /out

openssl genrsa 2048 > /out/${DOMAIN}_private.pem
openssl req -x509 -new -key /out/${DOMAIN}_private.pem -out /out/${DOMAIN}_public.pem -passout pass:${PASSWORD} -subj "/C=${COUNTRY}/ST=${ST}/L=${L}/O=${ORGANIZATION}/OU=IT/CN=${DOMAIN}/emailAddress=tometchy@gmail.com"
openssl pkcs12 -export -in /out/${DOMAIN}_public.pem -inkey /out/${DOMAIN}_private.pem -out /out/${DOMAIN}.pfx -passout pass:${PASSWORD} 
openssl pkcs12 -in /out/${DOMAIN}.pfx -out /out/${DOMAIN}.crt -nokeys -passin pass:${PASSWORD}