#!/bin/bash
set -ex

registry=gabrtvbuild.azurecr.io
dockerOrg=smarthotels
imageTag=$(git rev-parse --abbrev-ref HEAD)
echo "Docker image Tag: $imageTag"

echo "Building Docker images tagged with $imageTag"
export TAG=$imageTag
docker-compose -p .. -f ../../src/docker-compose.yml -f ../../src/docker-compose-tagged.yml  build

echo "Pushing images to $registry/$dockerOrg..."
services="bookings hotels suggestions tasks configuration notifications reviews discounts profiles"
for service in $services; do
  imageFqdn=$registry/${dockerOrg}/${service}
  docker tag smarthotels/${service}:public ${imageFqdn}:$imageTag
  docker push ${imageFqdn}:$imageTag
done
