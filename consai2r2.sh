#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"ibis/consai2r2"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"consai2r2"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

EXE=${@:-"/bin/bash"}

## --net=mynetworkname
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.IPAddress}}' ${cname}
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.Gateway}}' ${cname}

if [ "$DOCKER_ROS_IP" == "" ]; then
#    export DOCKER_ROS_IP=127.0.0.1
    export DOCKER_ROS_IP=localhost
fi

NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI"
# for gdb
# NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI --cap-add=SYS_PTRACE --security-opt=seccomp=unconfined"
# NET_OPT="--net=host --env=NVIDIA_DRIVER_CAPABILITIES --env=NVIDIA_VISIBLE_DEVICES"

xhost +si:localuser:root

if [ "$(docker container ls -aq -f name=${cname})" ]; then
    echo "'docker rm ${cname}' is executed."
    docker rm ${cname}
fi

docker run ${OPT}    \
    --privileged     \
    ${NET_OPT}       \
    --env="DOCKER_ROS_SETUP=/catkin_ws/devel/setup.bash" \
    --env="DISPLAY"  \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --gpus=all \
    --name=${cname} \
    --volume="${PROGRAM_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${EXE}