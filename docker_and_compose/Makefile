.PHONY:
	01.13_docker-hello-world:

01.13_docker-hello-world:
	docker run hello-world

01.15_play-with-docker-online:
	firefox https://labs.play-with-docker.com/

02.01_docker-basics:
	docker ps -a
	docker run -it ubuntu
	docker start -a -i <ID_CONTAINER>
	docker stop <ID_CONTAINER>

02.02_docker-states:
	docker container prune
	docker rmi hello-world

02.05_docker-exercise:
	# name can replace <ID_CONTAINER>
	docker run -d -P -e AUTHOR="Jeff" --name happy-site dockersamples/static-site
	docker port <ID_CONTAINER>
	docker stop -t 0 $(docker ps -q)

03.01_docker-volume:
	docker run -v "/var/www" ubuntu

03.04_docker-run-code:
	docker run -d -p 8084:3000 -v "$(pwd):/var/www" -w "/var/www" node npm start

04.01_docker_file:
	docker build -f Dockerfile -t foguinhoperuca/docker_and_compose .
	docker run -d -p 1234:3000 foguinhoperuca/docker_and_compose

04.03_docker-hub:
	docker login
	docker push foguinhoperuca/docker_and_compose

05.01_docker-network:
	docker network create --driver bridge alura-network
	docker run -it --name alura-ubuntu-frontend --network alura-network ubuntu
	docker run -it --name alura-ubuntu-backend --network alura-network ubuntu

05.04_docker-network-exercise:
	docker pull douglasq/alura-books:cap05
	docker pull mongo
	docker network create --driver bridge alura-docker-and-compose
	# mongo container *MUST* be called meu-mongo
	docker run -d --name meu-mongodb --network alura-docker-and-compose mongo
	docker run --network alura-docker-and-compose -d -p 8090:3000 douglasq/alura-books:cap05

06.07_docker-compose:
	docker-compose build
	docker-compose up -d
	docker-compose ps
	docker exec -it alura-books-1 ping node2
