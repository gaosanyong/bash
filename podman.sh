#! /bin/bash

# docker - client-server model with a daemon requiring root access
# podman - daemonless, rootless container engine 

# install podman with Dandified Yum
sudo dnf -y install podman 

# start podman machine if required 
# on Mac/Windows, start podman machine which is a vm to run containers
# on Linux, containers are supported natively and thus no podman machine is required 
podman machine init # initialize vm first time
podman machine start 

# set up registry 
# podman works with use Fully Qualified Container Name (FQCN) as it doesn't allow default registry. 
podman login registry.redhat.io 
# Username: Red Hat developer account credential
# Password: 

# <account>.dkr.ecr.<region>.amazonaws.com | Amazon elstic container registry 
# docker.io/library                        | Docker container registry
# ghcr.io                                  | GitHub container registry 
# registry.access.redhat.com               | RedHat public container registry
# registry.redhat.io                       | RedHat private container registry
# quay.io                                  | Quay container registry (sponsored by RedHat)

# pull universal base image (ubi)
podman pull registry.redhat.io/ubi9/ubi 

# list images in local storage 
podman images 
podman image list # does the same 

# run command in new container 
podman run ubi 

# list running containers 
podman ps 
# note: 
#   - use `podman images` to list images
#   - use `podman ps` to list containers 
# image is container template while container is running image
# CONTAINER ID  IMAGE  COMMAND  CREATED  STATUS  PORTS  NAMES

# list all containers 
podman ps -a 

# run `echo hello world` through container 
podman run ubi echo hello world 

# 
podman run nginx 
podman run -d nginx # run nginx container in detached mode (background)
podman run -it ubi  # run container in interactive terminal 

# run nginx image from docker registry 
podman run docker.io/library/nginx 

# 
podman inspect <container> -f "{{.NetworkSettings.IPAddress}}"

podman stop  <container> # stop a container 
podman start <container> # start a stopped container 

# note: 
# - podman run <image>
# - podman start <container>

# note: 
# - podman exec -it <container> sh # runs a shell as secondary process in container 
# - podman run -it <container> sh  # runs a shell as primary process in container 

# ctrl-p, ctrl-q detaches from an interaction terminal with a container 
podman attach <container> # attach to container 

podman run --name myweb -it nginx sh 
# ctrl-p, ctrl-q 
podman inspect myweb | less 
podman image inspect nginx | less 
# note: 
# - podman inspect <container> 
# - podman image inspect <image> 
podman attach myweb 

# use environment variable to provide site-specific info
podman run docker.io/library/mariadb 
podman ps -a 
# dac76abbe8ac  docker.io/library/mariadb:latest    mariadbd              9 seconds ago   Exited (1) 9 seconds ago       3306/tcp    angry_lamarr

podman logs angry_lamarr
# 2025-04-25 03:59:37+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:11.7.2+maria~ubu2404 started.
# 2025-04-25 03:59:37+00:00 [Warn] [Entrypoint]: /sys/fs/cgroup///memory.pressure not writable, functionality unavailable to MariaDB
# 2025-04-25 03:59:37+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
# 2025-04-25 03:59:37+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:11.7.2+maria~ubu2404 started.
# 2025-04-25 03:59:37+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
# 	You need to specify one of MARIADB_ROOT_PASSWORD, MARIADB_ROOT_PASSWORD_HASH, MARIADB_ALLOW_EMPTY_ROOT_PASSWORD and MARIADB_RANDOM_ROOT_PASSWORD

podman run mariadb -d -e MARIADB_ROOT_PASSWORD=password mariadb

man podman-run 
podman help run | less 

# checkout current network 
podman network ls 

# start container in different network namespace 
podman network create 

# 
podman run -d -p 8088:80 nginx 
curl localhost:8088

# 
sudo podman run --memory=1G --cpu-shares=512 -d bitnami/nginx:latst 

# cgroup restrictions don't work for rootless containers 
# /etc/containers/containers.conf
# [containers]
# pids_limit=0
# sudo mkdir /etc/systemd/system/user@.service.d/
# touch /etc/systemd/system/user@.service.d/delegate.conf
# [Service]
# Delegate=memory pids cpu io
# sudo systemctl daemon-reload
podman run -d -m 512M registry.redhat.io/ubi9/ubi sleep 1800 
podman stats
# ctrl-c 

# provide a list of unqualified search registries at /etc/containers/registries.conf
# on Mac/Windows this file can be found on Podman VM 
podman machine ssh 
vi /etc/containers/registries.conf 
# docker.io 
# registry.access.redhat.com # open to public 
# registry.redhat.io # open to registered rh user
# quay.io # community registry sponsored by rh 

grep 'unqualified-search' /etc/containers/reigstries.conf
# unqualified-search-registries = ["registry.fedoraproject.org", "registry.access.redhat.com", "docker.io"]

# default image pull policy = fetch only when locally unavailable
podman run --pull=never <image>   # needs to be locally available; otherwise fail
podman run --pull=always <image>
podman run --pull=newer <image>
podman run --pull=missing <image>

# images are stored separately for users 
podman image list              # list local images
podman image inspect <image>   # show image detail
podman image rm <image>        # remove image 
podman image prune             # remove unused images 
podman image tree <image>      # list layers of image 

# build images 
# 1. from scratch using Containerfile, aka file-build;
# 2. from changes made to running container, aka container-build; 
# 3. from building tools e.g. buildah, aka tool-build.  
podman run --name customweb -it nginx sh 
# touch /tmp/testfile
# exit 
podman commit customweb nginx:custom # save change to image:tag 
podman images 
podman run -it localhost/nginx:custom ls -l /tmp/testfile # localhost prefix added for locally-build images





# stop podman vm on Mac/Windows
podman machine stop 

# reference - podman commands 
#   artifact    Manage OCI artifacts
#   attach      Attach to a running container
#   auto-update Auto update containers according to their auto-update policy
#   build       Build an image using instructions from Containerfiles
#   commit      Create new image based on the changed container
#   compose     Run compose workloads via an external provider such as docker-compose or podman-compose
#   container   Manage containers
#   cp          Copy files/folders between a container and the local filesystem
#   create      Create but do not start a container
#   diff        Display the changes to the object's file system
#   events      Show podman system events
#   exec        Run a process in a running container
#   export      Export container's filesystem contents as a tar archive
#   farm        Farm out builds to remote machines
#   generate    Generate structured data based on containers, pods or volumes
#   healthcheck Manage health checks on containers
#   help        Help about any command
#   history     Show history of a specified image
#   image       Manage images
#   images      List images in local storage
#   import      Import a tarball to create a filesystem image
#   info        Display podman system information
#   init        Initialize one or more containers
#   inspect     Display the configuration of object denoted by ID
#   kill        Kill one or more running containers with a specific signal
#   kube        Play containers, pods or volumes from a structured file
#   load        Load image(s) from a tar archive
#   login       Log in to a container registry
#   logout      Log out of a container registry
#   logs        Fetch the logs of one or more containers
#   machine     Manage a virtual machine
#   manifest    Manipulate manifest lists and image indexes
#   mount       Mount a working container's root filesystem
#   network     Manage networks
#   pause       Pause all the processes in one or more containers
#   pod         Manage pods
#   port        List port mappings or a specific mapping for the container
#   ps          List containers
#   pull        Pull an image from a registry
#   push        Push an image to a specified destination
#   rename      Rename an existing container
#   restart     Restart one or more containers
#   rm          Remove one or more containers
#   rmi         Remove one or more images from local storage
#   run         Run a command in a new container
#   save        Save image(s) to an archive
#   search      Search registry for image
#   secret      Manage secrets
#   start       Start one or more containers
#   stats       Display a live stream of container resource usage statistics
#   stop        Stop one or more containers
#   system      Manage podman
#   tag         Add an additional name to a local image
#   top         Display the running processes of a container
#   unmount     Unmount working container's root filesystem
#   unpause     Unpause the processes in one or more containers
#   unshare     Run a command in a modified user namespace
#   untag       Remove a name from a local image
#   update      Update an existing container
#   version     Display the Podman version information
#   volume      Manage volumes
#   wait        Block on one or more containers
