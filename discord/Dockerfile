FROM debian:trixie-slim

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates \
  openssl gpg gnupg2 curl wget \
  python3 python3-pycurl python3-apt python3-certifi

# Add CPOS deb repo to get the current version of discord.
RUN echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/CPOS.gpg] https://darkmagus.dk/cpos/repo/ /" > /etc/apt/sources.list.d/cpos.list
RUN wget -q -O - https://darkmagus.dk/cpos/repo/CPOS.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/CPOS.gpg

RUN mkdir -p /build
WORKDIR /build

ENTRYPOINT ["python3", "docker-run.py"]
