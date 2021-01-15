# Dockerhub rate limit work around

Docker hub rate limit can be anonying when job scale to multiple containers.

## Create htpasswd

```bash
sudo apt install apache2-utils # install htpasswd
htpasswd -Bbn <username> <password> > auth/htpasswd # test test as default
base64 auth/htpasswd # base64 encode auth/htpasswd to use in k8s secret
```

## Install ingress nginx on bare metal

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/baremetal/deploy.yaml
# check if ingress nginx ready
kubectl get pods -n ingress-nginx \
  -l app.kubernetes.io/name=ingress-nginx --watch
kubectl get svc -n ingress-nginx # get nodeport service number

NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.97.50.61    <none>        80:31131/TCP,443:30227/TCP   23h
ingress-nginx-controller-admission   ClusterIP   10.99.98.192   <none>        443/TCP                      23h
```

## Install registry service in docker-cache namespace

```bash
kubectl apply -f k8s_deploy/
# check pod, service, ingress readiness
kubectl get pods -n docker-cache
kubectl get svc -n docker-cache
kubectl get ing -n docker-cache
# add to /etc/hosts 10.172.143.20 is one node ip of my cluster
10.172.143.20 registry.openpai.org
# test if available
curl -vvv -I http://registry.openpai.org:31131/v2/

*   Trying 10.172.143.20...
* Connected to registry.openpai.org (10.172.143.20) port 31131 (#0)
> HEAD /v2/ HTTP/1.1
> Host: registry.openpai.org:31131
> User-Agent: curl/7.47.0
> Accept: */*
>
< HTTP/1.1 401 Unauthorized
HTTP/1.1 401 Unauthorized
< Date: Thu, 14 Jan 2021 10:08:19 GMT
Date: Thu, 14 Jan 2021 10:08:19 GMT
< Content-Type: application/json; charset=utf-8
Content-Type: application/json; charset=utf-8
< Content-Length: 87
Content-Length: 87
< Connection: keep-alive
Connection: keep-alive
< Docker-Distribution-Api-Version: registry/2.0
Docker-Distribution-Api-Version: registry/2.0
< Www-Authenticate: Basic realm="basic-realm"
Www-Authenticate: Basic realm="basic-realm"
< X-Content-Type-Options: nosniff
X-Content-Type-Options: nosniff

<
* Connection #0 to host registry.openpai.org left intact
```

## use docker client with new registry

```bash
# add new registry to /etc/docker/daemon.json
{
  "insecure-registries": [
    "http://registry.openpai.org:31131"
  ]
}

sudo systemctl restart docker
docker login registry.openapi.org:31131 # with your passwd
docker pull registry.openapi.org:31131/library/alpine # test pull
```