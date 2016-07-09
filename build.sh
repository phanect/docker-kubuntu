#! /bin/bash

set -eu

type jq > /dev/null
type mustache > /dev/null

rm --recursive --force ./dist

URL="https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags/"

while [ "$URL" != "null" ]; do
  JSON="$(curl --silent --show-error $URL)"

  for tag in $(echo "$JSON" | jq --raw-output '.results[].name'); do
    mkdir --parents "./dist/$tag"
    echo -e "{ \"version\": \"$tag\" }" | mustache - Dockerfile.mustache > "dist/$tag/Dockerfile"
  done

  URL="$(echo "$JSON" | jq --raw-output '.["next"]')"
done
