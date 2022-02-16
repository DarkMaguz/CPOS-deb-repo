#!/bin/sh -e

docker run -it --rm \
  -v $(pwd)/repo:/home/cpos/repo/ \
  -v $(pwd)/gnupg:/home/cpos/.gnupg \
  -v $(pwd)/docker-run.sh:/home/cpos/docker-run.sh \
  darkmagus/cpos-deb-repo \
  ./docker-run.sh
