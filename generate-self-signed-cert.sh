#!/bin/sh

mkdir /out

openssl genrsa 2048 > /out/localhost_private.pem
openssl req -x509 -new -key /out/localhost_private.pem -out /out/localhost_public.pem -passout pass:password -subj "/C=GB/ST=Nottingham/L=Nottinghamshire/O=SoftwareDeveloper.Blog/OU=IT/CN=localhost/emailAddress=tometchy@gmail.com"
openssl pkcs12 -export -in /out/localhost_public.pem -inkey /out/localhost_private.pem -out /out/localhost.pfx -passout pass:password 
openssl pkcs12 -in /out/localhost.pfx -out /out/localhost.crt -nokeys -passin pass:password