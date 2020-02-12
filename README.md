## Creating image
From repository root directory run:
``` bash
docker build -t generateselfsignedcert .
```

# Running container
Run created image with proper environment variables:
``` bash
docker run -e 'DOMAIN=localhost' -e 'PASSWORD=password' -e 'ORGANIZATION=SoftwareDeveloper.Blog' -e 'C=PL' -e 'ST=Sanok' -e 'L=Posada' generateselfsignedcert 
```
