#!/bin/sh

if [ ! -d "/out" ]; then
  echo "Volume not set correctly, generated certficate will not be populated to host"
  mkdir /out
fi

if [ -z "$DOMAIN" ]
then
      echo "DOMAIN environment variable is not assigned, setting localhost";
      DOMAIN=localhost;
fi

if [ -z "$DAYS" ]
then
      echo "DAYS environment variable is not assigned, setting 365 days";
      DAYS=365;
fi

if [ -n "$PASSWORD" ]; then
  pkcs12_additional=" -passout pass:${PASSWORD}"
else
  echo "PASSWORD environment variable is not assigned, pfx file will contain NOT encrypted private key"
  pkcs12_additional=" -nodes -passout pass:"
fi

if [ -n "$ALT_DOMAINS" ]; then
  echo "Alternative names provided: ${ALT_DOMAINS}"
  req_additional=" -config custom-openssl.cnf"
  x509_additional=" -extensions v3_req -extfile custom-openssl.cnf"
  
  set_main="DNS.1 = ${DOMAIN}"
  echo "$set_main"
  echo "$set_main" >> custom-openssl.cnf
  
  domains=$(echo $ALT_DOMAINS | tr ";" "\n")
  i=2
  for domain in $domains
  do
    if [ "$domain" = "$DOMAIN" ]; then
      continue 
    fi
    set="DNS.${i} = ${domain}"
    echo "$set"
    echo "$set" >> custom-openssl.cnf
    i=$(expr $i + 1)
  done
else
  req_additional=""
  x509_additional=""
fi

openssl genrsa -out /out/${DOMAIN}.key 2048
openssl req -new -out /out/${DOMAIN}.csr -key /out/${DOMAIN}.key -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${DOMAIN}/emailAddress=${EMAIL}"${req_additional}
openssl x509 -req -days ${DAYS} -in /out/${DOMAIN}.csr -signkey /out/${DOMAIN}.key -out /out/${DOMAIN}.crt${x509_additional}
rm -f /out/${DOMAIN}.csr
openssl pkcs12 -export -out /out/${DOMAIN}.pfx -inkey /out/${DOMAIN}.key -in /out/${DOMAIN}.crt${pkcs12_additional}