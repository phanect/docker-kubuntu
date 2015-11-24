#! /bin/bash

# set -u is not done here to avoid error by pyvenv bug
# See: https://github.com/pypa/virtualenv/issues/150
set -e

pyvenv virtualenv
source ./virtualenv/bin/activate
pip install -r requirements.txt

rm -rf ./dist

# Install jq 1.5
# On K/Ubuntu 14.04 only jq 1.3 is available and ."results"[]["name"] is unsupported syntax
mkdir --parents ./tmp
curl --location --silent --show-error --output ./tmp/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x ./tmp/jq

for tag in $(curl -sS https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags/ | ./tmp/jq --raw-output '."results"[]["name"]'); do
  mkdir --parents ./dist/$tag
  echo '{ "version": "'$tag'" }' | jinja2 --format=json ./Dockerfile.j2 > dist/$tag/Dockerfile
done
