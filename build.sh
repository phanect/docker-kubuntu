#! /bin/bash

set -eu

type jq > /dev/null
type mustache > /dev/null

rm --recursive --force ./dist

for tag in $(curl --silent --show-error https://registry.hub.docker.com/v1/repositories/ubuntu/tags | jq --raw-output '.[]["name"]'); do
  mkdir --parents "./dist/$tag"
  echo -e "{ \"version\": \"$tag\" }" | mustache - Dockerfile.mustache > "dist/$tag/Dockerfile"
done
