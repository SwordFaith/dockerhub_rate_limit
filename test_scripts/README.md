# Get your docker hub rate limit info

```bash
# anonymous
TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
# with user auth
TOKEN=$(curl --user 'username:password' "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
# get limits info
curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest
```

# Use dockerhub official registry image
[Docker Registry Overview](https://docs.docker.com/registry/)
[Deploy a registry server](https://docs.docker.com/registry/d:w
eploying/)