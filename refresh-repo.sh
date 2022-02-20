#!/bin/sh -e

docker run -ti --rm \
  -v $(pwd)/repo:/home/cpos/repo/ \
  -v $(pwd)/gnupg:/home/cpos/.gnupg \
  -v $(pwd)/docker-run.sh:/home/cpos/docker-run.sh \
  -e PASS=$PASS \
  -e KEYID=$KEYID \
  darkmagus/cpos-deb-repo \
  ./docker-run.sh
