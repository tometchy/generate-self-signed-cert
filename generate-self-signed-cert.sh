#!/bin/sh

if [ ! -d "/out" ]; then
  echo "Volume not set correctly, generated certficate will not be populated to host"
  mkdir /out
fi

if [ -z "$DAYS" ]
then
      echo "DAYS environment variable is not assigned, setting 365 days";
      DAYS=365;
fi

openssl genrsa 2048 > /out/${DOMAIN}_private.pem
openssl req -x509 -new -key /out/${DOMAIN}_private.pem -out /out/${DOMAIN}_public.pem -passout pass:${PASSWORD} -days ${DAYS} -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${DOMAIN}/emailAddress=${EMAIL}"
openssl pkcs12 -export -in /out/${DOMAIN}_public.pem -inkey /out/${DOMAIN}_private.pem -out /out/${DOMAIN}.pfx -passout pass:${PASSWORD} 
openssl pkcs12 -in /out/${DOMAIN}.pfx -out /out/${DOMAIN}.crt -nokeys -passin pass:${PASSWORD}