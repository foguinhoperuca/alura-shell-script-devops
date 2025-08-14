.PHONY:
	get

get:
	kubectl get pods
	kubectl get deployments
	kubectl get services

describe:
	kubectl describe pods app-news

docker-ps:
	docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"

create-app:
	kubectl create -f application.yml # pod

delete-pod:
	kubectl delete pod <POD_NAME>

dashboard:
	minikube dashboard

service-url:
	minikube service <SERVICE_NAME> --url # url optional - just get url. Without it show data into cli and open url in browser.

delete:
	kubectl delete -f service-app.yml
	kubectl delete -f deployment-app.yml
	kubectl delete -f service-sys.yml
	kubectl delete -f deployment-sys.yml

start:
	kubectl create -f deployment-sys.yml
	kubectl create -f service-sys.yml
	kubectl create -f deployment-app.yml
	kubectl create -f service-app.yml

alura-news-restart: delete start
	@date

build-docker-image:
	docker build -t image-app Dockerfile_app
	docker tag alura-news foguinhoperuca/alura-news-app:v1
	docker push foguinhoperuca/alura-news-app:v1

	docker build -t image-sys Dockerfile_sys
	docker tag alura-news foguinhoperuca/alura-news-sys:v1
	docker push foguinhoperuca/alura-news-sys:v1

class_02-04:
	kubectl create -f deployment-news.yml
	kubectl create -f deployment-sys.yml

class_02-07_01:
	kubectl create -f service-news.yml
	kubectl create -f service-sys.yml

class_02-07_02:
	kubectl exec -it <POD_NAME> bash # do not work anymore without -- in the end
	kubectl exec -it <POD_NAME> -- bash

manually_deployment:
	kubectl expose deployment nginx-deploy --name=nginx-service --type=LoadBalancer --port=8080 --target-port=80

deployment_in_cli:
	kubectl create deployment nginx-deploy --image=nginx
	kubectl scale --replicas=3 deployment/nginx-deploy
