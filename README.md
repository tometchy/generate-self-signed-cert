## Creating image
From repository root directory run:
``` bash
docker build -t generate-self-signed-cert .
```

# Running container
Run created image with proper environment variables and mount directory from host to _/out_ directory in container, for example:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -e 'O=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Podkarpackie' -e 'L=Sanok' -e 'OU=IT' -e 'EMAIL=Contact@SoftwareDeveloper.Blog' -e 'DAYS=3650' -v /home/tometchy/Downloads/cert:/out generate-self-signed-cert 
```
Remember to create mount directory on host before running.

## Note1
You can set alternative domain names with _ALT_DOMAINS_ environment variable, separated with semicolon (_;_), for example:
``` bash
docker run -e 'DOMAIN=example.com' -e 'ALT_DOMAINS=www.example.com' -e 'PASSWORD=password' -e 'O=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Podkarpackie' -e 'L=Sanok' -e 'OU=IT' -e 'EMAIL=Contact@SoftwareDeveloper.Blog' -e 'DAYS=3650' -v /home/tometchy/Downloads/cert:/out generate-self-signed-cert 
```

## Note2
You can skip parameters which you don't need. For example:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -v /home/tometchy/Downloads/cert:/out generate-self-signed-cert 
```

will produce certificate, but you will see warning messages, for example:
```
DAYS environment variable is not assigned, setting 365 days
req: No value provided for Subject Attribute C, skipped
req: No value provided for Subject Attribute ST, skipped
req: No value provided for Subject Attribute L, skipped
req: No value provided for Subject Attribute O, skipped
req: No value provided for Subject Attribute OU, skipped
req: No value provided for Subject Attribute emailAddress, skipped
```

You can even skip setting password, but then **certificate will contain NOT encrypted private key**.

## Note3
To use it on Windows, you must first enable file sharing for your host drive.  
Open _Docker settings > Resources > File sharing_ and choose local drive which you to mount to container.
Then restart Docker (even if button says _Apply and restart_).  
At the moment of writing you must use slashes instead of backslashes in Windows path, for example:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -e 'O=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Podkarpackie' -e 'L=Sanok' -e 'OU=IT' -e 'EMAIL=Contact@SoftwareDeveloper.Blog' -e 'DAYS=3650' -v C:/Users/tometchy/Desktop/cert:/out generate-self-signed-cert 
```

## Note4
In case of problems with certificate, there is human readable version of certificate in .crt.txt file, so you can investigate and even
compare certificates with diff tool such as _Meld_.

## Note5
By default this script will generate certificate without KeyUsage property, because it has been observed, that for development
purposes this way it works better, as noted in official _openssl.cnf_ file:
> Key usage: this is typical for a CA certificate. However since it will
> prevent it being used as an test self-signed certificate it is best
> left out by default.

If you want to add key usage, uncomment _keyUsage_ in proper section of _custom-openssl.cnf_ file,
depending on certificate type, for example if you use alternative domain names, then you should edit _[ v3_req ]_ section.
If you don't know which section to edit, simply uncomment every _keyUsage_ in whole file :)  
Remember to **rebuild image** after changing this file.