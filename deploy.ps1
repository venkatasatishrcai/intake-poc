# Define variables with default values
param (
    [string]$IMAGE_NAME = "intake-poc",
    [string]$AWS_REGION = "us-east-1",
    [string]$AWS_ACCOUNT_ID = "202533538324",
    [string]$RELEASE_NAME = "intake-poc",
    [string]$NAMESPACE = "dev-frontend"
)
$ECR_REPO_NAME = "ga-smm/intake-poc"
# Authenticate Docker with AWS ECR
aws ecr get-login-password --region $AWS_REGION --profile cardi-venkata | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
# Build the Docker image
docker build -t $IMAGE_NAME .
# Check if the image exists
docker images | Select-String $IMAGE_NAME
# Tag the Docker image
docker tag "$IMAGE_NAME`:latest" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME`:latest"
# Push the Docker image to AWS ECR
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME`:latest"
# Delete existing Kubernetes deployment
kubectl delete deployment $RELEASE_NAME -n $NAMESPACE
# Upgrade or install Helm chart
helm upgrade --install $RELEASE_NAME ./helm -f ./helm/values.yaml --namespace $NAMESPACE
# Watch Kubernetes pods in the namespace
kubectl get pods -n $NAMESPACE -w