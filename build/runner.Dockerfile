FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    sudo \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*