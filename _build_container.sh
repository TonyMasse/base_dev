#!/usr/bin/env bash

docker build -t tonymasse/base_dev:v1.3 -t tonymasse/base_dev:latest ./ $@
docker push --all-tags tonymasse/base_dev
