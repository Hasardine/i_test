# i_test

## Checklist
- [x] Create IXXX account
- [x] Create a K8S ckuster with 2 nodes
- [x] Publish an Nginx image with 3 replicas
- [x] Personalise the index page of the image
- [x] Produce a repeatable TF template
- [x] Publish TF/DOCKERFILE/K8S.YAML in public repo

## Tools & doc :
Cloud provider : IONOS
Terraform : Terraform Cloud
Private repo for images : IONOS COntainer registery

- TF : https://registry.terraform.io/providers/ionos-cloud/ionoscloud/latest/docs/resources/container_registry
- IONOS doc : https://docs.ionos.com/reference

## On console :
Get token : Management > Token

## K8S cluster (with TF first)
TF file 

From VM (use personal rds-test-gds)
```shell
sudo apt update
sudo apt upgrade

curl -LO https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl

chmod +x kubectl 
mv -f kubectl /usr/local/bin  
mkdir -p $HOME/.kube  
#upload file to /home/cloud
cd /home/cloud
mv -f kubeconfig.json $HOME/.kube/config

kubectl cluster-info
```

Use dockerfile created on the VM

install docker first - https://docs.docker.com/engine/install/ubuntu/ 
```shell
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker run hello-world
```

```shell
docker build -t bjm/nginx-bjm .
docker login container-registry-bjm-swr.cr.de-fra.ionos.com -u bjm -p xxxxxxxxxxxxxxxxxxxxxxxxxxxx
docker tag bjm/nginx-bjm container-registry-bjm-swr.cr.de-fra.ionos.com/bjm/nginx-bjm
docker push container-registry-bjm-swr.cr.de-fra.ionos.com/bjm/nginx-bjm
```

Use YAML file created :

```shell
kubectl create secret docker-registry my-registry-secret \
  --docker-server=container-registry-bjm-swr.cr.de-fra.ionos.com \
  --docker-username=bjm \
  --docker-password=xxxxxxxxxxxxxxxxxxxxx 
```

```shell
kubectl apply -f nginx-deployment.yaml
kubectl get pods
kubectl get service
kubectl describe pods
```

### Question to ask :
- No IP for control plane/master node ?
- SSH to nodes ?
- Switch off nodes ?
- Error occurred while fetching k8s.Unauthorized... ?