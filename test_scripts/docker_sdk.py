import docker
client = docker.from_env()
from datetime import datetime

starttime = datetime.now()
print(starttime)
registry_addr = 'registry.openpai.org:31131/'
imageName = '{}swordfaith/dockerhub_limit_rate_test_image:v1.0.0'.format(registry_addr)
for i in range(400):
    print(2, i)
    image = client.images.pull(imageName)
    # print(image.id)
    print(client.images.list())
    client.images.remove(image.id, noprune=True)
    print(client.images.list())

endtime = datetime.now()
print(endtime)
print((endtime - starttime).total_seconds)