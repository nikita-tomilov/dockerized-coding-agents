#!/bin/bash
echo -e
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.pi/agent:/home/node/.pi/agent" \
  -e HOME=/home/node \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /usr/local/bin/pi "$@"