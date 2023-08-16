#!/usr/bin/env bash

# Check if the script is called with exactly one argument
if [[ "$*" == *help* ]]; then
  echo ""
  echo "Usage: $0 <name for the new container> <option>"
  echo ""
  echo "Options:"
  echo "   --help                Shows this help"
  echo "   --no-ports            Will not publish ports 5000-5002"
  echo ""
  echo "Example: $0 base_dev"
  echo "Will create a container named base_dev and will expose ports 5000, 5001 and 5002"
  echo ""
  echo "If no name is provided, the container will be named \`base_dev\`"
  echo ""
  exit 0
fi

if [ $# -eq 0 ]; then
  # If no argument is provided, set the default argument to "DEV"
  argument="base_dev"
else
  # If an argument is provided, use the first argument
  argument="$1"
fi

echo "### Create \`$argument\` Volume..."
docker volume create $argument

echo "### INCREASING USER WATCHES LIMIT (SYSCTL)..."
grep -qxF 'fs.inotify.max_user_watches=1048576' /etc/sysctl.conf || echo "fs.inotify.max_user_watches=1048576" | sudo tee -a /etc/sysctl.conf

echo "### INCREASING USER INSTANCES LIMIT (SYSCTL)..."
grep -qxF 'fs.inotify.max_user_instances=1048576' /etc/sysctl.conf || echo "fs.inotify.max_user_instances=1048576" | sudo tee -a /etc/sysctl.conf

echo "### INCREASING QUEUED EVENTS LIMIT (SYSCTL)..."
grep -qxF 'fs.inotify.max_queued_events=1048576' /etc/sysctl.conf || echo "fs.inotify.max_queued_events=1048576" | sudo tee -a /etc/sysctl.conf

echo "### RELOADING SYSCTL CONFIGURATION..."
sudo sysctl -p

echo "### START CONTAINER..."
if [[ "$*" == *--no-ports* ]]; then
  docker run --detach --restart always --tty --volume $argument:/root/$argument --volume /var/run/docker.sock:/var/run/docker.sock --name $argument tonymasse/base_dev
else
  docker run --detach --restart always --tty --publish 5000:5000/tcp --publish 5001:5001/tcp --publish 5002:5002/tcp --volume $argument:/root/$argument --volume /var/run/docker.sock:/var/run/docker.sock --name $argument tonymasse/base_dev
fi

echo "### CHECK CONTAINER IS RUNNING..."
docker ps | grep "\(CONTAINER ID\)\|\($argument\)"
