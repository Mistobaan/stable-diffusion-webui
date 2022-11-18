ARG CUDA_RELEASE=11.6.2-cudnn8-devel-ubuntu20.04
ARG USER_NAME=ubuntu
ARG UID=1000
ARG GID=1000
FROM nvidia/cuda:${CUDA_RELEASE} AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt update && apt install -y python3 python3-pip git && \
    pip3 install --no-cache-dir --upgrade pip

RUN --mount=type=cache,target=$HOME/.cache/pip pip3 install torch==1.13.0 torchvision --extra-index-url https://download.pytorch.org/whl/cu116

#RUN groupadd -g ${GID} -o ${USER_NAME}
RUN groupadd -g 1000 -o fabrizio
RUN useradd --shell /bin/bash \
    --no-log-init \
    --system \
    --create-home \
    --gid 1000 \
    --uid 1000 \
    fabrizio
# --gid ${GID} \
# --uid ${UID} \
# ${USER_NAME}

#USER ${USER_NAME}
USER fabrizio
ADD requirements.txt /tmp/requirements.txt
RUN --mount=type=cache,target=$HOME/.cache/pip pip3 install -r /tmp/requirements.txt 


USER root
RUN apt install -y libgl1 libopencv-dev python3-opencv
RUN pip3 install opencv-python
USER fabrizio

WORKDIR /app
ADD . /app

EXPOSE 8080
ENTRYPOINT python3 launch.py --port 8080 --listen