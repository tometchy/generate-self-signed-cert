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
  privateKeyEncryption=" -passout pass:${PASSWORD}"
else
  echo "PASSWORD environment variable is not assigned, pfx file will contain NOT encrypted private key"
  privateKeyEncryption=" -nodes -passout pass:"
fi

if [ -n "$ALT_DOMAINS" ]; then
  echo "Alternative names provided: ${ALT_DOMAINS}"
  req_additional=" -extensions v3_req  -config /var/www/example.com/cert/custom-openssl.cnf"
  
  set_main="DNS.1 = ${DOMAIN}"
  echo "$set_main"
  echo "$set_main" >> /var/www/example.com/cert/custom-openssl.cnf
  
  domains=$(echo $ALT_DOMAINS | tr ";" "\n")
  i=2
  for domain in $domains
  do
    if [ "$domain" = "$DOMAIN" ]; then
      continue 
    fi
    set="DNS.${i} = ${domain}"
    echo "$set"
    echo "$set" >> /var/www/example.com/cert/custom-openssl.cnf
    i=$(expr $i + 1)
  done
  set="DNS.${i} = ${DOMAIN}"
  echo "$set"
  echo "$set" >> /var/www/example.com/cert/custom-openssl.cnf
else
  req_additional=""
fi

openssl genrsa -out /out/${DOMAIN}.key 2048
openssl req -x509 -new -key /out/${DOMAIN}.key -out /out/${DOMAIN}.crt${privateKeyEncryption} -days ${DAYS} -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${DOMAIN}/emailAddress=${EMAIL}"${req_additional}
openssl pkcs12 -export -in /out/${DOMAIN}.crt -inkey /out/${DOMAIN}.key -out /out/${DOMAIN}.pfx${privateKeyEncryption}
openssl x509 -in /out/${DOMAIN}.crt -out /out/${DOMAIN}.pem -outform PEM
openssl x509 -text -in /out/${DOMAIN}.crt > /out/${DOMAIN}.crt.txt
