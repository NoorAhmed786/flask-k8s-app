### Flask Kubernetes App

This is a simple Flask web application deployed on a Kubernetes cluster using Minikube (or any other Kubernetes setup). The application serves a "Hello, Kubernetes!" message when accessed via the exposed service.

### Prerequisites

Minikube or any Kubernetes cluster (GKE, EKS, AKS, etc.)

kubectl installed and configured to interact with your cluster

Docker installed to build and load Docker images

PowerShell (for Windows users)


### Setup and Installation

## Step 1: Clone the Repository

Clone this repository to your local machine:

``` git clone <repository-url>
cd flask-k8s-app
``` 

## Step 2: Build Docker Image

Ensure you are in the correct directory where the Dockerfile and app.py are located. Build the Docker image for your Flask app:

``` docker build -t flask-k8s-app:1.0 .
```

If you're using Minikube, load the Docker image into the Minikube environment:

```eval $(minikube -p minikube docker-env)
docker build -t flask-k8s-app:1.0 .
minikube image load flask-k8s-app:1.0
```
### Step 3: Start Minikube (If using Minikube)

Start Minikube to set up the local Kubernetes cluster:

``` minikube start
```
### Step 4: Apply Kubernetes Manifests

Ensure the Kubernetes manifests (deployment.yaml, service.yaml) are correct and apply them:

``` kubectl apply -f deployment.yaml -f service.yaml
```

This will create the deployment and service on your Minikube Kubernetes cluster.

### Step 5: Expose the Service

If you're not using Ingress, use kubectl port-forward to expose the application:

``` kubectl port-forward svc/flask-app-service 8080:80
```

Now you can access the app at http://localhost:8080.

### Common Issues and Troubleshooting
Issue 1: ErrImagePull Status for Pods

Problem: The pods are in the ErrImagePull state, indicating that Kubernetes cannot pull the Docker image.

Solution:

Ensure the image is available locally. Run:

docker images


If the image is not listed, rebuild it:

docker build -t flask-k8s-app:1.0 .


If you're using Minikube, load the image into the Minikube environment:

minikube image load flask-k8s-app:1.0


Reapply the Kubernetes manifests:

kubectl apply -f deployment.yaml -f service.yaml


Check pod status again:

kubectl get pods

Issue 2: Application Not Accessible After Port Forwarding

Problem: After running kubectl port-forward, you cannot access the application via http://localhost:8080.

Solution:

Verify Pod Status: Ensure the pods are running:

kubectl get pods


Verify Service: Ensure that the service is exposed correctly:

kubectl get svc


Check Logs: If the pod is running but you cannot access it, check the logs of the pod:

kubectl logs <pod-name>


Check if Flask is Binding to 0.0.0.0: Make sure the app.run() command in app.py is set to host='0.0.0.0':

app.run(host="0.0.0.0", port=5000)


Try Accessing via Container IP: If localhost doesn't work, try accessing the container IP:

kubectl describe pod <pod-name>

Issue 3: Minikube Fails to Start or Connect

Problem: Minikube fails to start or kubectl cannot connect to the cluster.

Solution:

Delete Existing Minikube Cluster: Sometimes starting fresh can help resolve issues:

minikube delete
minikube start


Check Minikube Logs: If Minikube fails to start, check the logs:

minikube logs --file=logs.txt


Check Docker: Ensure Docker is running properly. Restart Docker if needed.

Set Correct Kubernetes Context: Ensure that kubectl is configured to use Minikube:

kubectl config use-context minikube

Issue 4: Docker Image Pulling Errors (Networking Issues)

Problem: Docker is unable to pull the base images (like python:3.8-alpine).

Solution:

Check Your Network: Make sure you can access Docker Hub and pull images from the internet. If you're behind a proxy, configure Docker to use the proxy settings.

Manually Pull the Image:

docker pull python:3.8-alpine


Minikube Proxy: If you're using Minikube and it fails to pull images, ensure it has internet access. Try running Minikube with the --driver=docker flag to use Docker's local image registry:

minikube start --driver=docker

Clean Up

To delete the Minikube cluster after you're done:

minikube stop
minikube delete