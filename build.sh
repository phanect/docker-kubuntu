#! /bin/bash

# set -u is not done here to avoid error by pyvenv bug
# See: https://github.com/pypa/virtualenv/issues/150
set -e

pyvenv virtualenv
source ./virtualenv/bin/activate
pip install -r requirements.txt

rm -rf ./dist

for tag in $(curl -sS https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags/ | jq --raw-output '."results"[]["name"]'); do
  mkdir --parents ./dist/$tag
  echo '{ "version": "'$tag'" }' | jinja2 --format=json ./Dockerfile.j2 > dist/$tag/Dockerfile
done
