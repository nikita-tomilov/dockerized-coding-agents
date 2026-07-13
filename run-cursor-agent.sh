#!/bin/bash
echo -e
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.cursor:/home/node/.cursor" \
  -e HOME=/home/node \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /home/node/.local/bin/agent --force "$@"