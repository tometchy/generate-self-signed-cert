## Creating image
From repository root directory run:
``` bash
docker build -t generate-self-signed-cert .
```

# Running container
Run created image with proper environment variables and mount directory from host to _/out_ directory in container:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -e 'O=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Sanok' -e 'L=Posada' -e 'OU=IT' -e 'EMAIL=Contact@SoftwareDeveloper.Blog' -v /home/tometchy/Downloads/cert:/out generate-self-signed-cert 
```
Remember to create mount directory on host before running.

## Note1
You can skip parameters which you don't need. For example:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -v /home/tometchy/Downloads/cert:/out generate-self-signed-cert 
```
Will produce certificate, but you will see these messages:
```
Generating RSA private key, 2048 bit long modulus (2 primes)
.................................................................+++++
.......+++++
e is 65537 (0x010001)
req: No value provided for Subject Attribute C, skipped
req: No value provided for Subject Attribute ST, skipped
req: No value provided for Subject Attribute L, skipped
req: No value provided for Subject Attribute O, skipped
req: No value provided for Subject Attribute OU, skipped
req: No value provided for Subject Attribute emailAddress, skipped
```

## Note2
To use it on Windows, you must first enable file sharing for your host drive.  
Open _Docker settings > Resources > File sharing_ and choose local drive which you to mount to container.
Then restart Docker (even if button says _Apply and restart_).  
At the moment of writing you must use slashes instead of backslashes in Windows path, for example:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -e 'O=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Sanok' -e 'L=Posada' -e 'OU=IT' -e 'EMAIL=contact@SoftwareDeveloper.Blog' -v C:/Users/tometchy/Desktop/cert:/out generate-self-signed-cert 
```
