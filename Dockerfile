# A docker image based on ubuntu with the following installed:
# - python3
# - pip3
# - git
# - nodejs
# - npm
# - openssl
# - jdk 17
# - Docker
# - AWS SAM CLI
# - Google Cloud SDK

FROM ubuntu:latest

# Update oneself
RUN apt-get update && apt-get upgrade -y

# Install python3 and pip3
RUN apt-get install -y python3 python3-pip

# Install git
RUN apt-get install -y git

# Install nodejs and npm
RUN apt-get install -y nodejs npm

# Install jdk 17
RUN apt-get install -y openjdk-17-jdk

# Install docker
RUN apt-get install -y docker.io

# Install docker-compose
RUN apt-get install -y docker-compose

# # Install docker-machine
# RUN apt-get install -y docker-machine

# # Install docker-machine-driver-vmware
# RUN apt-get install -y docker-machine-driver-vmware

# # Install docker-machine-driver-hyperkit
# RUN apt-get install -y docker-machine-driver-hyperkit

# Install zip and unzip
RUN apt-get install -y zip unzip

# Install curl
RUN apt-get install -y curl

# Prep the Python environment
RUN python3 -m pip install --upgrade pip
RUN pip3 install --upgrade flask
RUN pip3 install --upgrade neo4j
RUN pip3 install --upgrade openai
RUN pip3 install --upgrade pandas

# Install AWS SAM CLI
RUN pip3 install --upgrade awscli

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

WORKDIR /root

COPY . .

# Wait forever
CMD ["tail", "-f", "/dev/null"]
