.PHONY:
	get-pods

get:
	kubectl get pods
	kubectl get deployments
	kubectl get services

create-app:
	kubectl create -f application.yml

describe:
	kubectl describe pods app-news

dashboard:
	minikube dashboard

service-url:
	minikube service <POD_NAME> --url # url optional - just get url. Without it show data into cli and open url in browser.

delete:
	kubectl delete -f deployment.yml
	kubectl delete -f service.yml
	kubectl delete pod <POD_NAME>

class_02-04:
	kubectl create -f deployment.yml

class_02-07_01:
	kubectl create -f service.yml

class_02-07_02:
	kubectl exec -it <POD_NAME> bash # do not work anymore without -- in the end
	kubectl exec -it <POD_NAME> -- bash

manually_deployment:
	kubectl expose deployment nginx-deploy --name=nginx-service --type=LoadBalancer --port=8080 --target-port=80

deployment_in_cli:
	kubectl create deployment nginx-deploy --image=nginx
	kubectl scale --replicas=3 deployment/nginx-deploy
