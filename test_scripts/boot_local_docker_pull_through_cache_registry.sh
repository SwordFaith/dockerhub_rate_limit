DOCKER_HUB_USERNAME=''
DOCKER_HUB_ACCESS_TOKEN=''
sudo docker run \
  -d \
  -p 5000:5000 \
  --restart=always \
  --name=through-cache \
  -e REGISTRY_PROXY_REMOTEURL="https://registry-1.docker.io" \
  -e REGISTRY_PROXY_USERNAME=$DOCKER_HUB_USERNAME \
  -e REGISTRY_PROXY_PASSWORD=$DOCKER_HUB_ACCESS_TOKEN \
  registry