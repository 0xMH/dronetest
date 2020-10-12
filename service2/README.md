# PrivateIP
Dockerfile to log PublicIP and PrivateIP on the logs panel in ECS, and to listen on a specific port using a dummy node service.

> **Disclaimer:** This docker file was built in a hurry to help debugging AWS ECS Network problem so It doesn't follow the be best standards out there. 

Port `80` is the default port to listen on, but you can change it by using `build-arg` when building the image:
```
docker build --build-arg PORT=8070 -t debug .
```
You can run the container directly using 
```
docker run  -P -d mohamedhamza/privateip
```
