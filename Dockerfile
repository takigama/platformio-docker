FROM python:3 as stage1

ARG version

ENV PIO_VERSION $version

RUN set -x \
    && pip install platformio==$PIO_VERSION 
