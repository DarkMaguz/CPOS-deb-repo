FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y dpkg-dev dpkg-sig apt-utils

RUN groupadd -r --gid 1000 cpos && useradd -r --uid 1000 -g cpos cpos
RUN mkdir -p /home/cpos
RUN chown -R cpos:cpos /home/cpos

USER cpos

WORKDIR /home/cpos
