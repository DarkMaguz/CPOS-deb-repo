FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y dpkg-dev dpkg-sig apt-utils

RUN mkdir -p /root/repo

WORKDIR /root/repo
