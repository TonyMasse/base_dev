#!/usr/bin/env bash

if [[ "$*" == *help* ]]; then
  echo ""
  echo "Usage: $0 <name for the new image> <option>"
  echo ""
  echo "Options:"
  echo "   --help                Shows this help"
  echo "   --publish             Will publish the image to Docker Hub after building it"
  echo ""
  echo "Example: $0 my_dev --publish"
  echo "Will create a container image called \`my_dev\` and publish it to Docker Hub"
  echo ""
  echo "If no name is provided, the container will be named \`base_dev\`"
  echo ""
  exit 0
fi

if [ $# -eq 0 ]; then
  # If no argument is provided, set the default argument to "base_dev"
  argument="base_dev"
else
  # If an argument is provided, use the first argument
  argument="$1"
fi

versionNumber="v1.4"

# If on Linux, as opposed to Docker Desktop, use the following command to Enable buildx
docker buildx create --use
docker buildx inspect --bootstrap

# docker build -t tonymasse/$argument:v1.4 -t tonymasse/$argument:latest ./ $@
docker buildx build --platform linux/amd64,linux/arm64 -t tonymasse/base_dev:v1.5 -t tonymasse/base_dev:latest ./ --load

if [[ "$*" == *--publish* ]]; then
  echo "### Creating then publishing image \`$argument\` to Docker Hub..."
  docker buildx build --platform linux/amd64,linux/arm64 -t tonymasse/$argument:$versionNumber -t tonymasse/$argument:latest ./ --push $@

  # echo "### Publishing image \`$argument\` to Docker Hub..."
  # docker push --all-tags tonymasse/$argument
else
  echo "### Creating image \`$argument\`..."
  docker buildx build --platform linux/amd64,linux/arm64 -t tonymasse/$argument:$versionNumber -t tonymasse/$argument:latest ./ --load $@
fi

echo "### Done."
