#! /bin/bash

set -eu

rm -rf ./dist

for tag in $(curl -sS https://registry.hub.docker.com/v1/repositories/ubuntu/tags | jq --raw-output '.[]["name"]'); do
  mkdir --parents "./dist/$tag"
  echo -e "{ \"version\": \"$tag\" }" | mustache - Dockerfile.mustache > "dist/$tag/Dockerfile"
done
