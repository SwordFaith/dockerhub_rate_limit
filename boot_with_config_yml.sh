docker run -d -p 5000:5000 --restart=always --name registry \
    -v `pwd`/config.yml:/etc/docker/registry/config.yml \
    -v `pwd`/auth/htpasswd:/auth/htpasswd \
    registry:2