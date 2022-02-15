#!/bin/sh -e

docker build -t darkmagus/CPOS-deb-repo .

mkdir -p gnupg
mkdir -p repo

docker run -it --rm \
  -v $(pwd)/gnupg:/root/.gnupg \
  darkmagus/CPOS-deb-repo \
  gpg --full-generate-key
exit

docker run -it --rm \
  -v $(pwd)/repo:/root/repo/ \
  -v $(pwd)/gnupg:/root/.gnupg \
  darkmagus/CPOS-deb-repo \
  gpg --armor --export B4A0F522493B169B > repo/Release.gpg
