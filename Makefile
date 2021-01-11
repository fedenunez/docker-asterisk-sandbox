 
 
IMAGE_NAME:=asterisk-ubuntu20.04
TEST_DOCKER_NAME:=$(IMAGE_NAME)-test
PWD=$(shell pwd)
BUILD_CERT_FOLDER:=./build_ssl_cert

.PHONY: build container-run container-delete container-shell create-ssl-cert


build:
	docker build --tag $(IMAGE_NAME) . 

container-run:
	docker run -ti --name $(TEST_DOCKER_NAME) -p 5061:5060 -p 5061:5060/udp -p 8089:8089 -P $(IMAGE_NAME)

container-delete:
	docker rm -f $(TEST_DOCKER_NAME)

container-shell:
	docker exec -ti $(TEST_DOCKER_NAME) /bin/bash

container-asterisk-cli:
	docker exec -ti $(TEST_DOCKER_NAME) /sbin/asterisk -rvvvvvvvv

create-ssl-cert:
	@echo "Current env variables EMAIL='$(EMAIL)' and DOMAIN='$(DOMAIN)'"
	docker run -it --rm --name certbot \
							-v "$(PWD)/$(BUILD_CERT_FOLDER)/etc/letsencrypt/:/etc/letsencrypt/archive" \
							certbot/certbot \
							 certonly --manual --preferred-challenges=dns --email $(EMAIL) --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d $(DOMAIN)
	@echo "REMEMBER to manually coppy your certs from $(BUILD_CERT_FOLDER)/* to the etc/asterisk/keys before building your asterisk docker!"
	#../certbot/etc/letsencrypt/archive/
							#-v "$(PWD)/$(BUILD_CERT_FOLDER)/var/lib/letsencrypt:/var/lib/letsencrypt" \

	
