Background reading to this repository

https://darrylcauldwell.github.io/post/veba-knative/

# Setup Environment Variables

```bash
kubectl -n vmware-functions create secret generic veba-knative-mm-vrops \
  --from-literal=vropsFqdn=vrops.cork.local \
  --from-literal=vropsUser=admin \
  --from-literal=vropsPassword='VMware1!'
```

# Install Function

```bash
kubectl apply -f https://raw.githubusercontent.com/darrylcauldwell/veba-knative-mm/master/veba-knative-mm-enter.yml
```

# Update Function

```bash
git clone https://github.com/darrylcauldwell/veba-knative-mm-enter.git
cd veba-knative-mm-enter
```

Update handler.ps1 with required business logic

```bash
docker build --tag ghcr.io/darrylcauldwell/veba-ps-enter-mm:1.0 .
docker push ghcr.io/darrylcauldwell/veba-ps-enter-mm:1.0
```