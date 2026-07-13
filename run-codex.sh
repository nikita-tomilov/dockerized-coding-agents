#!/bin/bash
echo -e
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.codex:/home/node/.codex" \
  -v "$HOME/.config/codex:/home/node/.config/codex" \
  -e HOME=/home/node \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /usr/local/bin/codex --sandbox danger-full-access "$@"