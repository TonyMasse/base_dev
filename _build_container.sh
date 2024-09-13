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

versionNumber="v1.5"

# Build the builder
echo "### Build the container builder..."
docker buildx create --name container-builder --driver docker-container --use
docker buildx inspect --bootstrap


echo "### Building image \`$argument\` ($versionNumber)..."
docker buildx build --platform linux/amd64,linux/arm64 -t tonymasse/$argument:$versionNumber -t tonymasse/$argumentv:latest ./ --load $@


if [[ "$*" == *--publish* ]]; then
  echo "### Publishing image \`$argument:$versionNumber\` to Docker Hub..."
  docker push tonymasse/$argumentv:$versionNumber
  echo "### Publishing image \`$argument:latest\` to Docker Hub..."
  docker push tonymasse/$argument:latest
fi

echo "### Done."
