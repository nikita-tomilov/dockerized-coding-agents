#!/bin/bash
echo -e
docker run --rm -it \
  --network host \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -e HOME=/home/node \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /bin/bash