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

openssl genrsa -out /out/${DOMAIN}.key 2048
openssl req -new -out /out/${DOMAIN}.csr -key /out/${DOMAIN}.key -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${DOMAIN}/emailAddress=${EMAIL}" #-config custom-openssl.cnf
openssl x509 -req -days ${DAYS} -in /out/${DOMAIN}.csr -signkey /out/${DOMAIN}.key -out /out/${DOMAIN}.crt # -extensions v3_req -extfile custom-openssl.cnf
rm -f /out/${DOMAIN}.csr
openssl pkcs12 -export -out /out/${DOMAIN}.pfx -inkey /out/${DOMAIN}.key -in /out/${DOMAIN}.crt -passout pass:${PASSWORD}