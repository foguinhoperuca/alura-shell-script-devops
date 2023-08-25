.PHONY: docker-run

IMAGE_VERSION=1.0.0
IMAGE_TAG=jeff/node-sample:$(IMAGE_VERSION)

DATA_DIR=/home/jefferson/universal/data/docker/
APP_PORT=6000
LOCALHOST_PORT=8081
DEFAULT_VOLUME_DIR=""

# Lab: deploy/run
deploy-lab:
	@clear
	@date
	rm docker.patch
	git diff HEAD . > docker.patch
	scp docker.patch admlocal@172.16.1.36:/home/admlocal/universal/projects/pms/alura/devops/alura-shell-script-devops/docker/sample-app/
	@date

build-lab:
	@clear
	@date
	git restore .
	git apply docker.patch
	git status .
	@date

# Alura
docker-build:
	@clear
	@date
	docker build -t $(IMAGE_TAG) .
	@date

docker-run:
	@clear
	@date
	docker run -d -p $(LOCALHOST_PORT):$(APP_PORT) $(IMAGE_TAG) .
	@date

docker-stop-all:
	@clear
	@date
	docker stop $(docker container ls -q)
	@date

docker-remove-containers:
	@clear
	@date
	docker container rm $(docker container ls -aq)
	@date

docker-remove-images:
	@clear
	@date
	docker rmi $(docker image ls -aq)

docker-mount:
	@clear
	@date
	docker run -it --mount type=bind,source=$DATA_DIR/alura-docker,tagert=/app ubuntu bash

docker-volume:
	@clear
	@date
	docker run -it -v /home/jefferson/universal/data/docker/alura-docker:/app ubuntu bash

docker-volume-mount:
	@clear
	@date
	docker run -it --mount source=alura,target=/app ubuntu bash

docker-tmpfs:
	@clear
	@date
	docker run -it --tmpfs=/app ubuntu bash

docker-tmpfs-mount:
	@clear
	@date
	docker run -it --mount type=tmpfs,destination=/app ubuntu bash

docker-inspect:
	@clear
	@date
	docker inspect $(docker container ls -q)

docker-network:
	@clear
	@date
	docker network inspect $(docker network ls -q)

docker-network-create:
	@clear
	@date
	docker network create --driver bridge custom-pms-bridge

docker-create-mongo:
	@clear
	@date
	docker pull mongo:4.4.6
	docker pull aluradocker/alura-books:1.0
	@echo "---"
	docker stop $$(docker container ls -q)
	docker container rm $$(docker container ls -aq)
	@echo "---"
	docker run -d --network custom-pms-bridge --name meu-mongo mongo:4.4.6
	docker run -d --network custom-pms-bridge -p 3000:3000 --name alurabooks aluradocker/alura-books:1.0
	@echo "---"
	docker ps -a
	@date

docker-compose-up:
	@clear
	@date
	docker compose up -d
	@date

docker-compose-list:
	@clear
	@date
	docker compose ps
	@date

docker-compose-down:
	@clear
	@date
	docker compose down
	@date
