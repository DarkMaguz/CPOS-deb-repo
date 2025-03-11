FROM debian:bookworm-slim

RUN apt-get update -y
RUN apt-get install -y wget libxml2-utils tar bzip2 coreutils grep sed xz-utils

RUN mkdir -p /build

WORKDIR /build

ENTRYPOINT ["./docker-run.sh"]
