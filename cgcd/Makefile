.PHONY:
	class01-docker-run

class01.08-docker-run:
	docker -d run ubuntu
	docker ps -a

class02.01-container-analysis:
	docker ps -a
	docker run ubuntu sleep 1d

class02.03-interact-container:
	docker exec -it <CONTAINER_ID> bash

class02.03-docker-start-stop:
	docker start <CONTAINER_ID>
	# -t=0 force stop a la kill -9
	docker stop -t=0 <CONTAINER_ID>

class02.03-docker-pause:
	docker pause <CONTAINER_ID>
	docker unpause <CONTAINER_ID>

docker02.03-docker-rm:
	# --force is optional
	docker rm --force <CONTAINER_ID>

class02.05-map-port:
	# --port is <HOST:CONTAINER>
	docker run -d -p 8081:80 --name static-site-container dockersamples/static-site
	docker stop $(docker container ls -q)

class03.01-images-explore:
	docker pull ubuntu
	docker image ls
	# history can be the image id too
	docker history ubuntu
	docker inspect ubuntu

# TODO adapt commands to run inside Makefile
class03.03-alurabooks-frontend:
	cd alurabooks-frontend
	docker stop $(docker ps -aq)
	docker container rm $(docker container ps -aq)
	docker image rm $(docker image ls foguinhoperuca/allbooks -q)
	rm -f alurabooks-frontend/Dockerfile
	cp ../Dockerfile_alurabooks-frontend Dockerfile
	docker build -t foguinhoperuca/all-books:1.1 .
	docker run -d -p 8095:3000 foguinhoperuca/allbooks:1.1

class03.06-dockerhub:
	docker push foguinhoperuca/allbooks:1.1
	docker tag foguinhoperuca/allbooks:1.1 foguinhoperuca/allbooks:1.1

class04.01-docker-mount:
	docker run -it --mount type=bind,source=/home/alura/volume-docker,target=/app ubuntu bash

class04.03-docker-volume:
	docker volume create cgcd
	docker volume inspect cgcd
	docker run -it --mount source=cgcd,target=/app ubuntu bash

class04.05-docker-tmpfs:
	docker run -it --tmpfs=/app ubuntu bash
