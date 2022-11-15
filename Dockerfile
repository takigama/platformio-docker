FROM ubuntu:22.04

ARG version

ENV PIO_VERSION $version

RUN set -x \
    && apt update \
    && apt install -y python3-pip git file bash \
    && pip install platformio==$PIO_VERSION 
