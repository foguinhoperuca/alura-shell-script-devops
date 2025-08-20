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

log-into-machine:
	kubectl -it <POD_NAME> -- bash

delete:
	kubectl delete -f service-app.yml
	kubectl delete -f deployment-app.yml
	kubectl delete -f service-backend.yml
	kubectl delete -f deployment-backend.yml
	kubectl delete -f service-statefulset.yml
	kubectl delete -f deployment-statefulset.yml

start:
	kubectl create -f deployment-backend.yml
	kubectl create -f service-backend.yml
	kubectl create -f deployment-app.yml
	kubectl create -f service-app.yml
	kubectl create -f permission-images.yml
	kubectl create -f permission-session.yml
	kubectl create -f deployment-statefulset.yml
	kubectl create -f service-statefulset.yml

alura-news-restart: delete start
	@date

build-docker-image:
	docker build -t foguinhoperuca/alura-news-app:v1 Dockerfile_app alura_news/
	docker tag alura-news foguinhoperuca/alura-news-app:v1
	docker push foguinhoperuca/alura-news-app:v1

	docker build -t foguinhoperuca/alura-news-sys:v1 Dockerfile_sys alura_news/
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

edit-kubernetes-resource:
	kubectl edit deployment backend-news-deployment

autoscale:
	kubectl autoscale deployment backend-news-deployment
	kubectl autoscale deployment backend-news-deployment --cpu-percent=20 --min=1 --max=10  # 3 minutes of interval to measure

hpa:
	kubectl get hpa backend-news-deployment

addons:
	minikube addons list
	minikube addons enable metric-server
	minikube addons disable metric-server
	minikube addons enable heapster
	minikube addons enable logviewer
