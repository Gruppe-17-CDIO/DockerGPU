# DockerGPU
Repository for all files regarding the docker container which runs darknet on the GPU.

## Requirements

### OS

The scripts requires a Linux OS to work properly. If Windows or Mac is used, then you've to make the scripts yourself.

### Software

Docker obivously needs to be installed.

Furthermore the nvidia runtime needs to be installed to be able to get direct access to the GPU from the container. 

RHEL Example:
  
    sudo dnf install nvidia-docker2

From experience it has to be "nvidia-docker2" and not "nvidia-docker" for things to work.

### Drivers
The device needs to have NVIDIA drivers installed to work.

### Port forwarding

You've to set port forwarding up on your router, so that a client can communicate with the server.

## How to

Make sure the Docker daemon is running, and navigate into the directory containing the Dockerfile. 
Then run:

    ./build.sh
    
It takes quite a long time.

When it's built you run:

    ./run.sh
    
Then the container starts, and the server is up and running.
