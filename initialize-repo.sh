#!/bin/sh -e

docker build -t darkmagus/cpos-deb-repo .

mkdir -p gnupg
mkdir -p repo

docker run -it --rm \
  -v $(pwd)/gnupg:/home/cpos/.gnupg \
  darkmagus/cpos-deb-repo \
  gpg --full-generate-key
