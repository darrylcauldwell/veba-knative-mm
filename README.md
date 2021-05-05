Background reading to this repository

https://darrylcauldwell.github.io/post/veba-knative/

# Install Function

```bash
# SSH to VEBA appliance
kubectl apply -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-service.yml
kubectl apply -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-trigger.yml
```

# Update Function

1. Clone to local repository

```bash
git clone https://github.com/darrylcauldwell/veba-knative-mm.git
```

2. Update *-handler.ps1 with required business logic

3. Create new local image and push to GitHub Container Registry incrementing the version in tag

```bash
# Authenticate if necessary with docker login
docker build --tag ghcr.io/darrylcauldwell/veba-ps-enter:0.2 enter-Dockerfile
docker push ghcr.io/darrylcauldwell/veba-ps-enter:0.2
```

4. Once container uploaded remove and recreate function

```bash
# SSH to VEBA appliance
kubectl delete -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-service.yml
kubectl delete -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-trigger.yml
kubectl apply -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-service.yml
kubectl apply -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/enter-mm-trigger.yml
```