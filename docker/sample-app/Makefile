.PHONY: docker-run

IMAGE_VERSION="1.0.0"
IMAGE_TAG="jeff/node-sample:$IMAGE_VERSION"

DATA_DIR="/home/jefferson/universal/data/docker/"
DEFAULT_VOLUME_DIR=""

docker-build:
	@clear
	@date
	docker build -t $IMAGE_TAG
	@date

docker-run:
	@clear
	@date
	docker run -d -p 8081:3000 jeff/node-sample:1.0.0
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

docker-volume:
	@clear
	@date
	docker run -it -v /home/jefferson/universal/data/docker/alura-docker:/app ubuntu bash

docker-mount:
	@clear
	@date
	docker run -it --mount type=bind,source=#DATA_DIR/alura-docker,tagert=/app ubuntu bash

docker-mount-volume:
	@clear
	@date
	docker run -it --mount source=alura,target=/app ubuntu bash
