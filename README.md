# Docker sandbox for playing with asterisk 18

Change the dockerfile and the etc/ content to play with asterisk compilation and setup.

All the configuration placed in ./etc/ will be pushed to the container, this image is using letsencrypt wildcard certificates for webrtc, you can create your own certificates running: 
```DOMAIN=*.mylovely.doman.com EMAIL=you@yourdomain.com make create-ssl-cert```


## Usage:
Use ```make``` to build and run the tests.:
 ```make build```                  # creates docker image
 ```make container-run```          # create the container using the latest image
 ```make container-delete```       # delete the container 
 ```make container-shell```        # open a bash shell into the running container 
 ```make container-asterisk-cli``` # open an astersk shell into the running container
