
# Docker Build & Deploy

docker build -t smm-web-intake-local .


If build image from mac and deploying in EKS
```
docker buildx build --platform linux/amd64 -t smm-web-intake .
```

docker run -p 80:80 smm-web-intake-local


# Push to ECR
Docker Login - ECR
```
aws ecr get-login-password --region us-east-1 --profile cardi | docker login --username AWS --password-stdin 202533538324.dkr.ecr.us-east-1.amazonaws.com
```


Tag & Push
```
docker tag smm-web-intake:latest 202533538324.dkr.ecr.us-east-1.amazonaws.com/ga-smm/smm-web-intake:latest

docker push 202533538324.dkr.ecr.us-east-1.amazonaws.com/ga-smm/smm-web-intake:latest
```
## Deployment

Deploy application
```
helm upgrade --install ga-smm-web-intake ./helm -f ./helm/values.yaml --namespace dev-frontend
```

Verify the pods are running
```
kubectl get pods -n dev-frontend -w
```

Verify the ingress
```
kubectl get ingress ga-smm-web-intake-ingress -n dev-frontend
```

Debug Commands
```
kubectl describe ingress ga-smm-web-intake-ingress -n dev-frontend
kubectl delete ingress ga-smm-web-intake-ingress -n dev-frontend
kubectl rollout restart -n dev-frontend deployment ga-smm-web-intake  
kubectl get deployment -n dev-frontend
kubectl describe deployment ga-smm-web-intake -n dev-frontend

kubectl delete deployment ga-smm-web-intake -n dev-frontend
```
